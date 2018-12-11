#import <Foundation/Foundation.h>

@interface Defaults : NSObject

+ (instancetype _Nonnull)standard;

@property(nonatomic, copy, nullable) NSNumber *uploadCounter;

@end
