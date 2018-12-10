#import "UploadProgressView.h"

@implementation UploadProgressView
@synthesize delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        [self load];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self load];
    }
    return self;
}

- (void)load {
    UIView *view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"UploadProgressView" owner:self options:nil] firstObject];
    [self addSubview:view];
    view.frame = self.bounds;
}

- (void)setNotUploadedCounter:(int)totalPhotos uploadedPhotos:(int)uploadedPhotos {
    _progressBar.progress = uploadedPhotos/totalPhotos;
    _progressLabel.text = [NSString stringWithFormat:@"Uploading in progress %d of %d", uploadedPhotos, totalPhotos];
}

@end
