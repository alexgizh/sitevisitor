#import <UIKit/UIKit.h>
#import "TagCategory.h"
#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TagsPageViewDelegate
- (Tag *)selectedTag;
- (void)didSelectTag:(Tag *)tag;
@end

@interface TagsPageView : UIView

@property (nonatomic, strong) TagCategory *tagCategory;
@property (nonatomic, weak) id<TagsPageViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
