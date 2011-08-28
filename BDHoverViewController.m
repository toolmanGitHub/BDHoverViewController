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

#define ANIMATION_DURATION 0.4f
#define DEMO NO
typedef void (^animationBlock)(void);

@interface BDHoverViewController (){
    BDHoverView *hoverView_;
    BDHoverViewStatusStyle hoverViewStatusStyle_;
    
    UIActivityIndicatorView *activityIndicator_;
    UILabel *statusLabel_;
    UIProgressView *progressView_;
    
    NSString *currentStatusString_;
    float currentProgress_;
    
}
@property (nonatomic,retain) BDHoverView *hoverView;
@property (nonatomic) BDHoverViewStatusStyle hoverViewStatusStyle;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) NSString *currentStatusString;
@property (nonatomic) float currentProgress;

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

// Private
@synthesize hoverView = hoverView_;
@synthesize hoverViewStatusStyle = hoverViewStatusStyle_;
@synthesize activityIndicator = activityIndicator_;
@synthesize statusLabel = statusLabel_;
@synthesize progressView = progressView_;
@synthesize currentStatusString = currentStatusString_;
@synthesize currentProgress = currentProgress_;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)initWithHoverStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    self = [super init];
    if (self){
        hoverViewStatusStyle_=hoverViewStatusStyle;
    }
    return self;
}

- (id)init{
    self = [self initWithHoverStatusStyle:BDHoverViewStatusNothingStyle];
    
    return self;
}

-(void)updateHoverViewProgressWithProgressValue:(float)progress{
    self.progressView.progress=progress;
    self.currentProgress = progress;
}
-(void)updateHoverViewStatus:(NSString *)status{
    self.statusLabel.text=status;
    self.currentStatusString=status;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
   
    CGRect viewFrame=[UIScreen mainScreen].applicationFrame;
    UIView *mainView=[[UIView alloc] initWithFrame:viewFrame];
    mainView.autoresizingMask=(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    self.view=mainView;
    [mainView release];
    
    UIView *semiTransparentView=[[UIView alloc] initWithFrame:self.view.bounds];
    semiTransparentView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    semiTransparentView.backgroundColor = [UIColor blackColor];
    semiTransparentView.alpha=0.1;
    semiTransparentView.opaque=NO;
    semiTransparentView.exclusiveTouch=YES;
    [self.view addSubview:semiTransparentView];
    [semiTransparentView release];
    
    if (DEMO) {
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 10, 50, 37);
        [aButton addTarget:self action:@selector(ExclusiveTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 50, 50, 37);
        [aButton addTarget:self action:@selector(Only:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 90, 50, 37);
        [aButton addTarget:self action:@selector(Status:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
        
        aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake(10, 130, 50, 37);
        [aButton addTarget:self action:@selector(progress:) forControlEvents:UIControlEventTouchUpInside];
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

-(BDHoverView *)hoverViewForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    
    
    CGRect hoverViewFrame=[self hoverViewFrameForStyle:hoverViewStyle];
    
	BDHoverView *aHoverView=[[BDHoverView alloc] initWithFrame:hoverViewFrame];
    aHoverView.layer.opacity=0.7f;
    aHoverView.animationDuration=3*ANIMATION_DURATION/4.0;
    
   
    self.activityIndicator = [self activityIndicatorForStyle: hoverViewStyle];
    [aHoverView addSubview:self.activityIndicator];
    
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
    }

    return [aHoverView autorelease];
    
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
    CGFloat hoverViewWidth=290.0;
    CGFloat hoverViewHeight=0.0;
    CGFloat hoverViewX=0.0;
    CGFloat hoverViewY=0.0;
   
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusExclusiveTouchStyle:{
            hoverViewWidth=0.0f;
            break;
        }
        case BDHoverViewStatusActivityOnlyStyle:
        {
            hoverViewHeight = 77.0;
            hoverViewWidth = 77.0;
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            hoverViewHeight = 101.0;
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            hoverViewHeight = 180.0;
            break;
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
      aActivityIndicator.alpha=0.0;
    aActivityIndicator.opaque=YES;
    aActivityIndicator.frame=[self activityIndicatorFrameForStyle:hoverViewStyle];
    return [aActivityIndicator autorelease];
}

-(CGRect)activityIndicatorFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGRect activityIndicatorFrame=CGRectZero;
    
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusExclusiveTouchStyle:
        {
            activityIndicatorFrame=CGRectMake(0.0, 0.0, 37.0,37.0);
            break;
        }
        case BDHoverViewStatusActivityOnlyStyle:
        {
            // Adjust the frame location of the activityIndicator Frame
            activityIndicatorFrame=CGRectMake(20.0, 20.0, 37.0,37.0);
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            // Adjust the frame location of the activityIndicator Frame
            activityIndicatorFrame=CGRectMake(128.0, 15.0, 37.0,37.0);
            
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
    
    UILabel *aStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(21, 70, 248.0, 21)];
    
    aStatusLabel.frame = [self statusLabelFrameForStyle: hoverViewStyle];
    
    aStatusLabel.backgroundColor=[UIColor clearColor];
    aStatusLabel.textColor=[UIColor whiteColor];
    aStatusLabel.textAlignment = UITextAlignmentCenter;
    aStatusLabel.alpha=0.0;
    aStatusLabel.opaque=YES;
    if (currentStatusString_!=nil) {
        aStatusLabel.text=self.currentStatusString;
    }else{
        aStatusLabel.text=@"Yeah, a really long status message";
    }
    
    return [aStatusLabel autorelease];
    
}


-(CGRect)statusLabelFrameForStyle:(BDHoverViewStatusStyle)hoverViewStyle{
    CGRect statusLabelFrame=CGRectZero;
    switch (hoverViewStyle) {
        case BDHoverViewStatusActivityOnlyStyle:
        {
            statusLabelFrame=CGRectMake(10, 0.0, 248, 21);
            break;
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
           statusLabelFrame=CGRectMake(21, 60, 248, 21);
            break;
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            statusLabelFrame=CGRectMake(21, 111, 248, 21);
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
    aProgressView.autoresizingMask=UIViewAutoresizingNone;

    aProgressView.frame=[self progressViewFrameForStyle:hoverViewStyle];
    aProgressView.progress = self.currentProgress;
    return [aProgressView autorelease];

}

-(CGRect)progressViewFrameForStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle{
    CGRect progressViewFrame=CGRectZero;
    
    switch (hoverViewStatusStyle) {
        case BDHoverViewStatusActivityOnlyStyle:
        {
            progressViewFrame=CGRectMake(22.0,77.0,5.0f,9.0);
            break;
            
        }
        case BDHoverViewStatusActivityAndStatusStyle:
        {
            progressViewFrame=CGRectMake(22.0,77.0,248.0,9.0);
            break;
            
        }
        case BDHoverViewStatusActivityProgressStyle:
        {
            progressViewFrame=CGRectMake(22, 94.0, 248.0, 9.0);
            break;
        }
    }
    
    return progressViewFrame;
}



#pragma mark -
#pragma mark IBAction Methods

- (IBAction)progress:(id)sender {
    if (!self.animationOngoing) {
        [self hoverViewStatusStyle:BDHoverViewStatusActivityProgressStyle animated:YES completion:nil];
    }
    
}

- (IBAction)Status:(id)sender {
    if (!self.animationOngoing) {
        [self hoverViewStatusStyle:BDHoverViewStatusActivityAndStatusStyle animated:YES completion:nil];
    }
    
}

- (IBAction)Only:(id)sender {
    //  if (!self.animationOngoing) {
        [self hoverViewStatusStyle:BDHoverViewStatusActivityOnlyStyle animated:YES completion:nil];
    // }
    

}

- (IBAction)ExclusiveTouch:(id)sender {
    //  if (!self.animationOngoing) {
    [self hoverViewStatusStyle:BDHoverViewStatusExclusiveTouchStyle animated:YES completion:nil];
    // }
    
    
}


#pragma mark -
#pragma mark Populating Animation Block Arrays

void StatusLabelAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks){
    
    animationBlock firstBlock=nil;
    animationBlock secondBlock=nil;
    animationBlock completionBlock=nil;
    // Remove Status Label
    
    if ((hoverViewStatusStyle!=BDHoverViewStatusActivityAndStatusStyle && hoverViewStatusStyle!=BDHoverViewStatusActivityProgressStyle) && (self.statusLabel!=nil)) {
        firstBlock=[^{
            //              NSLog(@"First Block:  Status Label Alpha 0.0");
            self.statusLabel.alpha=0.0f;
        } copy];
        [*firstBlocks addObject: firstBlock];
        [firstBlock release];
        
        completionBlock=[^{
            //             NSLog(@"            Completion Block:  Remove Status Label");
            [self.statusLabel removeFromSuperview];
            self.statusLabel=nil;
        } copy];
        [*completionBlocks addObject: completionBlock];
        [completionBlock release];
        
    }
    // Status Label
    if ( (hoverViewStatusStyle==BDHoverViewStatusActivityAndStatusStyle || hoverViewStatusStyle==BDHoverViewStatusActivityProgressStyle)) {
        
        if (self.statusLabel==nil) {
            self.statusLabel=[self statusLabelForStyle:hoverViewStatusStyle];
        }
        
        if (self.statusLabel.superview==nil) {
            [self.hoverView addSubview:self.statusLabel];
        }
        secondBlock=[^{
            //        NSLog(@"        Second Block:  Status Label Alpha and Frame");
            self.statusLabel.alpha=1.0;
            self.statusLabel.frame=[self statusLabelFrameForStyle:hoverViewStatusStyle];
        } copy];
        [*secondBlocks addObject: secondBlock];
        [secondBlock release];
        
        completionBlock=[^{
            //           NSLog(@"            Completion Block:  Status Label Reapply Alpha");
            self.statusLabel.alpha=1.0;
        } copy];
        [*completionBlocks addObject: completionBlock];
        [completionBlock release];
        
        
    }
    
}

void ProgressViewAnimationBlocksForStyle(BDHoverViewController *self, BDHoverViewStatusStyle hoverViewStatusStyle, NSMutableArray **firstBlocks, NSMutableArray **secondBlocks, NSMutableArray **completionBlocks){
    
    animationBlock firstBlock=nil;
    animationBlock secondBlock=nil;
    animationBlock completionBlock=nil;

    // Progress View
    if (hoverViewStatusStyle!=BDHoverViewStatusActivityProgressStyle && (self.progressView!=nil)) {
        
        firstBlock=[^{
            //              NSLog(@"First Block:  Progress Alpha to 0.0");
            self.progressView.alpha=0.0f;
        } copy];
        [*firstBlocks addObject: firstBlock];
        [firstBlock release];
        
        completionBlock=[^{
            //                NSLog(@"            Completion Block:  Removing Progress View");
            [self.progressView removeFromSuperview];
            self.progressView=nil;
        } copy];
        [*completionBlocks addObject: completionBlock];
        [completionBlock release];
    }
    
    if (hoverViewStatusStyle==BDHoverViewStatusActivityProgressStyle ) {
        if (self.progressView==nil) {
            self.progressView=[self progressViewForStyle:self.hoverViewStatusStyle];
        }
        //           NSLog(@"    ProgressView:  %@",self.progressView);
        if (self.progressView.superview==nil){
            [self.hoverView addSubview:self.progressView];
        }
        CGRect newProgressFrame=[self progressViewFrameForStyle:hoverViewStatusStyle];
        secondBlock=[^{
            //                  NSLog(@"    Second Block:  Progress Alpha and Frame");
            self.progressView.alpha=1.0f;
            self.progressView.frame=newProgressFrame;
        } copy];
        [*secondBlocks addObject: secondBlock];
        [secondBlock release];
        
        completionBlock=[^{
            //          NSLog(@"            Completion Block:  Setting Progress Alpha again");
            
        } copy];
        [*completionBlocks addObject: completionBlock];
        [completionBlock release];
        
    }
}


#pragma mark -
#pragma mark hoverView Animation
-(void)hoverViewStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{

    if (self.animationOngoing || hoverViewStatusStyle==self.hoverViewStatusStyle) {
        return;
    }
       NSLog(@"hoverViewStatusStyle animation start");
    
    self.animationOngoing=YES;
    self.hoverView.animationDuration=3*ANIMATION_DURATION/4.0;
    typedef void (^animationBlock)(void);
    
    NSMutableArray *firstStageAnimationBlocks=[NSMutableArray arrayWithCapacity:1];
    NSMutableArray *secondStageAnimationBlocks=[NSMutableArray arrayWithCapacity:1];
    NSMutableArray *completionBlocks=[NSMutableArray arrayWithCapacity:1];
    animationBlock firstBlock;
    animationBlock secondBlock;
    animationBlock completionBlock;
        
    
    if (self.hoverViewStatusStyle==BDHoverViewStatusExclusiveTouchStyle && hoverViewStatusStyle!=BDHoverViewStatusExclusiveTouchStyle) {
               
        self.hoverView = [self hoverViewForStyle:hoverViewStatusStyle];
        //     [CATransaction begin];
        //  [CATransaction setDisableActions:YES];
            self.hoverView.frame=[self hoverViewFrameForStyle:self.hoverViewStatusStyle];
        //    [self.hoverView layoutIfNeeded];
        //      self.hoverView.alpha=0.7;
        // [CATransaction commit];
        [self.view addSubview:self.hoverView];
        self.hoverView.animationDuration=ANIMATION_DURATION/4.0;
        firstBlock=[^{
            //      NSLog(@"First Block:  bringing up hoverView");
            self.hoverView.frame=[self hoverViewFrameForStyle:hoverViewStatusStyle];
        } copy];
        
        [firstStageAnimationBlocks addObject: firstBlock];
        
        [firstBlock release];
        
        secondBlock=[^{
            //      NSLog(@"    Second Block:  Setting Alpha for UI subviews");
            self.activityIndicator.alpha=1.0f;
            self.statusLabel.alpha=1.0f;
            self.progressView.alpha=1.0f;
        } copy];
        [secondStageAnimationBlocks addObject: secondBlock];
        [secondBlock release];
        
        
    }else{
        if (hoverViewStatusStyle==BDHoverViewStatusExclusiveTouchStyle) {
            //      NSLog(@"tearing it down");
            firstBlock=[^{
                //          NSLog(@"First Block: tear down hoverView");
                self.hoverView.alpha=0.0f;
            } copy];
            
            [firstStageAnimationBlocks addObject: firstBlock];
            
            [firstBlock release];
           
            //  self.hoverView.layer.opacity=0.0;
           
            completionBlock=[^{
                //      NSLog(@"                Completion block:  tearDown tear down hoverView");
                [self.hoverView removeFromSuperview];
                self.hoverView=nil;
                self.activityIndicator=nil;
                self.statusLabel=nil;
                self.progressView=nil;
            } copy];
            
            [completionBlocks addObject:completionBlock];
            [completionBlock release];
               
        }else{
            
            StatusLabelAnimationBlocksForStyle(self, hoverViewStatusStyle, &firstStageAnimationBlocks, &secondStageAnimationBlocks,&completionBlocks);
            ProgressViewAnimationBlocksForStyle(self, hoverViewStatusStyle, &firstStageAnimationBlocks, &secondStageAnimationBlocks, &completionBlocks);
                        
            secondBlock=[^{
                //            NSLog(@"        Second Block:  HoverView and Activity Frame");
                self.hoverView.frame=[self hoverViewFrameForStyle:hoverViewStatusStyle];
                self.activityIndicator.frame=[self activityIndicatorFrameForStyle:hoverViewStatusStyle];
            } copy];
            [secondStageAnimationBlocks addObject: secondBlock];
            [secondBlock release];
        }
        
        //   
    }
    
    [UIView animateWithDuration:ANIMATION_DURATION/4.0
                     animations:^{
                         [firstStageAnimationBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             animationBlock firstBlock=obj;
                             firstBlock();
                         }];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:3.0*ANIMATION_DURATION/4.0
                                          animations:^{
                                              [secondStageAnimationBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                  animationBlock secondBlock=obj;
                                                  secondBlock();
                                              }];
                                          }
                                          completion:^(BOOL finished) {
                                              self.hoverViewStatusStyle=hoverViewStatusStyle;
                                              self.animationOngoing=NO;
                                              [completionBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                  animationBlock completionBlock=obj;
                                                  completionBlock();
                                                  if (completion!=nil) {
                                                      completion(finished);
                                                  }
                                              }];  // completion:^(BOOL finished)
                                              
                                          } // completion:^(BOOL finished)
                          ]; //[UIView animateWithDuration:3.0*ANIMATION_DURATION/4.0
                     }  //completion:^(BOOL finished)
     ];
                        
}


#pragma mark -
#pragma View Life Cycle
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
	self.hoverView=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.activityIndicator=nil;
    self.statusLabel=nil;
    self.progressView=nil;
}

#pragma mark -
#pragma Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"BDHoverViewController didReceiveMemoryWarning");
    // Release any cached data, images, etc. that aren't in use.
}




- (void)dealloc {
	[hoverView_ release];
    [activityIndicator_ release];
    [statusLabel_ release];
    [progressView_ release];
    [currentStatusString_ release];
    [super dealloc];
}


@end
