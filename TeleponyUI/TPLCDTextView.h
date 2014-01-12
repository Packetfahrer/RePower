//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIView.h"

@class NSString, TPLCDTextViewScrollingView, UIColor, UIFont, UIFrameAnimation;

@interface TPLCDTextView : UIView
{
    NSString *_text;
    UIFont *_font;
    UIColor *_shadowColor;
    UIColor *_textColor;
    TPLCDTextViewScrollingView *_scrollingView;
    double _fontSize;
    struct CGRect _textRect;
    UIFrameAnimation *_animation;
    id _delegate;
    double _minFontSize;
    unsigned int _textRectIsValid:1;
    unsigned int _centerText:1;
    unsigned int _animates:1;
    unsigned int _isAnimating:1;
    unsigned int _leftTruncates:1;
}

+ (double)defaultMinimumFontSize;
- (void)setDelegate:(id)arg1;
- (void)resetAnimation;
- (_Bool)animates;
- (void)stopAnimating;
- (void)_finishedScrolling;
- (void)startAnimating;
- (void)_startScrolling;
- (void)setAnimatesIfTruncated:(_Bool)arg1;
- (void)_setupForAnimationIfNecessary;
- (void)_scheduleStartScrolling;
- (void)_tearDownAnimation;
- (void)drawRect:(struct CGRect)arg1;
- (void)setShadowColor:(id)arg1;
- (void)setTextColor:(id)arg1;
- (void)_drawTextInRect:(struct CGRect)arg1 verticallyOffset:(_Bool)arg2;
- (struct CGSize)sizeToFit;
- (id)text;
- (void)setText:(id)arg1;
- (void)setMinimumFontSize:(double)arg1;
- (void)setFont:(id)arg1;
- (void)setLCDTextFont:(id)arg1;
- (void)setLeftTruncatesText:(_Bool)arg1;
- (void)setCenterText:(_Bool)arg1;
- (void)setFrame:(struct CGRect)arg1;
- (struct CGRect)textRect;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;

@end

