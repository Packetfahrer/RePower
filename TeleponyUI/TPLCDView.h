//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <TelephonyUI/TPLCDBar.h>

@class TPLCDSubImageView, TPLCDTextView, UIView;

@interface TPLCDView : TPLCDBar
{
    UIView *_contentView;
    TPLCDTextView *_textView;
    TPLCDTextView *_labelView;
    TPLCDSubImageView *_imageView;
    unsigned int _layoutAsLabelled:1;
    _Bool _verticallyCenterTextViewIfLabelless;
    _Bool _hasBackgroundGradient;
    UIView *_backgroundGradientView;
}

+ (double)labelFontSize;
+ (double)textFontSize;
@property(nonatomic) _Bool hasBackgroundGradient; // @synthesize hasBackgroundGradient=_hasBackgroundGradient;
@property(retain, nonatomic) UIView *backgroundGradientView; // @synthesize backgroundGradientView=_backgroundGradientView;
@property _Bool verticallyCenterTextViewIfLabelless; // @synthesize verticallyCenterTextViewIfLabelless=_verticallyCenterTextViewIfLabelless;
- (id)secondLineText;
- (void)setSecondLineText:(id)arg1;
- (void)setLayoutAsLabelled:(_Bool)arg1;
- (void)setShadowColor:(id)arg1;
- (id)subImage;
- (void)setSubImage:(id)arg1;
- (void)blinkLabel;
- (id)label;
- (void)setLabel:(id)arg1 animate:(_Bool)arg2;
- (void)setLabel:(id)arg1;
- (void)didFinishAnimatingLCDLabelFadeOut:(id)arg1 finished:(id)arg2 context:(id)arg3;
- (void)didMoveToWindow;
- (struct CGPoint)_backgroundGradientViewOrigin;
- (void)layoutSubviews;
- (struct CGRect)_imageViewFrame;
- (struct CGRect)_labelFrame;
- (struct CGRect)textFrame;
- (struct CGRect)_text1Frame;
- (id)text;
- (void)setText:(id)arg1;
- (double)_textVInset;
- (double)_labelVInset;
- (void)setContentsAlpha:(double)arg1;
- (_Bool)shouldCenterContentView;
- (_Bool)shouldCenterText;
- (void)dealloc;
- (id)initWithDefaultSizeForOrientation:(long long)arg1;
- (void)_resetContentViewFrame;
- (struct CGRect)fullSizedContentViewFrame;

@end
