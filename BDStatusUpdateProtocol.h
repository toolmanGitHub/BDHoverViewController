enum  {
    BDHoverViewStatusNothingStyle=-1,
    BDHoverViewStatusExclusiveTouchStyle=100,
	BDHoverViewStatusActivityOnlyStyle,
    BDHoverViewStatusActivityAndStatusStyle,
	BDHoverViewStatusActivityProgressStyle,
    BDHoverViewStatusAlertImageOnlyStyle,
};
typedef NSInteger BDHoverViewStatusStyle;
/**
 Protocol that defines methods that a view controller is required to implement in order to update the user with progress or status information.
 
    `enum  {
    BDHoverViewStatusNothingStyle=-1,  
    BDHoverViewStatusExclusiveTouchStyle=100, Just a full screen semi-transparent view
    BDHoverViewStatusActivityOnlyStyle,       Hover view with rounded corners that shows only a UIActivityIndicator
    BDHoverViewStatusActivityAndStatusStyle,  Hover view with rounded corners a UIActivityIndicator and a status UILabel
    BDHoverViewStatusActivityProgressStyle,   Hover view with rounded corners, UIActivityIndicator, status UILabel, and UIProgressView
    BDHoverViewStatusAlertImageOnlyStyle,     Hover view with rounded corners and a supplied UIImage. Note that when the current style is BDHoverViewStatusAlertImageOnlyStyle, the hover view can ONLY be animated to the BDHoverViewStatusExclusiveTouchStyle. Similarly, the BDHoverViewStatusImageOnlyStyle can ONLY be animated from the BDHoverViewStatusExclusiveTouchStyle.
    };
    typedef NSInteger BDHoverViewStatusStyle;`
 
 */
@protocol BDStatusUpdateProtocol <NSObject>
@required
/** If present in the view, this method shall update the UIProgressView with the latest progress value.
 
 @param progress The progress value.
 */

-(void)updateHoverViewProgressWithProgressValue:(float)progress;

@required
/** If present in the view, this method shall update the UILabel with the latest status.
 
 @param status The progress value.
 */
-(void)updateHoverViewStatus:(NSString *)status;

/** 
 
 @param hoverViewStatusStyle The style of the status hover view.
 @param completion Completion block that is executed after the animation is complete.
 
 */
-(void)animateToHoverViewStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle completion:(void (^)(BOOL finished))completion;

/** Updates both the progress of the UIProgressView and the status of the view's UILabel.
 
 @param status The current status.
 @param progress The current progress value.
 @see updateHoverViewStatus:
 @see updateHoverViewProgressWithProgressValue:
 */

-(void)updateHoverViewStatus:(NSString *)status progressValue:(float)progress;

@end
