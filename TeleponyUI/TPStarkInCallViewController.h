//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIViewController.h"

#import "TPStarkInCallButtonsViewDelegate.h"
#import "TPStarkPhoneCallGalleryViewDelegate.h"

@class NSArray, NSTimer, TPStarkInCallButtonsView, TPStarkPhoneCallGalleryView, TUCall, UIView;

@interface TPStarkInCallViewController : UIViewController <TPStarkPhoneCallGalleryViewDelegate, TPStarkInCallButtonsViewDelegate>
{
    int _currentMode;
    id <TPStarkInCallViewControllerDelegate> _delegate;
    NSArray *_primaryPhoneCalls;
    NSArray *_conferenceParticipants;
    TUCall *_incomingPhoneCall;
    UIView *_flippyView;
    TPStarkPhoneCallGalleryView *_galleryView;
    TPStarkInCallButtonsView *_buttonsView;
    NSTimer *_viewUpdateClockTickTimer;
    TUCall *_failedCall;
}

@property(retain) TUCall *failedCall; // @synthesize failedCall=_failedCall;
@property int currentMode; // @synthesize currentMode=_currentMode;
@property(retain) NSTimer *viewUpdateClockTickTimer; // @synthesize viewUpdateClockTickTimer=_viewUpdateClockTickTimer;
@property(retain) TPStarkInCallButtonsView *buttonsView; // @synthesize buttonsView=_buttonsView;
@property(retain) TPStarkPhoneCallGalleryView *galleryView; // @synthesize galleryView=_galleryView;
@property(retain) UIView *flippyView; // @synthesize flippyView=_flippyView;
@property(retain) TUCall *incomingPhoneCall; // @synthesize incomingPhoneCall=_incomingPhoneCall;
@property(copy) NSArray *conferenceParticipants; // @synthesize conferenceParticipants=_conferenceParticipants;
@property(copy) NSArray *primaryPhoneCalls; // @synthesize primaryPhoneCalls=_primaryPhoneCalls;
@property id <TPStarkInCallViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
- (void)_physicalButtonsCancelled:(id)arg1 withEvent:(id)arg2;
- (void)_physicalButtonsEnded:(id)arg1 withEvent:(id)arg2;
- (void)_physicalButtonsBegan:(id)arg1 withEvent:(id)arg2;
- (void)_wheelChangedWithEvent:(id)arg1;
- (_Bool)currentCallStateWarrantsCallWaitingMode;
- (void)callFailedNotification:(id)arg1;
- (void)muteStateChangedNotification:(id)arg1;
- (void)viewUpdateClockTickTimerFired:(id)arg1;
- (void)updateButtonsViewState;
- (void)inCallButtonWasTapped:(id)arg1;
- (_Bool)isSwapCallsAllowed;
- (_Bool)isMergeCallsAllowed;
- (_Bool)isAddCallAllowed;
- (id)representativePhoneCallForConferenceForGalleryView:(id)arg1;
- (id)allConferenceParticipantCalls;
- (id)conferenceParticipantCallsForPhoneCall:(id)arg1;
- (id)primaryPhoneCallsForGalleryView:(id)arg1;
- (_Bool)isMuted;
- (void)setIsMuted:(_Bool)arg1;
@property(readonly) _Bool isDismissable;
- (id)currentActivePhoneCall;
- (id)__sanitizedPrimaryPhoneCallOrdering:(id)arg1;
- (void)setPrimaryPhoneCalls:(id)arg1 conferencePhoneCalls:(id)arg2 incomingPhoneCall:(id)arg3;
- (void)viewWillDisappear:(_Bool)arg1;
- (void)viewWillAppear:(_Bool)arg1;
- (void)dealloc;
- (void)loadView;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;

@end

