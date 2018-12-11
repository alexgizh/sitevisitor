#import "Defaults.h"

@implementation Defaults
{
	NSUserDefaults* defaults;
}

+ (instancetype)standard
{
	static Defaults *standardDefaults = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		standardDefaults = [[Defaults alloc] init];
	});
	return standardDefaults;
}

- (instancetype)init
{
	if ((self = [super init]) == nil) { return nil; }
    defaults = [NSUserDefaults standardUserDefaults];
    if ([self uploadCounter] == nil) {
        [self setUploadCounter:[NSNumber numberWithInt:0]];
    }
	return self;
}

- (void)setUploadCounter:(NSNumber *)uploadCounter
{
    [defaults setObject:uploadCounter forKey:@"uploadCounter"];
}

- (NSNumber *)uploadCounter
{
    return [defaults objectForKey:@"uploadCounter"];
}

@end
