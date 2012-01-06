//
//  BDLayer.m
//  SampleHoverViewProject
//
//  Created by Tim and Jennifer Taylor on 12/7/11.
//  Copyright (c) 2011 Big Diggy SW. All rights reserved.
//

#import "BDLayer.h"
#import <UIKit/UIKit.h>

#define kBDBevelRadius 15.0f
#define kStrokeWidth 5.0f
@interface BDLayer ()

-(void)clipRoundedRect:(CGRect)rect inContext:(CGContextRef)context;
-(void)drawRoundedRect:(CGRect)rect inContext:(CGContextRef)context;
-(void)drawBevelWithRect:(CGRect)rect inContext:(CGContextRef)context;

@end
@implementation BDLayer
@synthesize showBevel = showBevel_;
@synthesize showBorder = showBorder_;

- (id)initWithLayer:(id)layer {
    return [self initWithLayer:layer showBevel:YES];
}

-(id)initWithLayer:(id)layer showBevel:(BOOL)showBevel{
    if((self = [super initWithLayer:layer])) {
		showBevel_=showBevel;
	}
 	return self;
}



-(void)drawInContext:(CGContextRef)ctx{
    
    // We draw and fill like a painter
    
    // Clip first
    [self clipRoundedRect:self.bounds inContext:ctx];
    
    //  draw and fill the background and set the alpha
    [self drawRoundedRect:self.bounds inContext:ctx];
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetAlpha(ctx, 0.85f);
    CGContextFillPath(ctx);
    
    
    // Draw and fill the bevel    
    if (showBevel_) {
        [self drawBevelWithRect:self.bounds inContext:ctx];
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextSetAlpha(ctx, 0.25f);
        CGContextFillPath(ctx);
    }
    
    
    // Draw and stroke the border
    [self drawRoundedRect:self.bounds inContext:ctx];
    CGColorRef strokeColor=[UIColor blackColor].CGColor;
    CGFloat strokeWidth=1.0;
    if (showBorder_) {
        strokeColor=[UIColor whiteColor].CGColor;
        strokeWidth=4.0f;
    }
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGContextSetAlpha(ctx, 1.0f);
    CGContextDrawPath(ctx, kCGPathStroke);
 
}
- (void)clipRoundedRect:(CGRect)rect inContext:(CGContextRef)context
{
    [self drawRoundedRect:rect inContext:context];
	CGContextClip(context);
 }

-(void)drawRoundedRect:(CGRect)rect inContext:(CGContextRef)context{
 	float radius = kBDBevelRadius;
     	
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
 }

-(void)drawBevelWithRect:(CGRect)rect inContext:(CGContextRef)context{
    
    float radius = kBDBevelRadius;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    
    CGFloat yCoord=CGRectGetMinY(rect)+radius;
    if (0.2*CGRectGetMaxY(rect)>10.0f) {
        yCoord=0.2*CGRectGetMaxY(rect);
    }
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), yCoord);
    
    CGContextAddQuadCurveToPoint(context,CGRectGetMaxX(rect)/2.0f,0.3*CGRectGetMaxY(rect),CGRectGetMinX(rect), yCoord);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
    
    
    
}




@end
