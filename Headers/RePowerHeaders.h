#import "TeleponyUI/TPBottomLockBar.h"
#import "CKBlurView.h"
#import "MBSliderView.h"
#import "substrate.h"

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