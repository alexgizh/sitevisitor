#import "TagsControl.h"
#import "SwipeView.h"
#import "TagsPageView.h"
#import "Building.h"
#import "ExpandableView.h"

#define TAGS_CONTROL_HEIGHT 250
#define TAGS_CONTROL_EXPANDED_HEIGHT 350

@interface TagsControl ()
<SwipeViewDataSource, SwipeViewDelegate, ExpandableViewDelegate, TagsPageViewDelegate>
{
    IBOutlet __weak UIView *controlContainer;
    IBOutlet __weak SwipeView *swipeView;
    IBOutlet __weak UIButton *buildingButton;
    IBOutlet __weak UILabel *categoryLabel;
    IBOutlet __weak UIPageControl *pageControl;
    IBOutlet __weak ExpandableView *expandableView;
    
    IBOutlet __weak TagsPageView *staticTagsContainer;
    TagsPageView *staticTagsPage;
    
    IBOutlet __weak NSLayoutConstraint *height;
    NSMutableArray *tagsPageViews;
    
    Tag *selectedTag;
    Site *site;
    Building *currentBuilding;
    BOOL expanded;
}
@end

@implementation TagsControl

- (instancetype)init
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TagsControl"
                                                      owner:self
                                                    options:nil];
    
    self = (TagsControl *)[nibViews objectAtIndex:0];
    expandableView.delegate = self;

    return self;
}

- (void)setupWithSite:(Site *)aSite tagCategories:(NSArray *)tagCategories andSitePhotos:(NSArray *)sitePhotos
{
    [self contract];
    
    tagsPageViews = [NSMutableArray new];

    site = aSite;
    currentBuilding = [site.buildings objectAtIndex:0];
    [buildingButton setTitle:currentBuilding.name forState:UIControlStateNormal];
    
    staticTagsPage = [TagsPageView new];
    staticTagsPage.delegate = self;
    staticTagsPage.tagCategory = [tagCategories objectAtIndex:0];
    [staticTagsContainer addSubview:staticTagsPage];
    
    for (TagCategory *category in tagCategories) {
        if ([category isEqual:[tagCategories firstObject]]) {
            continue;
        }
        TagsPageView *page = [TagsPageView new];
        page.delegate = self;
        page.tagCategory = category;
        [tagsPageViews addObject:page];
    }
    categoryLabel.text = [[(TagsPageView *)[tagsPageViews objectAtIndex:0] tagCategory] name];

    //configure swipe view
    swipeView.dataSource = self;
    swipeView.delegate = self;
    swipeView.alignment = SwipeViewAlignmentCenter;
    swipeView.pagingEnabled = YES;
    swipeView.wrapEnabled = NO;
    swipeView.itemsPerPage = 1;
    swipeView.truncateFinalPage = YES;
    
    //configure page control
    pageControl.numberOfPages = swipeView.numberOfPages;
    pageControl.defersCurrentPageDisplay = YES;
}

#pragma mark - TagsPageViewDelegate

- (void)didSelectTag:(Tag *)tag
{
    selectedTag = tag;
    [(UICollectionView *)[tagsPageViews objectAtIndex:pageControl.currentPage] reloadData];
    [staticTagsPage reloadData];
    [self.delegate didSelectTag:tag];
}

- (Tag *)selectedTag
{
    return selectedTag;
}


#pragma mark - Swipe view data source methods

- (NSInteger)numberOfItemsInSwipeView:(__unused SwipeView *)swipeView
{
    return tagsPageViews.count;
}

- (UIView *)swipeView:(__unused SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return [tagsPageViews objectAtIndex:index];
}

#pragma mark - Swipe view delegate methods

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)aSwipeView
{
    categoryLabel.text = [[(TagsPageView *)[tagsPageViews objectAtIndex:aSwipeView.currentPage] tagCategory] name];
    pageControl.currentPage = aSwipeView.currentPage;
}

- (void)swipeView:(__unused SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected item at index %li", (long)index);
}

#pragma mark - Page control

- (IBAction)pageControlTapped
{
    //update swipe view page
    [swipeView scrollToPage:pageControl.currentPage duration:0.4];
}

#pragma mark - Actions

- (void)show
{
    [pageControl setCurrentPage:0];
    [swipeView setCurrentPage:0];
    [swipeView reloadData];
    [UIView beginAnimations:@"showTagsControl" context:nil];
    [UIView setAnimationDuration:0.4];
    [self setFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-TAGS_CONTROL_EXPANDED_HEIGHT, UIScreen.mainScreen.bounds.size.width, TAGS_CONTROL_EXPANDED_HEIGHT)];
    [UIView commitAnimations];
}

- (IBAction)hide
{
    [UIView beginAnimations:@"hideTagsControl" context:nil];
    [UIView setAnimationDuration:0.4];
    [self setFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, TAGS_CONTROL_EXPANDED_HEIGHT)];
    [UIView commitAnimations];
}

- (void)expandableViewMoved:(NSInteger)difference
{
    [UIView beginAnimations:@"expandable" context:nil];
    [UIView setAnimationDuration:0.4];
    NSInteger defaultHeight = TAGS_CONTROL_HEIGHT;
    if (expanded) {
        defaultHeight = TAGS_CONTROL_EXPANDED_HEIGHT;
    }
    height.constant = height.constant - difference;
    [UIView commitAnimations];
    NSLog(@"Moved: %ld",difference);
}

- (void)expandableViewFinishedMoving:(NSInteger)difference
{
    NSInteger diffExpand = abs((int)height.constant - TAGS_CONTROL_EXPANDED_HEIGHT);
    NSInteger diffContract = abs((int)height.constant - TAGS_CONTROL_HEIGHT);
    if (diffExpand < diffContract) {
        [self expand];
    } else {
        [self contract];
    }
}

- (void)expand
{
    [UIView beginAnimations:@"expand" context:nil];
    [UIView setAnimationDuration:0.4];
    height.constant = TAGS_CONTROL_EXPANDED_HEIGHT;
    expanded = YES;
    [self layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)contract
{
    [UIView beginAnimations:@"contract" context:nil];
    [UIView setAnimationDuration:0.4];
    height.constant = TAGS_CONTROL_HEIGHT;
    expanded = NO;
    [self layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(15.0, 15.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    controlContainer.layer.mask = maskLayer;
}

#pragma mark - Events

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        if (!view.hidden && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

@end
