//
//  CKBlurView.m
//  CKBlurView
//
//  Created by Conrad Kramer on 10/25/13.
//  Copyright (c) 2013 Kramer Software Productions, LLC. All rights reserved.
//
//  MRC-Augmented by Julian Weiss on 1/4/14.
//  Copyright (c) 2014 Julian Weiss.
//  

#import <QuartzCore/QuartzCore.h>

#import "CKBlurView.h"

@interface CABackdropLayer : CALayer

@end

@interface CKBlurView ()

@property (retain, nonatomic) CAFilter *blurFilter;

@property (retain, nonatomic) CAFilter *colorFilter;

@end

extern NSString * const kCAFilterGaussianBlur;

NSString * const CKBlurViewQualityDefault = @"default";

NSString * const CKBlurViewQualityLow = @"low";

static NSString * const CKBlurViewQualityKey = @"inputQuality";

static NSString * const CKBlurViewRadiusKey = @"inputRadius";

static NSString * const CKBlurViewBoundsKey = @"inputBounds";

static NSString * const CKBlurViewHardEdgesKey = @"inputHardEdges";


@implementation CKBlurView

+(Class)layerClass {
    return [CABackdropLayer class];
}

-(CKBlurView *)commonInit{
    CAFilter *filter = [CAFilter filterWithName:kCAFilterGaussianBlur];
    self.layer.filters = @[ filter ];
    self.blurFilter = filter;

    self.blurQuality = CKBlurViewQualityDefault;
    self.blurRadius = 5.0f;   

    return self;
}

-(instancetype)init{
    self = [super init];
    return [self commonInit];
}

-(instancetype)initWithFrame:(CGRect)frame{
   [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:@"CKHide" object:nil];
   [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"CKShow" object:nil];

    self = [super initWithFrame:frame];
    return [self commonInit];
}

-(void)hide{
    [self setHidden:YES];
}

-(void)show{
    [self setHidden:NO];
}

-(void)makeMilky{
    id innerColor = (id)[UIColor clearColor].CGColor;
    id outerColor = (id)[UIColor colorWithWhite:0.5f alpha:0.75f].CGColor;

    CAGradientLayer *horizontal = [CAGradientLayer layer];
    horizontal.opacity = 0.75f;
    horizontal.colors = @[outerColor, innerColor, innerColor, outerColor];
    horizontal.locations = @[@(0.f), @(0.15f), @(0.85f), @(1.0f)];
    horizontal.startPoint = CGPointMake(0.f, 0.5f);
    horizontal.endPoint = CGPointMake(1.0f, 0.5f);
    horizontal.bounds = self.bounds;
    horizontal.anchorPoint = CGPointZero;

    CAGradientLayer *vertical = [CAGradientLayer layer];
    vertical.opacity = horizontal.opacity;
    vertical.colors = horizontal.colors;
    vertical.locations = horizontal.locations;
    vertical.bounds = self.bounds;
    vertical.anchorPoint = CGPointZero;

    [self.layer addSublayer:horizontal];
    [self.layer addSublayer:vertical];
}

-(void)setTintColorFilter:(CAFilter *)filter{
    self.colorFilter = filter;
    self.layer.filters = @[ self.colorFilter , self.blurFilter ];
}

-(void)setQuality:(NSString *)quality{
    [self.blurFilter setValue:quality forKey:CKBlurViewQualityKey];
}

-(NSString *)quality{
    return [self.blurFilter valueForKey:CKBlurViewQualityKey];
}

-(void)setBlurRadius:(CGFloat)radius{
    [self.blurFilter setValue:@(radius) forKey:CKBlurViewRadiusKey];
}

-(CGFloat)blurRadius{
    return [[self.blurFilter valueForKey:CKBlurViewRadiusKey] floatValue];
}

-(void)setBlurCroppingRect:(CGRect)croppingRect{
    [self.blurFilter setValue:[NSValue valueWithCGRect:croppingRect] forKey:CKBlurViewBoundsKey];
}

-(CGRect)blurCroppingRect{
    NSValue *value = [self.blurFilter valueForKey:CKBlurViewBoundsKey];
    return value ? [value CGRectValue] : CGRectNull;
}

-(void)setBlurEdges:(BOOL)blurEdges{
    [self.blurFilter setValue:@(!blurEdges) forKey:CKBlurViewHardEdgesKey];
}

-(BOOL)blurEdges{
    return ![[self.blurFilter valueForKey:CKBlurViewHardEdgesKey] boolValue];
}

-(void)dealloc{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
 
    _blurFilter = nil;
    _colorFilter = nil;
    _blurQuality = nil;
}

@end
