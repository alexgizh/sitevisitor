#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExpandableViewDelegate <NSObject>

- (void)expandableViewMoved:(NSInteger)difference;
- (void)expandableViewFinishedMoving:(NSInteger)difference;

@end

@interface ExpandableView : UIView

@property (nonatomic, weak) id<ExpandableViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
