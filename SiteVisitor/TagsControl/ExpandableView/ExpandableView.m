#import "ExpandableView.h"

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
    oldY = 0;
    if (dragging) {
        [self.delegate expandableViewMoved:touchLocation.y-oldY];
    }
}

@end
