//
//  SampleHoverViewProjectAppDelegate.m
//  SampleHoverViewProject
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

#import "SampleHoverViewProjectAppDelegate.h"
#import <BDHoverViewController/BDHoverViewController.h>
@implementation SampleHoverViewProjectAppDelegate

@synthesize window = _window;
@synthesize uiChangeTimer;
@synthesize hoverViewController;
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    //    self.uiChangeTimer=[NSTimer scheduledTimerWithTimeInterval:1.75 target:self selector:@selector(timerFiredMethod) userInfo:nil repeats:YES];
	
    
//     hoverViewController=[[BDHoverViewController alloc] initWithHoverStatusStyle:BDHoverViewStatusActivityProgressStyle
//                                                                        options:BDHoverViewControllerOptionsNone];
//    hoverViewController=[[BDHoverViewController alloc] initWithHoverStatusStyle:BDHoverViewStatusActivityProgressStyle
//                                                                        options:BDHoverViewControllerOptionsShowBevel];
//    hoverViewController=[[BDHoverViewController alloc] initWithHoverStatusStyle:BDHoverViewStatusActivityProgressStyle
//                                                                        options:BDHoverViewControllerOptionsShowBorder];
//    hoverViewController=[[BDHoverViewController alloc] initWithHoverStatusStyle:BDHoverViewStatusActivityProgressStyle
//                                                                        options:(BDHoverViewControllerOptionsShowBorder | BDHoverViewControllerOptionsShowBevel)];
    
    // !!Note you can only toggle between the BDHoverViewStatusExclusiveTouchStyle and the BDHoverViewStatusAlertImageOnlyStyle style.
    
    hoverViewController=[[BDHoverViewController alloc] initWithAlertImage:[UIImage imageNamed:@"sampleAlertImage.png"] options:(BDHoverViewControllerOptionsShowBorder | BDHoverViewControllerOptionsShowBevel)];
    
    
    self.window.rootViewController=hoverViewController;
	[self.window makeKeyAndVisible];
    
    NSTimeInterval delay_in_seconds = 3.0;
	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delay_in_seconds * NSEC_PER_SEC);
	__weak SampleHoverViewProjectAppDelegate *blockSelf=self;
	dispatch_after(delay, dispatch_get_main_queue(), ^{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0),^{
            NSInteger iCntr=0;
            for (iCntr=0; iCntr<1000000000; iCntr++) {
                if ((iCntr % 1000)==0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [blockSelf.hoverViewController updateHoverViewStatus:[NSString stringWithFormat:@"Value:  %f",iCntr/1000000000.0]
                                                               progressValue:(float)iCntr/1000000000.0];
                    });
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf.hoverViewController updateHoverViewStatus:@"Complete!!"
                                                       progressValue:1.0];
            });
            
        });
    });
    
   
	
    
    return YES;
}

-(void)timerFiredMethod{
    NSInteger displayStyle=random()%4+100;
    __weak SampleHoverViewProjectAppDelegate *blockSelf=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [blockSelf.hoverViewController animateToHoverViewStatusStyle:displayStyle completion:nil];
    });
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    NSLog(@"applicationDidReceiveMemoryWarning");
}


- (void)dealloc {
    [uiChangeTimer invalidate];
}

@end
