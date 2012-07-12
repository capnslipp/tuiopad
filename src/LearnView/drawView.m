//
//  drawView.m
//  TuioPad
//
//  Created by Oleg Langer on 03.01.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

@synthesize dots = _dots;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dots = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void) addPointsFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.dots removeAllObjects];
    
    for (UITouch * touch in event.allTouches) {
        if(touch.phase==UITouchPhaseEnded||[touch phase]==UITouchPhaseCancelled) continue;
        CGPoint location = [touch locationInView:self]; 
        if(location.x < 0 || location.y < 0) continue;
        NSValue* point = [NSValue valueWithCGPoint:location];
        [self.dots addObject:point];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
    [self addPointsFromTouches:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {	
    [self addPointsFromTouches:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
    [self addPointsFromTouches:touches withEvent:event];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIColor grayColor] setFill];
    UIRectFill(rect);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor blueColor] CGColor]);

    for (NSValue* value in self.dots) {
        CGPoint pt = [value CGPointValue];
        CGContextAddArc(ctx, pt.x, pt.y, 10.0f, 0.0f, 2.0f * M_PI, YES);
        CGContextFillPath(ctx);
    }
}

- (void) dealloc {
    [self.dots release];
    [super dealloc];
}


@end
