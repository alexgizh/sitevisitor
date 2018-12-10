#import "TagsPageView.h"
#import "TagCell.h"

@interface TagsPageView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet __weak UICollectionView *collectionView;
}

@end

@implementation TagsPageView

- (instancetype)init
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TagsPageView"
                                                          owner:self
                                                        options:nil];
    
    self = (TagsPageView *)[nibViews objectAtIndex:0];
        
    [collectionView registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil] forCellWithReuseIdentifier:@"TagCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;

    return self;
}

- (void)reloadData
{
    [collectionView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagCategory.tags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    Tag *tag = [self.tagCategory.tags objectAtIndex:indexPath.row];
    BOOL selected = [[[self.delegate selectedTag] name] isEqualToString:tag.name];
    [cell setupWithTag:tag selected:selected];
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectTag:[self.tagCategory.tags objectAtIndex:indexPath.row]];
    [collectionView reloadData];
}

@end
