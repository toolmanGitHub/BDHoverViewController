//
//  BDHoverView.h
//  
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
/**
 A subclass of UIView that has the following main characteristics
 
 1. Semi-transparent black backgroundColor
 2. Rounded Corners
 
*/

@interface BDHoverView : UIView {
	
    
}

/** Duration of the view's animation.

Normally this would be a static value, but depending on the animations in BDHoverViewController, it may need to change on the fly.

 */
@property (nonatomic) NSTimeInterval animationDuration;

/** Initializes the BDHoverView with or without a bevel or stroked border.  The default is to show a bevel and not show the border.
 
 @return An initialized BDHoverView object or nil if the object couldn't be created.
 @param frame The CGRect frame.
 @param showBevel A Boolean which indicates whether or not a bevel should be drawn.  Default is YES.
 @param showBorder A Boolean which indicates whether or not a white border is stroked on the hover view.  Default is NO.
*/
- (id)initWithFrame:(CGRect)frame showBevel:(BOOL)showBevel showBorder:(BOOL)showBorder;

@end
