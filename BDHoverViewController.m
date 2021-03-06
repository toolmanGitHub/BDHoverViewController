//
//  BDHoverViewController.m
//  Created by Tim Taylor on 5/17/11.
//  Copyright 2011 Big Diggy SW. All rights reserved.//

/*
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2011 Big Diggy SW. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Tim Taylor nor Big Diggy SW 
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY Big Diggy SW "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#import "BDHoverViewController.h"
#import "BDHoverView.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 0.5f
#define DEMO YES
#define ALERT_IMAGE_PADDING 20.0f
typedef void (^animationBlock)(void);

@interface BDHoverViewController (){
   
    
}
@property (nonatomic,strong) BDHoverView *hoverView;
@property (nonatomic) BDHoverViewStatusStyle hoverViewStatusStyle;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSString *currentStatusString;
@property (nonatomic) float currentProgress;
@property (nonatomic) float animationDuration;
@property (nonatomic) BOOL showBevel;
@property (nonatomic) BOOL showBorder;

-(BDHoverView *)hoverViewForStyle:(BDHoverViewStatusStyle)hoverViewStyle;
-(CGRect)hoverViewFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle;

-(UILabel *)statusLabelForStyle:(BDHoverViewStatusStyle)hoverViewStyle;
-(CGRect)statusLabelFrameForStyle:(BDHoverViewStatusStyle)hoverViewStyle;

-(UIProgressView *)progressViewForStyle:(BDHoverViewStatusStyle)hoverViewStyle;
-(CGRect)progressViewFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle;


-(UIActivityIndicatorView *)activityIndicatorForStyle:(BDHoverViewStatusStyle)hoverViewStyle;
-(CGRect)activityIndicatorFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle;

- (IBAction)Only:(id)sender;
- (IBAction)Status:(id)sender;
- (IBAction)progress:(id)sender;

void StatusLabelAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks);
void ProgressViewAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks);

@end

@implementation BDHoverViewController
// Public
@synthesize animationOngoing =animationOngoing_;
@synthesize alertImage = alertImage_;

// Private
@synthesize hoverView = hoverView_;
@synthesize hoverViewStatusStyle = hoverViewStatusStyle_;
@synthesize activityIndicator = activityIndicator_;
@synthesize statusLabel = statusLabel_;
@synthesize progressView = progressView_;
@synthesize currentStatusString = currentStatusString_;
@synthesize currentProgress = currentProgress_;
@synthesize animationDuration = animationDuration_;
@synthesize showBevel = showBevel_;
@synthesize showBorder = showBorder_;

#pragma mark -
#pragma mark Designated Initializers
-(id)initWithHoverStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle options:(BDHoverViewControllerOptions)options{
    self = [super init];
    if (self){
        hoverViewStatusStyle_=hoverViewStatusStyle;
        animationDuration_=ANIMATION_DURATION;
        if (options & BDHoverViewControllerOptionsShowBevel) {
            showBevel_=YES;
        }else{
            showBevel_=NO;
        }
        if (options & BDHoverViewControllerOptionsShowBorder) {
            showBorder_=YES;
        }else{
            showBorder_=NO;
        }
    }
    return self;

}

-(id)initWithAlertImage:(UIImage *)alertImage options:(BDHoverViewControllerOptions)options{
    self = [self initWithHoverStatusStyle:BDHoverViewStatusAlertImageOnlyStyle options:options];
    if (self) {
       UIGraphicsBeginImageContext(alertImage.size);
        
        // get a reference to that context we created
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // set the fill color
        [[UIColor whiteColor] setFill];
        
        // translate/flip the graphics context (for transforming from CG* coords to UI* coords
        CGContextTranslateCTM(context, 0, alertImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, alertImage.size.width, alertImage.size.height);
        CGContextDrawImage(context, rect, alertImage.CGImage);
        
        // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
        CGContextClipToMask(context, rect, alertImage.CGImage);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context,kCGPathFill);
        
        // generate a new UIImage from the graphics context we drew onto
        
        alertImage_= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return self;
}


- (id)initWithHoverStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    return [self initWithHoverStatusStyle:hoverViewStatusStyle options:BDHoverViewControllerOptionsShowBevel];
}

- (id)init{
    return [self initWithHoverStatusStyle:BDHoverViewStatusNothingStyle];
}

#pragma mark -
#pragma mark Updating the UI elements
-(void)updateHoverViewStatus:(NSString *)status progressValue:(float)progress{
    [self updateHoverViewStatus:status];
    [self updateHoverViewProgressWithProgressValue:progress];
}

-(void)updateHoverViewProgressWithProgressValue:(float)progress{
    self.progressView.progress=progress;
    self.currentProgress = progress;
}

-(void)updateHoverViewStatus:(NSString *)status{
    self.statusLabel.text=status;
    self.currentStatusString=status;
}

#pragma mark -
#pragma mark HoverView Methods
-(BDHoverView *)hoverViewForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    
    CGRect hoverViewFrame=[self hoverViewFrameForStyle:hoverViewStyle];
    
	BDHoverView *aHoverView=[[BDHoverView alloc] initWithFrame:hoverViewFrame showBevel:showBevel_ showBorder:showBorder_];
    CGPoint hoverViewCenter=aHoverView.center;
    aHoverView.center=CGPointMake(floorf(hoverViewCenter.x), floorf(hoverViewCenter.y));
    aHoverView.animationDuration=3*ANIMATION_DURATION/4.0;
    
    if (hoverViewStyle!=BDHoverViewStatusAlertImageOnlyStyle) {
        self.activityIndicator = [self activityIndicatorForStyle: hoverViewStyle];
        [aHoverView addSubview:self.activityIndicator];
    }
        
    switch (hoverViewStyle) {
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            // Add the status Label to the hoverview
            self.statusLabel=[self statusLabelForStyle:hoverViewStyle];
            [aHoverView addSubview:self.statusLabel];
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            // Add the status Label to the hoverview
            self.statusLabel=[self statusLabelForStyle:hoverViewStyle];
           
            [aHoverView addSubview:self.statusLabel];
            
            // Add the progress view to the hoverview
            self.progressView=[self progressViewForStyle: hoverViewStyle];
            [aHoverView addSubview:self.progressView];
            break;
        }
        case BDHoverViewStatusAlertImageOnlyStyle:
        {
            UIImageView *theImageView=[[UIImageView alloc] initWithImage:alertImage_];
            theImageView.center=CGPointMake(floorf(aHoverView.bounds.size.width/2.0f), floorf(aHoverView.bounds.size.height/2.0f));
            [aHoverView addSubview:theImageView];
        }
    }

    return aHoverView;
    
}

-(CGPoint)hoverViewCenterForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGPoint hoverViewCenterPoint=CGPointZero;
    CGRect theFrame=[self hoverViewFrameForStyle:hoverViewStatusStyle];
    CGSize theSize=theFrame.size;
    CGPoint thePoint=theFrame.origin;
    
    hoverViewCenterPoint=CGPointMake(thePoint.x+theSize.width/2.0f, thePoint.y+theSize.height/2.0f);
    
    return hoverViewCenterPoint;
}

-(CGRect)hoverViewFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGRect hoverViewFrame=CGRectZero;
    CGFloat hoverViewWidth=290.0f;
    CGFloat hoverViewHeight=0.0f;
    CGFloat hoverViewX=0.0f;
    CGFloat hoverViewY=0.0f;
   
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusExclusiveTouchStyle:{
            hoverViewWidth=0.0f;
            break;
        }
        case BDHoverViewStatusActivityOnlyStyle:
        {
            hoverViewHeight = 77.0f;
            hoverViewWidth = 77.0f;
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            hoverViewHeight = 101.0f;
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            hoverViewHeight = 180.0f;
            break;
        }   
        case BDHoverViewStatusAlertImageOnlyStyle:{
            if (!alertImage_) {
                hoverViewHeight=hoverViewWidth;
            }else{
                CGSize alertImageSize=alertImage_.size;
                hoverViewWidth=alertImageSize.width+2*ALERT_IMAGE_PADDING;
                hoverViewHeight=alertImageSize.height+2*ALERT_IMAGE_PADDING;
            }
        }
    }
    
    hoverViewX=round(self.view.bounds.size.width/2-hoverViewWidth/2);
    hoverViewY=round(self.view.bounds.size.height/2-hoverViewHeight/2);
    
    hoverViewFrame=CGRectMake(hoverViewX, hoverViewY, hoverViewWidth, hoverViewHeight);
    
    return hoverViewFrame;
}

#pragma mark -
#pragma mark Activity Indicator Methods

-(UIActivityIndicatorView *)activityIndicatorForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    UIActivityIndicatorView *aActivityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [aActivityIndicator startAnimating];
      aActivityIndicator.alpha=0.0f;
    aActivityIndicator.opaque=YES;
    aActivityIndicator.frame=[self activityIndicatorFrameForStyle:hoverViewStyle];
    return aActivityIndicator;
}

-(CGRect)activityIndicatorFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGRect activityIndicatorFrame=CGRectZero;
    
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusExclusiveTouchStyle:
        {
            activityIndicatorFrame=CGRectMake(0.0f, 0.0f, 37.0f,37.0f);
            break;
        }
        case BDHoverViewStatusActivityOnlyStyle:
        {
            // Adjust the frame location of the activityIndicator Frame
            activityIndicatorFrame=CGRectMake(20.0f, 20.0f, 37.0f,37.0f);
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            // Adjust the frame location of the activityIndicator Frame
            activityIndicatorFrame=CGRectMake(128.0f, 15.0f, 37.0f,37.0f);
            
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            // Adjust the frame location of the activityIndicator Frame
            activityIndicatorFrame=CGRectMake(128.0, 48.0, 37.0,37.0);
            break;
        }
    }
    
    return activityIndicatorFrame;
}

-(CGPoint)activityIndicatorCenterForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGPoint activityIndicatorCenter=CGPointZero;
    CGRect theFrame=[self activityIndicatorFrameForStyle:hoverViewStatusStyle];
    CGSize theSize=theFrame.size;
    CGPoint thePoint=theFrame.origin;
    
    activityIndicatorCenter=CGPointMake(thePoint.x+theSize.width/2.0f, thePoint.y+theSize.height/2.0f);
    
    return activityIndicatorCenter;
}

#pragma mark -
#pragma mark Status Label Methods

-(UILabel *)statusLabelForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    
    UILabel *aStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(21.0f, 70.0f, 248.0f, 21.0f)];
    CGPoint aStatusLabelCenter=aStatusLabel.center;
    aStatusLabel.center=CGPointMake(floorf(aStatusLabelCenter.x), floorf(aStatusLabelCenter.y));

    aStatusLabel.frame = [self statusLabelFrameForStyle: hoverViewStyle];
    
    aStatusLabel.backgroundColor=[UIColor clearColor];
    aStatusLabel.textColor=[UIColor whiteColor];
    aStatusLabel.textAlignment = UITextAlignmentCenter;
    aStatusLabel.alpha=0.0f;
    aStatusLabel.opaque=YES;
    if (currentStatusString_!=nil) {
        aStatusLabel.text=self.currentStatusString;
    }else{
        aStatusLabel.text=@"Some Really Long Text";
    }
    
    return aStatusLabel;
    
}


-(CGRect)statusLabelFrameForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    CGRect statusLabelFrame=CGRectZero;
    switch (hoverViewStyle) {
        case BDHoverViewStatusActivityOnlyStyle:
        {
            statusLabelFrame=CGRectMake(10.0f, 60.0f, 0.0f, 22.0f);
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
           statusLabelFrame=CGRectMake(21.0f, 60.0f, 248.0f, 22.0f);
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            statusLabelFrame=CGRectMake(21.0f, 111.0f, 248.0f, 22.0f);
            break;
        }
            
    }
  
    return statusLabelFrame;

}


#pragma mark -
#pragma mark Progress View Methods

-(UIProgressView *)progressViewForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    UIProgressView *aProgressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    aProgressView.alpha=0.0;
    aProgressView.opaque=YES;
    aProgressView.backgroundColor  =[UIColor clearColor];
    aProgressView.autoresizingMask=UIViewAutoresizingNone;

    aProgressView.frame=[self progressViewFrameForStyle:hoverViewStyle];
    aProgressView.progress = self.currentProgress;
    return aProgressView;

}

-(CGRect)progressViewFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGRect progressViewFrame=CGRectZero;
    
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusActivityOnlyStyle:
        {
            progressViewFrame=CGRectMake(0.0f,60.0f,5.0f,10.0f);
            break;
            
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            progressViewFrame=CGRectMake(22.0f,50.0f,248.0f,10.0f);
            break;
            
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            progressViewFrame=CGRectMake(22.0f, 94.0f, 248.0f, 10.0f);
            break;
        }
    }
    
    return progressViewFrame;
}


#pragma mark -
#pragma mark IBAction Methods

- (IBAction)progress:(id)sender {
    if (!self.animationOngoing) {
        [self animateToHoverViewStatusStyle:BDHoverViewStatusActivityProgressStyle completion:nil];
    }
    
}

- (IBAction)Status:(id)sender {
    if (!self.animationOngoing) {
        [self animateToHoverViewStatusStyle:BDHoverViewStatusActivityAndStatusStyle completion:nil];
    }
    
}

- (IBAction)Only:(id)sender {
    //  if (!self.animationOngoing) {
        [self animateToHoverViewStatusStyle:BDHoverViewStatusActivityOnlyStyle completion:nil];
    // }
    

}

- (IBAction)ExclusiveTouch:(id)sender {
    //  if (!self.animationOngoing) {
    [self animateToHoverViewStatusStyle:BDHoverViewStatusExclusiveTouchStyle completion:nil];
    // }
    
    
}

- (IBAction)alertImage:(id)sender {
    //  if (!self.animationOngoing) {
    [self animateToHoverViewStatusStyle:BDHoverViewStatusAlertImageOnlyStyle completion:nil];
    // }
    
    
}

-(IBAction)toggleAnimationDuration:(UIButton *)sender{
    
    if (sender.tag==0) {
        self.animationDuration=ANIMATION_DURATION;
        [sender setTitle:@"Toggle to Slow Animation" forState:UIControlStateNormal];
        sender.tag=1;
        
    }else{
        self.animationDuration=5.0f;
        [sender setTitle:@"Toggle to Normal Animation" forState:UIControlStateNormal];
        sender.tag=0;
    }
}


#pragma mark -
#pragma mark Populating Animation Block Arrays

void StatusLabelAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks){
    
    animationBlock firstBlock=nil;
    animationBlock secondBlock=nil;
    animationBlock completionBlock=nil;
    __block __unsafe_unretained BDHoverViewController *blockSelf=self;
    // Remove Status Label
    
    if ((hoverViewStatusStyle!=BDHoverViewStatusActivityAndStatusStyle && hoverViewStatusStyle!=BDHoverViewStatusActivityProgressStyle) && (self.statusLabel!=nil)) {
        firstBlock=[^{
            //              NSLog(@"First Block:  Status Label Alpha 0.0");
            blockSelf.statusLabel.alpha=0.0f;
        } copy];
        [*firstBlocks addObject: firstBlock];
        
        completionBlock=[^{
            //             NSLog(@"            Completion Block:  Remove Status Label");
            [blockSelf.statusLabel removeFromSuperview];
            blockSelf.statusLabel=nil;
        } copy];
        [*completionBlocks addObject: completionBlock];
        
    }
    // Status Label
    if ( (hoverViewStatusStyle==BDHoverViewStatusActivityAndStatusStyle || hoverViewStatusStyle==BDHoverViewStatusActivityProgressStyle)) {
        
        if (self.statusLabel==nil) {
            self.statusLabel=[self statusLabelForStyle:self.hoverViewStatusStyle];
        }
        
        if (self.statusLabel.superview==nil) {
            [self.hoverView addSubview:self.statusLabel];
        }
        secondBlock=[^{
            //        NSLog(@"        Second Block:  Status Label Alpha and Frame");
            blockSelf.statusLabel.alpha=1.0f;
            blockSelf.statusLabel.frame=[self statusLabelFrameForStyle:hoverViewStatusStyle];
            CGPoint statusLabelCenter=blockSelf.statusLabel.center;
            blockSelf.statusLabel.center=CGPointMake(floorf(statusLabelCenter.x), floorf(statusLabelCenter.y));
          } copy];
        [*secondBlocks addObject: secondBlock];
        
        completionBlock=[^{
            //           NSLog(@"            Completion Block:  Status Label Reapply Alpha");
            blockSelf.statusLabel.alpha=1.0f;
            
        } copy];
        [*completionBlocks addObject: completionBlock];
        
        
    }
    
}

void ProgressViewAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks){
    
    animationBlock firstBlock=nil;
    animationBlock secondBlock=nil;
    animationBlock completionBlock=nil;
    __block __unsafe_unretained BDHoverViewController *blockSelf=self;
    
    // Progress View
    if (hoverViewStatusStyle!=BDHoverViewStatusActivityProgressStyle && (self.progressView!=nil)) {
        
        firstBlock=[^{
            //              NSLog(@"First Block:  Progress Alpha to 0.0");
            blockSelf.progressView.alpha=0.0f;
        } copy];
        [*firstBlocks addObject: firstBlock];
        
        completionBlock=[^{
            //                NSLog(@"            Completion Block:  Removing Progress View");
            [blockSelf.progressView removeFromSuperview];
            blockSelf.progressView=nil;
        } copy];
        [*completionBlocks addObject: completionBlock];
    }
    
    if (hoverViewStatusStyle==BDHoverViewStatusActivityProgressStyle ) {
        if (self.progressView==nil) {
            self.progressView=[self progressViewForStyle:self.hoverViewStatusStyle];
        }
        if (self.progressView.superview==nil){
            [self.hoverView addSubview:self.progressView];
        }
          CGRect newProgressFrame=[self progressViewFrameForStyle:hoverViewStatusStyle];
        secondBlock=[^{
            //                  NSLog(@"    Second Block:  Progress Alpha and Frame");
            blockSelf.progressView.alpha=1.0f;
            blockSelf.progressView.frame=newProgressFrame;
        } copy];
        [*secondBlocks addObject: secondBlock];
        
        completionBlock=[^{
            
        } copy];
        [*completionBlocks addObject: completionBlock];
        
    }
}

#pragma mark -
#pragma mark hoverView Animation
-(void)animateToHoverViewStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle completion:(void (^)(BOOL finished))completion{

    if (self.animationOngoing || hoverViewStatusStyle==self.hoverViewStatusStyle) {
        return;
    }
    
    // We using the BDHoverViewStatusAlertImageOnly style, we can only toggle between it and the 
    // BDHoverViewStatusExclusiveTouchStyle
    
    if (self.hoverViewStatusStyle!=BDHoverViewStatusExclusiveTouchStyle && hoverViewStatusStyle==BDHoverViewStatusAlertImageOnlyStyle) {
        return;
    }
    
    if (self.hoverViewStatusStyle==BDHoverViewStatusAlertImageOnlyStyle && hoverViewStatusStyle!=BDHoverViewStatusExclusiveTouchStyle) {
        return;
    }
     
    self.animationOngoing=YES;
    self.hoverView.animationDuration=3*self.animationDuration/4.0f;

    
    NSMutableArray *firstStageAnimationBlocks=[NSMutableArray arrayWithCapacity:1];
    NSMutableArray *secondStageAnimationBlocks=[NSMutableArray arrayWithCapacity:1];
    NSMutableArray *completionBlocks=[NSMutableArray arrayWithCapacity:1];
    animationBlock firstBlock;
    animationBlock secondBlock;
    animationBlock completionBlock;
    
    __block __unsafe_unretained BDHoverViewController *blockSelf=self;
        
    // Check to see if the hoverView is present
    if (self.hoverViewStatusStyle==BDHoverViewStatusExclusiveTouchStyle && hoverViewStatusStyle!=BDHoverViewStatusExclusiveTouchStyle) {
        
        // If the hoverView is not already present (i.e. the Exclusive Touch Style, prepare it
        // for viewing.
               
        // First we get the hoverView.  Calling this method returns a hoverView with all the right 
        // UI Elements per the requested style.
        
        self.hoverView = [self hoverViewForStyle:hoverViewStatusStyle];
        self.hoverView.transform=CGAffineTransformMakeScale(0.01f,0.01f);
     
        [self.view addSubview:self.hoverView];
        

        // Set the animationDuration for the hoverView so that the shadow's animation is in sync.
        self.hoverView.animationDuration=self.animationDuration/4.0f;
        
        firstBlock=[^{
            // Animate with a little bit bigger scale so it gets noticed.
            blockSelf.hoverView.transform=CGAffineTransformMakeScale(1.1f, 1.1f);
            blockSelf.activityIndicator.alpha=1.0f;
            blockSelf.statusLabel.alpha=1.0f;
            blockSelf.progressView.alpha=1.0f;
            
        } copy];
        
        [firstStageAnimationBlocks addObject: firstBlock];
        
        
        secondBlock=[^{
            // Make sure we scale it back to the way it needs to be.
            blockSelf.hoverView.transform=CGAffineTransformIdentity;
            
        } copy];
        [secondStageAnimationBlocks addObject: secondBlock];
        
        
    }else{
        
        // Check to see if the requested style is Exclusive Touch
        if (hoverViewStatusStyle==BDHoverViewStatusExclusiveTouchStyle) {
            // Create a block that begins shrinking the hoverview and setting
            // it's opacity to 0.0.
            firstBlock=[^{
                blockSelf.hoverView.transform=CGAffineTransformMakeScale(0.95f, 0.95f);
                blockSelf.hoverView.alpha=0.0f;
            } copy];
            
            [firstStageAnimationBlocks addObject: firstBlock];
            
           
            //  self.hoverView.layer.opacity=0.0;
            
            // For the completion block, clearn up the views.
           
            completionBlock=[^{
                [blockSelf.hoverView removeFromSuperview];
                blockSelf.hoverView=nil;
                blockSelf.activityIndicator=nil;
                blockSelf.statusLabel=nil;
                blockSelf.progressView=nil;
            } copy];
            
            [completionBlocks addObject:completionBlock];
               
        }else{
            // We need to animate to something other than the exclusive touch.
            
            // Get the size of the frame that we need to animate to.
            CGRect newHoverViewFrame=[self hoverViewFrameForStyle:hoverViewStatusStyle];
            
            // Set the animation block so that the view animates to the right frame size.
            secondBlock=[^{
               blockSelf.hoverView.bounds=CGRectMake(0, 0, newHoverViewFrame.size.width, newHoverViewFrame.size.height);
               blockSelf.activityIndicator.frame=[self activityIndicatorFrameForStyle:hoverViewStatusStyle];
            } copy];
            [secondStageAnimationBlocks addObject: secondBlock];
            
            // Add animations to the first and second stage animation blocks for the status label and progress views.
            StatusLabelAnimationBlocksForStyle(self, hoverViewStatusStyle, &firstStageAnimationBlocks, &secondStageAnimationBlocks,&completionBlocks);
            ProgressViewAnimationBlocksForStyle(self, hoverViewStatusStyle, &firstStageAnimationBlocks, &secondStageAnimationBlocks, &completionBlocks);
                        
           
        }
        
    }
    
    [UIView animateWithDuration:self.animationDuration/4.0f
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [firstStageAnimationBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             animationBlock firstBlock=obj;
                             firstBlock();
                         }]; //[firstStageAnimationBlocks enumerateObjectsUsingBlock:
                     } //animations:^{
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:3.0*self.animationDuration/4.0f
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionLayoutSubviews
                                          animations:^{
                                              [secondStageAnimationBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                  animationBlock secondBlock=obj;
                                                  secondBlock();
                                              }]; //[secondStageAnimationBlocks enumerateObjectsUsingBlock
                                          } //animations:^{
                          
                                          completion:^(BOOL finished) {
                                              self.hoverViewStatusStyle=hoverViewStatusStyle;
                                              self.animationOngoing=NO;
                                              [completionBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                  animationBlock completionBlock=obj;
                                                  completionBlock();
                                                  
                                              }];  // [completionBlocks enumerateObjectsUsingBlock:
                                              if (completion!=nil) {
                                                  completion(finished);
                                              }
                                          } // completion:^(BOOL finished)
                          
                          ]; //[UIView animateWithDuration:3.0*ANIMATION_DURATION/4.0
                     }  //completion:^(BOOL finished)
     
     ]; // [UIView animateWithDuration:ANIMATION_DURATION/4.0
                        
}


#pragma mark -
#pragma View Life Cycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    CGRect viewFrame=[UIScreen mainScreen].applicationFrame;
    UIView *mainView=[[UIView alloc] initWithFrame:viewFrame];
    mainView.autoresizingMask=(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    self.view=mainView;
    
    UIView *semiTransparentView=[[UIView alloc] initWithFrame:self.view.bounds];
    semiTransparentView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    semiTransparentView.backgroundColor = [UIColor blackColor];
    semiTransparentView.alpha=0.1;
    semiTransparentView.opaque=NO;
    semiTransparentView.exclusiveTouch=YES;
    [self.view addSubview:semiTransparentView];
    
    if (DEMO) {
        UIButton *aButton=nil;
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 10, 200, 37);
        [aButton setTitle:@"Exclusive Touch" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(ExclusiveTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 50, 200, 37);
        [aButton setTitle:@"Activity Only" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(Only:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 90, 200, 37);
        [aButton setTitle:@"Activity/Status" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(Status:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 130, 200, 37);
        [aButton setTitle:@"Progress/Status" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(progress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 170, 200, 37);
        [aButton setTitle:@"AlertImage" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(alertImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 210, 300, 37);
        aButton.tag=0;
        [aButton setTitle:@"Toggle to Normal Animation" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(toggleAnimationDuration:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
    }
    
    
    if (self.hoverViewStatusStyle!=BDHoverViewStatusExclusiveTouchStyle) {
        self.hoverView = [self hoverViewForStyle:self.hoverViewStatusStyle];
        self.activityIndicator.alpha=1.0f;
        self.statusLabel.alpha=1.0f;
        self.progressView.alpha=1.0f;
        // Add the hoverView to the viewController's view
        [self.view addSubview:self.hoverView];
        
    }
    
    
    
    
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
     self.animationOngoing=NO;
    
 
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    [self.hoverView setNeedsDisplay];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"BDHoverViewController didReceiveMemoryWarning");
    // Release any cached data, images, etc. that aren't in use.
}






@end
