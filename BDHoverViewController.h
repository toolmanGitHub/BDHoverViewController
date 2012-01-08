//
//  BDHoverViewController.h
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
#import "BDStatusUpdateProtocol.h"

enum  {
    BDHoverViewControllerOptionsNone=0,
	BDHoverViewControllerOptionsShowBevel=1,
    BDHoverViewControllerOptionsShowBorder=2,
};
typedef NSInteger BDHoverViewControllerOptions;

@class BDHoverView;
/** Controls the style and animations the different styles of the BDHoverView.
 
 The animations from one style to another are accomplished by cascading two UIView's animateWithDuration:animations:completion calls.  The animation blocks are created dynamically based upon what UI elements are required (either removed or added) and the size of the BDHoverView.  
 
*/

@interface BDHoverViewController : UIViewController <BDStatusUpdateProtocol>{
	
    
}
/** Flag for whether or not the BDHoverView is currently animating from one style to another.
 
 */
@property (nonatomic) BOOL animationOngoing;

/** Image used with the BDUpdateStatusAlertMessageStyle
 
 */
@property (nonatomic, strong) UIImage *alertImage;

/** Initializes the BDHoverViewController and associated BDHoverView with a specific style.
 
 @return An initialized hover view controller object or nil if the object couldn't be created.
 @param hoverViewStatusStyle The style of the BDHoverView.
 @see BDStatusUpdateProtocol
 */
- (id)initWithHoverStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle;

/** Initializes the BDHoverViewController and associated BDHoverView with a specific style and options.
 
 Note that when the current style is BDHoverViewStatusAlertImageOnlyStyle, the hover view can only be animated to the BDHoverViewStatusExclusiveTouchStyle. Similarly, the BDHoverViewStatusImageOnlyStyle can be animated from the BDHoverViewStatusExclusiveTouchStyle.
 
 @return An initialized hover view controller object or nil if the object couldn't be created.
 @param hoverViewStatusStyle The style of the BDHoverView.
 @param options An XOR'd list of options of the type BDHoverViewControllerOptions for the BDHoverView object.
 @see BDStatusUpdateProtocol
 */
-(id)initWithHoverStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle options:(BDHoverViewControllerOptions)options;

/** Initializes the BDHoverViewController and associated BDHoverView with a specific style and options.
 
 Note that when the current style is BDHoverViewStatusAlertImageOnlyStyle, the hover view can only be animated to the BDHoverViewStatusExclusiveTouchStyle.  Similarly, the BDHoverViewStatusImageOnlyStyle can be animated from the BDHoverViewStatusExclusiveTouchStyle.
 
 @return An initialized hover view controller with the BDHoverViewStatusAlertImageOnlyStyle.
 @param alertImage The UIImage to be placed horizontally and vertically centered within the hoverView.
 @param options An XOR'd list of options of the type BDHoverViewControllerOptions for the BDHoverView object.
 @see BDStatusUpdateProtocol
 */
-(id)initWithAlertImage:(UIImage *)alertImage options:(BDHoverViewControllerOptions)options;

@end
