//
//  PowerDownInfo.x
//  PowerDown Info
//
//  Created by Haifisch on 09.01.2014.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//
/* 
	Todo:
		Implement CKBlurView
		Battery time left
		Slide to ACTION
	Note to reader:
		I'm truely sorry for doing what I did here. It's bad, I know, but I'm sorry. If you'd like to fix this up, be my guest. It just works.
		I'd also like to say sorry in advanced for any future mistakes.

	For friendly neighbourhood developer,
		Haifisch
*/

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TeleponyUI/TPBottomLockBar.h"
#import <UIKit/UIKit.h>
#include <substrate.h>
#import "CKBlurView.h"
#import "MBSliderView.h"
// Header stuff I didn't put into header files
// Im so sorry
@interface SBUIController 
+(SBUIController *)sharedInstance;
-(int)displayBatteryCapacityAsPercentage;

@end
@class SBAlert;

@interface SBAlertView : UIView
@end

@interface SBPowerDownView : SBAlertView <MBSliderViewDelegate>
{
    NSTimer *_autoDismissTimer;
    UIView *_darkeningUnderlay;
    UIView *_topContainer;
    UIView *_topBar;
    UIView *_topBarLabelBackgroundView;
    UIView *_bottomContainer;
    UIView *_bottomBar;
    UILabel *_bottomBarLabel;
    _Bool _addedFakeStatusBar;
    _Bool _hiddenLockScreenForeground;
    struct CGPoint _slideGestureInitialPoint;
}
- (BOOL)charging;
- (float)batteryLevel;
- (BOOL)fullyCharged;
-(BOOL)doesDoubleTap;
- (void)_animatePowerDown;
- (void)_slideCompleted:(_Bool)arg1;
- (void)_notifyDelegateCancelled;
- (void)_notifyDelegatePowerDown;
- (void)_resetAutoDismissTimer;
- (void)_cancelAutoDismissTimer;
- (id)_newDarkeningView:(struct CGRect)arg1;
- (void)_removeFakeStatusBarIfNecessary;
- (void)_addFakeStatusBarIfNecessary;
- (id)_lockScreenView;
- (_Bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;
- (void)_touchGestureRecognizer:(id)arg1;
- (void)_slideGestureRecognizer:(id)arg1;
- (void)layoutForInterfaceOrientation:(long long)arg1;
- (_Bool)isSupportedInterfaceOrientation:(long long)arg1;
- (void)animateOut;
- (void)animateIn;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;

@end
// SpringBoard classes
@interface SpringBoard : UIApplication
- (void)reboot;
- (void)_rebootNow;
- (void)_relaunchSpringBoardNow;
- (void)relaunchSpringBoard;
@end

%group main
%hook SBPowerDownView

UIView *firstButton;
UIView *secondButton;

UILabel *uptimeLabel;
NSTimer *batterytimer;

%new
- (float)batteryLevel {
    @try {
        UIDevice *Device = [UIDevice currentDevice];
        Device.batteryMonitoringEnabled = YES;
        float BatteryLevel = 0.0;
        float BatteryCharge = [Device batteryLevel];
        if (BatteryCharge > 0.0f) {
            BatteryLevel = BatteryCharge * 100;
        } else {
            return -1;
        }
        
        // Output the battery level
        return BatteryLevel;
    }
    @catch (NSException *exception) {
        // Error out
        return -1;
    }
}
%new
- (BOOL)charging {
    @try {
        UIDevice *Device = [UIDevice currentDevice];
        Device.batteryMonitoringEnabled = YES;
        if ([Device batteryState] == UIDeviceBatteryStateCharging || [Device batteryState] == UIDeviceBatteryStateFull) {
            return true;
        } else {
            return false;
        }
    }
    @catch (NSException *exception) {
        return false;
    }
}
%new
- (BOOL)fullyCharged {
    @try {
        UIDevice *Device = [UIDevice currentDevice];
        Device.batteryMonitoringEnabled = YES;
        if ([Device batteryState] == UIDeviceBatteryStateFull) {
            return true;
        } else {
            return false;
        }
    }
    @catch (NSException *exception) {
        // Error out
        return false;
    }
}

%new 
-(BOOL)doesDoubleTap{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.repower.plist"]] objectForKey:@"doubletap"] boolValue];
}
%new
-(void)respring{
	[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}
%new
-(void)reboot{
	[(SpringBoard *)[UIApplication sharedApplication] _rebootNow];
}
%new
- (void) sliderDidSlide:(MBSliderView *)slideView {
    NSLog(@"%@", slideView);
    if ([slideView.text isEqual:@"Slide to reboot"])
    {
    	NSLog(@"Rebooting");
    }
}
- (void)animateIn{
	//[UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:[UIDevice currentDevice]];
    //batterytimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(batteryLevelChanged) userInfo:nil repeats:YES];
	
	// First button view
	firstButton = [[UIView alloc] initWithFrame:CGRectMake(16,135,288,65)];
	firstButton.layer.cornerRadius = 5;
	firstButton.layer.masksToBounds = YES;
	firstButton.opaque = NO;
	firstButton.alpha = 0.8;
    firstButton.backgroundColor = [UIColor colorWithRed:184.0/255.0 green:111.0/255.0 blue:39.0/255.0 alpha:0.9];
    // Second button view
	secondButton = [[UIView alloc] initWithFrame:CGRectMake(16,220,288,65)];
	secondButton.layer.cornerRadius = 5;
	secondButton.layer.masksToBounds = YES;
	secondButton.opaque = NO;
	secondButton.alpha = 0.8;
    secondButton.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:160.0/255.0 blue:46.0/255.0 alpha:0.9];
    // Uptime text label
	uptimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,firstButton.bounds.size.width,30)];
	uptimeLabel.textAlignment = NSTextAlignmentCenter;
	uptimeLabel.textColor = [UIColor whiteColor];
	[uptimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
	if ([self charging])
	{
		uptimeLabel.text = [NSString stringWithFormat:@"Charging at %f", [self batteryLevel]];
	}
	// Respring Button
	UIButton *respringBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (![self doesDoubleTap])
	{	
		[respringBTN setTitle:@"Double tap to Respring" forState:UIControlStateNormal];
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respring)];
		tapRecognizer.numberOfTapsRequired = 2;
		tapRecognizer.numberOfTouchesRequired = 1;
		[respringBTN addGestureRecognizer:tapRecognizer];
	}else {
		[respringBTN setTitle:@"Tap to Respring" forState:UIControlStateNormal];
		[respringBTN addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchDown];	
	}
	respringBTN.frame = CGRectMake(0, 0, secondButton.bounds.size.width, secondButton.bounds.size.height);
	[respringBTN.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:25]];
	[respringBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	// Reboot button
	UIButton *rebootBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (![self doesDoubleTap])
	{
		[rebootBTN setTitle:@"Double tap to Reboot" forState:UIControlStateNormal];
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reboot)];
		tapRecognizer.numberOfTapsRequired = 2;
		tapRecognizer.numberOfTouchesRequired = 1;
		[rebootBTN addGestureRecognizer:tapRecognizer];
	}else {
		[rebootBTN setTitle:@"Tap to Reboot" forState:UIControlStateNormal];
		[rebootBTN addTarget:self action:@selector(reboot) forControlEvents:UIControlEventTouchDown];
	}
	rebootBTN.frame = CGRectMake(0, 0, firstButton.bounds.size.width, firstButton.bounds.size.height);
	[rebootBTN.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:25]];
	[rebootBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	// Slide to views
	MBSliderView *s1 = [[MBSliderView alloc] initWithFrame:CGRectMake(15,0, firstButton.frame.size.width, firstButton.frame.size.height)];
    [s1 setText:@"slide to reboot"]; // set the label text
    [s1 setDelegate:self]; // set the MBSliderView delegate
	// Add views
	[self addSubview:firstButton];
	[self addSubview:secondButton];
	//[debugView addSubview:uptimeLabel];
	[firstButton addSubview:s1];
	//[firstButton addSubview:rebootBTN];
	[secondButton addSubview:respringBTN];
	// Process nice fade in
	CATransition *applicationLoadViewIn =[CATransition animation];
	[applicationLoadViewIn setDuration:0.75];
	[applicationLoadViewIn setType:kCATransitionReveal];
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[[firstButton layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
	[[secondButton layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
	%orig;
}
- (void)animateOut{
	// Process nice fade out
	CATransition *transition = [CATransition animation];
	transition.duration = 0.75;
	[transition setType:kCATransitionFade];
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	[transition setFillMode:@"extended"];
	[[firstButton layer] addAnimation:transition forKey:nil];
	[[secondButton layer] addAnimation:transition forKey:nil];
	[CATransaction commit];
	// Remove views
	[secondButton removeFromSuperview];
	[firstButton removeFromSuperview];
	%orig;
}

%end
%end


%ctor {
	@autoreleasepool {
		%init(main);
	}
}
