enum  {
    BDHoverViewStatusNothingStyle=-1,
    BDHoverViewStatusExclusiveTouchStyle=100,
	BDHoverViewStatusActivityOnlyStyle,
    BDHoverViewStatusActivityAndStatusStyle,
	BDHoverViewStatusActivityProgressStyle,
};
typedef NSInteger BDHoverViewStatusStyle;
/**
 Protocol that defines methods that a view controller is required to implement in order to update the user with progress or status information.
 
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
-(void)hoverViewStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle completion:(void (^)(BOOL finished))completion;

/** Updates both the progress of the UIProgressView and the status of the view's UILabel.
 
 @param status The current status.
 @param progress The current progress value.
 @see updateHoverViewStatus:
 @see updateHoverViewProgressWithProgressValue:
 */

-(void)updateHoverViewStatus:(NSString *)status progressValue:(float)progress;

@end
