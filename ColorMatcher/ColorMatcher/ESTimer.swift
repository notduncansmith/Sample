//
//  ESTimer.swift
//  ColorMatcher
//
//  Created by Eric Stroh on 7/12/14.
//  Copyright (c) 2014 Eric Stroh. All rights reserved.
//

import Foundation
import UIKit

/*Enumerations in Swift will not get imported back to Objective-C*/
enum CurrentTimerState: Int {
    case kCounting
    case kPaused
}

@objc protocol ESTimerDelegate{//put the @objc so that it will be available to objc classes
    func timeIsUp()
}

class ESTimer:NSObject,ControllerDelegate {//do not need to add @objc if the class extends a class in an existing framework such as UIKit, protocols go in comma-seperated list
    
    //All values including object references are guaranteed to have a non-nil value
    //all properties are strong by default
    
    var internalTimer:NSTimer!
    //the ! means the value is an implicity unwrapped optional, we will initialize this later 
    
    let timeout = 60
    var currentTime = 0
    var myCounterView:AnyObject!
    // the CountdownView isn't in scope yet so we use the Swift version of id as AnyObject and instatiate with the correct class later (NOTE:This was  bug is first beta version.  You can use an optional CountdownView here and will not need the cast shown later.  However, for demonstration purposes, I will leave it as AnyObject so that you can see how to cast
    weak var delegate:ESTimerDelegate?  //optional value because we might not have a delegate
    var timerState:CurrentTimerState = .kCounting
    
    init(){
     myCounterView = CountdownView(frame: CGRectMake(0,0,20,20))//command click on frame will take you to the Swift version of the UIView initializer
    }
    

    // Need to add a class level initializer if you don't extend an Objective C class
    /*class func newInstance() -> ESTimer {
        return ESTimer()/*Point1 this calls init() for ESTimer */
    }*/

    
    func createTimer(){
        //Notice closure/block syntax
        dispatch_async(dispatch_get_main_queue(), {
           self.internalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFunction", userInfo: nil, repeats: true);
            //Notice the selector syntax above
            //bool is represented with true/false
        })
    }
    
    func timerFunction(){
        if timerState==CurrentTimerState.kCounting{
            currentTime++
            if (timeout-currentTime)==0{
                self.delegate?.timeIsUp()   //if the delegate is a non-nil value that responds to the selector then it makes the call to timeIsUp
            }
        }
        /*checking and unwrapping an implicitly unwrapped optional*/
        if let counterView = myCounterView as? CountdownView{
            counterView.timeLabel.text = "\(timeout-currentTime)"
        }
    }
    
    func retrieveCountDownView()->UIView{
        let counterView = myCounterView as? CountdownView
        return counterView!//this cast is a forced cast says that you are sure that it will succeed, a runtime error will occur if it does not.
    }
    
    
    //implement ControllerDelegate methods
    func  pauseTimer() {
        timerState = .kPaused
    }
    func restartTimer(){
        //restart from beginning if they timed out
        if currentTime==timeout{
            currentTime = 0
        }
        timerState = .kCounting
    }

    func isCounting()->Bool{
        if(timerState==CurrentTimerState.kCounting){
            return true;
        }
        return false;
    }
}