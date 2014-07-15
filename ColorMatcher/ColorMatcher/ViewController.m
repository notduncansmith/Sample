//
//  ViewController.m
//  ColorMatcher
//
//  Created by Eric Stroh on 7/12/14.
//  Copyright (c) 2014 Eric Stroh. All rights reserved.
//
#import "ViewController.h"
#import "ColorMatcher-Swift.h" //header that contains the entirety of our swift interface, click on this to view how the compiler converts the swift to a header file containing some Obj-C

//this is different for a framework however.  In a framework, from your .h file you would use a forward declaration to the class.  ie @class ESTimer; then you can set a property to it.  In the .m implementation file you would import using framework style <NameOfFrameWork/NameOfFrameWork-Swift.h>



#define kMaxColorValue 255
#define kFluctuation 11

@interface ViewController ()<ESTimerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UIView *masterColorView;
@property (weak, nonatomic) IBOutlet UIView *yourColorView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController{
    float redValue;
    float blueValue;
    float greenValue;
    ESTimer *timer;
    
}
            
- (void)viewDidLoad {
    [super viewDidLoad];
    _statusLabel.text = @"Match the colors";
    [self resetRandomColors];
    [self resetMasterColorBackground];
    [self updateYourColorAndVerify:nil];
    timer = [[ESTimer alloc] init];
    //timer = [ESTimer newInstance] ; if you were getting an instance of a pure Swift file
    [timer createTimer];
    timer.delegate = self;
    
    UIView *timerView = [timer retrieveCountDownView];
    [self.view addSubview:timerView];
    [self setUpConstraintsFor:timerView];
    self.delegate = timer;
    _startButton.hidden = YES;
}
-(void)resetRandomColors{
    redValue = [self getRandom:0 to:kMaxColorValue];
    greenValue =[self getRandom:0 to:kMaxColorValue];
    blueValue = [self getRandom:0 to:kMaxColorValue];
}
-(void)resetMasterColorBackground{
    _masterColorView.backgroundColor = [UIColor colorWithRed:redValue/kMaxColorValue green:greenValue/kMaxColorValue blue:blueValue/kMaxColorValue  alpha:1.0];
}

//ESTimerDelegate implementation
-(void)timeIsUp{
    _statusLabel.text = @"Time is up";
    _startButton.hidden = NO;
    _controlButton.hidden = YES;
    [self resetRandomColors];
    if([self.delegate respondsToSelector:@selector(pauseTimer)]){
        [self.delegate pauseTimer];
    }
    [self assignSlidersEnabled:NO];
}

- (IBAction)controlButtonPushed:(id)sender {
    //switch between paused and running
    if([timer isCounting]){
        _startButton.hidden = NO;
        _controlButton.hidden = YES;
        if([self.delegate respondsToSelector:@selector(pauseTimer)]){
            [self.delegate pauseTimer];
        }
        [self assignSlidersEnabled:NO];
    }
    else{
        _startButton.hidden = YES;
        _controlButton.hidden = NO;
        if([self.delegate respondsToSelector:@selector(restartTimer)]){
            [self.delegate restartTimer];
        }
        if([_statusLabel.text isEqualToString:@"Time is up"]){
            [self resetMasterColorBackground];
        }
        [self assignSlidersEnabled:YES];
    }
}

-(void)assignSlidersEnabled:(BOOL)enabled{
    _redSlider.userInteractionEnabled = enabled;
    _greenSlider.userInteractionEnabled = enabled;
    _blueSlider.userInteractionEnabled = enabled;
}


#define ARC4RANDOM_MAX   0x100000000
//create a random # between start and end
-(float)getRandom:(CGFloat)start to:(CGFloat)end{
    double arc = (double)arc4random();
    float val = (arc/ARC4RANDOM_MAX);
    return val*(end-start)+start;
}


-(IBAction)updateYourColorAndVerify:(id)sender{
    //change the color of your rectangle based on the slider
    UIColor *yourColor = [UIColor colorWithRed:_redSlider.value/kMaxColorValue green:_greenSlider.value/kMaxColorValue blue:_blueSlider.value/kMaxColorValue alpha:1.0];
    _yourColorView.backgroundColor = yourColor;
    
    //check if you are close
    if([self isClose:_redSlider toValue:redValue] &&
        [self isClose:_greenSlider toValue:greenValue] &&
       [self isClose:_blueSlider toValue:blueValue]){
        if(![_statusLabel.text isEqualToString:@"Time is up"]){
            _statusLabel.text = @"Good Job";
        }
        
    }
}
-(BOOL)isClose:(UISlider *)slider toValue:(float)number{
    return slider.value+kFluctuation>number && number+kFluctuation>slider.value;
}


-(void)setUpConstraintsFor:(UIView *)view{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:view.frame.size.height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:view.frame.size.width]];
    
    
}



@end
