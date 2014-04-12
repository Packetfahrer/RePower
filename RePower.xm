//
//  RePower.xm
//  PowerDown Info
//
//  Created by Haifisch on 09.01.2014.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//
/* 
	Todo:
		Implement _UIBackdropView
		Battery time left
		Slide to ACTION
	Note to reader:
		I'm truely sorry for doing what I did here. It's bad, I know, but I'm sorry. If you'd like to fix this up, be my guest. It just works.
		I'd also like to say sorry in advanced for any future mistakes.

	For friendly neighbourhood developer,
		Haifisch


	It's okay.

	From friendly neighbourhood developer,
		insanj
*/

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Headers/RePowerHeaders.h"

%group main

%hook SBPowerDownView
UIView *firstButton, *secondButton;
UILabel *uptimeLabel;
NSTimer *batterytimer;

%new -(float)batteryLevel{
    @try{
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;

        CGFloat batteryCharge = [device batteryLevel] * 1000.f;
        if(batteryCharge > 0.0f)
			return batteryCharge;
        else
            return -1;
    }

    @catch (NSException *exception){
        return -1; // Error out
    }
}

%new -(BOOL)charging {
    @try{
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;

        return ([device batteryState] == UIDeviceBatteryStateCharging || [device batteryState] == UIDeviceBatteryStateFull);
    }

    @catch (NSException *exception){
        return false; // Error out
    }
}

%new -(BOOL)fullyCharged{
    @try {
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;

        return ([device batteryState] == UIDeviceBatteryStateFull);
    }

    @catch (NSException *exception){
        return false; // Error out
    }
}

%new -(BOOL)doesDoubleTap{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.repower.plist"]] objectForKey:@"doubletap"] boolValue];
}

%new -(void)respring{
	[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

%new -(void)reboot{
	[(SpringBoard *)[UIApplication sharedApplication] _rebootNow];
}

%new -(void)sliderDidSlide:(MBSliderView *)slideView{
	NSLog(@"[RePower]: Received message from %@...", slideView);
    if ([slideView.text isEqual:@"Slide to reboot"])
    	NSLog(@"[RePower]: Rebooting...");
}

-(void)animateIn{
	//[UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:[UIDevice currentDevice]];
    //batterytimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(batteryLevelChanged) userInfo:nil repeats:YES];
	
	// First button view
	firstButton = [[UIView alloc] initWithFrame:CGRectMake(16.f, 135.f, 288.f, 65.f)];
	firstButton.layer.cornerRadius = 5.f;
	firstButton.layer.masksToBounds = YES;
	firstButton.opaque = NO;
	firstButton.alpha = 0.8f;
    firstButton.backgroundColor = [UIColor colorWithRed:184.f/255.f green:111.f/255.f blue:39.f/255.f alpha:0.9f];
   
    // Second button view
	secondButton = [[UIView alloc] initWithFrame:CGRectMake(16,220,288,65)];
	secondButton.layer.cornerRadius = 5;
	secondButton.layer.masksToBounds = YES;
	secondButton.opaque = NO;
	secondButton.alpha = 0.8;
    secondButton.backgroundColor = [UIColor colorWithRed:70.f/255.f green:160.f/255.f blue:46.f/255.f alpha:0.9f];
    
    // Uptime text label
	uptimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, firstButton.bounds.size.width, 30.f)];
	uptimeLabel.textAlignment = NSTextAlignmentCenter;
	uptimeLabel.textColor = [UIColor whiteColor];
	[uptimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.f]];
	if ([self charging])
		uptimeLabel.text = [NSString stringWithFormat:@"Charging at %f", [self batteryLevel]];

	// Respring Button
	UIButton *respringBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (![self doesDoubleTap]){	
		[respringBTN setTitle:@"Double tap to Respring" forState:UIControlStateNormal];
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respring)];
		tapRecognizer.numberOfTapsRequired = 2;
		tapRecognizer.numberOfTouchesRequired = 1;
		[respringBTN addGestureRecognizer:tapRecognizer];
	}

	else{
		[respringBTN setTitle:@"Tap to Respring" forState:UIControlStateNormal];
		[respringBTN addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchDown];
	}

	respringBTN.frame = CGRectMake(0.f, 0.f, secondButton.bounds.size.width, secondButton.bounds.size.height);
	[respringBTN.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:25.f]];
	[respringBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	// Reboot button
	UIButton *rebootBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (![self doesDoubleTap]){
		[rebootBTN setTitle:@"Double tap to Reboot" forState:UIControlStateNormal];
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reboot)];
		tapRecognizer.numberOfTapsRequired = 2;
		tapRecognizer.numberOfTouchesRequired = 1;
		[rebootBTN addGestureRecognizer:tapRecognizer];
	}

	else{
		[rebootBTN setTitle:@"Tap to Reboot" forState:UIControlStateNormal];
		[rebootBTN addTarget:self action:@selector(reboot) forControlEvents:UIControlEventTouchDown];
	}

	rebootBTN.frame = CGRectMake(0.f, 0.f, firstButton.bounds.size.width, firstButton.bounds.size.height);
	[rebootBTN.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:25.f]];
	[rebootBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// Slide to views
	MBSliderView *s1 = [[MBSliderView alloc] initWithFrame:CGRectMake(15.f, 0.f, firstButton.frame.size.width, firstButton.frame.size.height)];
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
	[applicationLoadViewIn setDuration:0.75f];
	[applicationLoadViewIn setType:kCATransitionReveal];
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[[firstButton layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
	[[secondButton layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
	%orig;
}

-(void)animateOut{
	// Process nice fade out
	CATransition *transition = [CATransition animation];
	transition.duration = 0.75f;
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
%end //%hook

%end //%group


%ctor{
	@autoreleasepool{
		%init(main);
	}
}
