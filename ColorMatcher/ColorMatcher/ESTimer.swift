//
//  ESTimer.swift
//  ColorMatcher
//
//  Created by Eric Stroh on 7/12/14.
//  Copyright (c) 2014 Eric Stroh. All rights reserved.
//

import Foundation
import UIKit

/*Point 10 - Enumerations in Swift will not get imported back to Objective-C*/
enum CurrentTimerState: Int {
    case kCounting
    case kPaused
}

@objc protocol ESTimerDelegate{//Point 6 put the @objc so that it will be available to objc classes
    func timeIsUp()
}

class ESTimer:NSObject,ControllerDelegate {//Point 6do not need to add @objc if the class extends a class in an existing framework such as UIKit  Point 7 protocols go in comma-seperated list
    
    /*Point 3*/
    //All values including object references are guaranteed to have a non-nil value
    var internalTimer:NSTimer! //all properties are strong by default
    //the ? means the value is optional, we will initialize this later so leaving it as optional for now
    let timeout = 60
    var currentTime = 0
    var myCounterView:AnyObject!// the CountdownView isn't in scope yet so we use the Swift version of id as AnyObject and instatiate with the correct class later
    weak var delegate:ESTimerDelegate?  //optional because we might not have a delegate
    var timerState:CurrentTimerState = .kCounting
    
    init(){
/*Point1  */      myCounterView = CountdownView(frame: CGRectMake(0,0,20,20))//command click on frame will take you to the Swift version of the UIView initializer
    }
    

    // Need to add a class level initializer if you don't extend NSObject
    class func newInstance() -> ESTimer {
        return ESTimer()/*Point1 this calls init() for ESTimer */
    }

    
    func createTimer(){
        /*point 4* Closures*/
        dispatch_async(dispatch_get_main_queue(), {
            /*Point2 class method*/
           self.internalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, /*Point 5*/selector: "timerFunction", userInfo: nil, repeats: true);
        })
    }
    
    func timerFunction(){
        if timerState==CurrentTimerState.kCounting{
            currentTime++
            if (timeout-currentTime)==0{
                self.delegate?.timeIsUp()   //if the delegate is a non-nil value that responds to the selector then it makes the call to timeIsUp
            }
        }
        /*Point 3 checking and unwrapping an implicitly unwrapped optional*/
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