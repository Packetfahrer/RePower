//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIView.h"

@class UIBezierPath, UIColor;

@interface TPPathView : UIView
{
    UIBezierPath *_path;
    UIColor *_fillColor;
}

@property(retain, nonatomic) UIColor *fillColor; // @synthesize fillColor=_fillColor;
@property(retain, nonatomic) UIBezierPath *path; // @synthesize path=_path;
- (void)drawRect:(struct CGRect)arg1;
- (void)dealloc;

@end

