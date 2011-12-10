//
//  BDLayer.m
//  SampleHoverViewProject
//
//  Created by Tim and Jennifer Taylor on 12/7/11.
//  Copyright (c) 2011 Big Diggy SW. All rights reserved.
//

#import "BDLayer.h"
#import <UIKit/UIKit.h>

#define kBDRadius 15.0f
@interface BDLayer ()

- (void)clipRoundedRect:(CGRect)rect inContext:(CGContextRef)context;
-(void)drawRoundedRect:(CGRect)rect inContext:(CGContextRef)context;
-(void)drawBevelWithRect:(CGRect)rect inContext:(CGContextRef)context;
@end
@implementation BDLayer

- (id)initWithLayer:(id)layer {
    NSLog(@"initWithLayer start");
	if((self = [super initWithLayer:layer])) {
		if([layer isKindOfClass:[BDLayer class]]) {
       }
	}
    NSLog(@"initWithLayer end");
	return self;
}



-(void)drawInContext:(CGContextRef)ctx{
    NSLog(@"start drawInContext");
    [self clipRoundedRect:self.bounds inContext:ctx];
    
    [self drawRoundedRect:self.bounds inContext:ctx];
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetAlpha(ctx, 0.85f);
    CGContextFillPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetAlpha(ctx, 0.25f);
    [self drawBevelWithRect:self.bounds inContext:ctx];
    CGContextFillPath(ctx);
//    
//    
    [self drawRoundedRect:self.bounds inContext:ctx];
    CGContextSetLineWidth(ctx, 5.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetAlpha(ctx, 1.0f);
    CGContextDrawPath(ctx, kCGPathStroke);
    NSLog(@"end drawInContext");

}
- (void)clipRoundedRect:(CGRect)rect inContext:(CGContextRef)context
{
    NSLog(@"    clipRoundedRect start");
    [self drawRoundedRect:rect inContext:context];
	CGContextClip(context);
    NSLog(@"    clipRoundedRect end");
}

-(void)drawRoundedRect:(CGRect)rect inContext:(CGContextRef)context{
    NSLog(@"        drawRoundedRect start");
	float radius = kBDRadius;
     	
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
    NSLog(@"        drawRoundedRect end");
	
}

-(void)drawBevelWithRect:(CGRect)rect inContext:(CGContextRef)context{
    
    float radius = kBDRadius;
    
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
