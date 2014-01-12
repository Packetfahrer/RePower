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
#include <notify.h>
#import <substrate.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TeleponyUI/TPBottomLockBar.h"
#import <UIKit/UIKit.h>
#import "CKBlurView.h"
#import "MBSliderView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
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
- (void)listSubviewsOfView:(UIView *)view;
-(void)safemode;
-(BOOL)isSafemode;
-(void)respring;
-(void)reboot;
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

CKBlurView *blurViewGreen;
CKBlurView *blurViewOrange;

%new 
-(BOOL)isEnabled{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.repower.plist"]] objectForKey:@"isEnabled"] boolValue];
}
%new 
-(BOOL)isSafemode{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.repower.plist"]] objectForKey:@"safemodeInstead"] boolValue];
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
-(void)safemode{
	system("killall -SEGV SpringBoard");
}
%new
- (void) sliderDidSlide:(MBSliderView *)slideView {
    NSLog(@"%@", slideView);
    if ([slideView.text isEqual:@"slide to reboot"])
    {
    	[self reboot];
    }else if ([slideView.text isEqual:@"slide to respring"])
    {
    	[self respring];
    }else if ([slideView.text isEqual:@"slide to safemode"])
    {
    	[self safemode];
    }
}
%new 
- (void)listSubviewsOfView:(UIView *)view {

    // Get the subviews of the view
    NSArray *subviews = [view subviews];

    // Return if there are no subviews
    if ([subviews count] == 0) return;

    for (UIView *subview in subviews) {

        // Do what you want to do with the subview
        NSLog(@"%f", subview.bounds.origin.y);

        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}
- (void)animateIn{
	[self listSubviewsOfView:self];
	// First button view
	firstButton = [[UIView alloc] initWithFrame:CGRectMake(16,183.5,288,65)];
	firstButton.layer.cornerRadius = 5;
	firstButton.layer.masksToBounds = YES;
	firstButton.opaque = NO;
	firstButton.backgroundColor = [UIColor clearColor];
    // Second button view
	secondButton = [[UIView alloc] initWithFrame:CGRectMake(16,319.5,288,65)];
	secondButton.layer.cornerRadius = 5;
	secondButton.layer.masksToBounds = YES;
	secondButton.opaque = NO;
    secondButton.backgroundColor = [UIColor clearColor];

	UIColor *blurTint = UIColorFromRGB(0x8D5E21);
	UIColor *blurTintGreen = UIColorFromRGB(0x3D8230);
	UIColor *blurTintGrey = UIColorFromRGB(0x4F5F79);

	const CGFloat *rgb = CGColorGetComponents(blurTint.CGColor);
	const CGFloat *rgbGreen = CGColorGetComponents(blurTintGreen.CGColor);
	const CGFloat *rgbGrey = CGColorGetComponents(blurTintGrey.CGColor);

    CAFilter *tintFilter = [CAFilter filterWithName:@"colorAdd"];
    CAFilter *tintFilterGreen = [CAFilter filterWithName:@"colorAdd"];
    CAFilter *tintFilterGrey = [CAFilter filterWithName:@"colorAdd"];

    [tintFilter setValue:@[@(rgb[0]), @(rgb[1]), @(rgb[2]), @(CGColorGetAlpha(blurTint.CGColor))] forKey:@"inputColor"];
    [tintFilterGreen setValue:@[@(rgbGreen[0]), @(rgbGreen[1]), @(rgbGreen[2]), @(CGColorGetAlpha(blurTintGreen.CGColor))] forKey:@"inputColor"];
    [tintFilterGrey setValue:@[@(rgbGrey[0]), @(rgbGrey[1]), @(rgbGrey[2]), @(CGColorGetAlpha(blurTintGrey.CGColor))] forKey:@"inputColor"];

	// Blur views
	blurViewOrange = [[CKBlurView alloc] initWithFrame:firstButton.bounds];
	[blurViewOrange setTintColorFilter:tintFilter];
	blurViewOrange.blurRadius = 10.0f;
    blurViewOrange.blurCroppingRect = blurViewOrange.frame;
    blurViewOrange.alpha = 1.f;
	[firstButton addSubview:blurViewOrange];
	[blurViewOrange setHidden:NO];

	blurViewGreen = [[CKBlurView alloc] initWithFrame:secondButton.bounds];
	[blurViewGreen setTintColorFilter:tintFilterGreen];
	blurViewGreen.blurRadius = 10.0f;
    blurViewGreen.blurCroppingRect = blurViewGreen.frame;
    blurViewGreen.alpha = 1.f;
	[secondButton addSubview:blurViewGreen];
	[blurViewGreen setHidden:NO];

	// Slide to views
	MBSliderView *s1 = [[MBSliderView alloc] initWithFrame:CGRectMake(20,0, firstButton.frame.size.width, firstButton.frame.size.height)];
    [s1 setText:@"slide to reboot"]; // set the label text
    [s1 setDelegate:self]; // set the MBSliderView delegate
    MBSliderView *s2 = [[MBSliderView alloc] initWithFrame:CGRectMake(20,0, secondButton.frame.size.width, secondButton.frame.size.height)];
    if ([self isSafemode])
    {
    	[s2 setText:@"slide to safemode"];
    }else {
    	[s2 setText:@"slide to respring"];
    }
    [s2 setDelegate:self]; // set the MBSliderView delegate
	// Add views
	[self addSubview:firstButton];
	[self addSubview:secondButton];
	//[debugView addSubview:uptimeLabel];
	[firstButton addSubview:s1];
	//[firstButton addSubview:rebootBTN];
	[secondButton addSubview:s2];
		
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
