#import "ExpandableView.h"
#import "TagsControl.h"

@implementation ExpandableView

float oldX, oldY;
BOOL dragging;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    dragging = YES;
    oldX = touchLocation.x;
    oldY = touchLocation.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (dragging) {
        [self.delegate expandableViewFinishedMoving:touchLocation.y-oldY];
    }
    dragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    CGPoint translatedPoint = [self convertPoint:touchLocation toView:window];
    oldY = 0;
    if (translatedPoint.y < UIScreen.mainScreen.bounds.size.height-TAGS_CONTROL_EXPANDED_HEIGHT) {
        return;
    }
    if (dragging) {
        [self.delegate expandableViewMoved:touchLocation.y-oldY];
    }
}

@end
