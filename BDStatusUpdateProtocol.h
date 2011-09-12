enum  {
    BDHoverViewStatusNothingStyle=-1,
    BDHoverViewStatusExclusiveTouchStyle=100,
	BDHoverViewStatusActivityOnlyStyle,
    BDHoverViewStatusActivityAndStatusStyle,
	BDHoverViewStatusActivityProgressStyle,
};
typedef NSInteger BDHoverViewStatusStyle;

@protocol BDStatusUpdateProtocol <NSObject>
@required
-(void)updateHoverViewProgressWithProgressValue:(float)progress;
-(void)updateHoverViewStatus:(NSString *)status;
-(void)hoverViewStatusStyle:(BDHoverViewStatusStyle)hoverViewStatusStyle animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
-(void)updateHoverViewStatus:(NSString *)status progressValue:(float)progress;

@end
