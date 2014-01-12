//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIView.h"

#import "UITableViewDataSource.h"
#import "UITableViewDelegate.h"

@class UITableView, _UIBackdropView;

@interface TPAudioDeviceView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_deviceTableView;
    id _delegate;
    _Bool _blursBackground;
    _UIBackdropView *_backdropView;
}

@property(retain) _UIBackdropView *backdropView; // @synthesize backdropView=_backdropView;
@property(nonatomic) _Bool blursBackground; // @synthesize blursBackground=_blursBackground;
- (void)setDelegate:(id)arg1;
- (void)selectRow:(long long)arg1;
- (void)layoutSubviews;
- (void)reloadData;
- (void)setActiveRow:(long long)arg1;
- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
- (void)tableView:(id)arg1 willDisplayCell:(id)arg2 forRowAtIndexPath:(id)arg3;
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2;
- (void)_setupTable;
- (id)hitTest:(struct CGPoint)arg1 withEvent:(id)arg2;
- (void)dealloc;

@end
