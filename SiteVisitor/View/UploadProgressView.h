#import <UIKit/UIKit.h>
#import "SitePhoto.h"

@protocol UploadProgressViewDelegate;

@interface UploadProgressView : UIView

@property (nonatomic, weak) id<UploadProgressViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIProgressView *progressBar;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;

- (void)setNotUploadedCounter:(int)totalPhotos uploadedPhotos:(int)uploadedPhotos;

@end

@protocol UploadProgressViewDelegate  <NSObject>

- (void)changePage:(UIPageViewControllerNavigationDirection)direction nextIndex:(NSUInteger)index;

@end
