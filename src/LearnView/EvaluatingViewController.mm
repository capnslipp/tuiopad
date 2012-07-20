//
//  EvaluatingViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EvaluatingViewController.h"
#import "MyCursorInfo.h"
#import "SimpleTriangle.h"

static int eventCounter = 0;

#define NUMBER_OF_BINS 30

@interface PlotterView() {
    CGPoint axesOrigin;
    CGFloat xAxisWidth;
    CGFloat yAxisWidth;
    
    CGFloat binWidth;
    CGFloat binHeight;
}

@end


@implementation PlotterView

@synthesize values = _values;

- (void) awakeFromNib {
    self.values = [NSMutableArray arrayWithCapacity:NUMBER_OF_BINS];
    for (int i = 0; i < NUMBER_OF_BINS; i ++) {
        [self.values addObject:[NSNumber numberWithInt:0]];
    }
}

- (void) layoutSubviews {
    axesOrigin = CGPointMake(10, self.frame.size.height - 10);
    xAxisWidth = self.frame.size.width-20;
    yAxisWidth = self.frame.size.height-20;
    
    binWidth = xAxisWidth / NUMBER_OF_BINS;
    binHeight = yAxisWidth;
}

- (void) drawRect:(CGRect)rect {

    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // draw x axis
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, axesOrigin.x, axesOrigin.y);
    CGContextAddLineToPoint(c, axesOrigin.x + xAxisWidth, axesOrigin.y);
    CGContextStrokePath(c);
    
    CGContextSetFillColorWithColor(c, [[UIColor greenColor] CGColor]);
    CGContextSetStrokeColorWithColor(c, [[UIColor blackColor] CGColor]);    
    
    // create reusable path
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < self.values.count; i ++) {
        int currentBinHeight = [[self.values objectAtIndex:i] intValue];
        CGRect r = CGRectMake(axesOrigin.x + i * binWidth, axesOrigin.y - currentBinHeight, binWidth, currentBinHeight);
        CGPathAddRect(path, NULL, r);
    }
    
    CGContextBeginPath(c);
    CGContextAddPath(c, path);
    CGContextStrokePath(c);
    CGContextBeginPath(c);
    CGContextAddPath(c, path);
    CGContextFillPath(c);
    CFRelease(path);
}

@end



@interface EvaluatingViewController () {
    SimpleTriangle *originalTriangle;
    SimpleTriangle *testingTriangle;
    std::vector<MyCursorInfo*> originalCursors;
    std::vector<MyCursorInfo*> testingCursors;
    float maxComputedTolerance;
}

- (void) logTouchesStatesFromEvent: (UIEvent*) event;
- (void) createTriangleFromDots: (UIEvent*) event;

- (void) preparePlotterView;

@end

@implementation EvaluatingViewController
@synthesize plotterView;
@synthesize toleranceLabel;
@synthesize closeButton;
@synthesize objectDots = _objectDots;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setToleranceLabel:nil];
    [self setCloseButton:nil];
    [self setPlotterView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated {
    maxComputedTolerance = 0.0f;
    
    MyCursorInfo *p0 = new MyCursorInfo([[self.objectDots objectAtIndex:0] CGPointValue].x, [[self.objectDots objectAtIndex:0] CGPointValue].y);
    MyCursorInfo *p1 = new MyCursorInfo([[self.objectDots objectAtIndex:1] CGPointValue].x, [[self.objectDots objectAtIndex:1] CGPointValue].y); 
    MyCursorInfo *p2 = new MyCursorInfo([[self.objectDots objectAtIndex:2] CGPointValue].x, [[self.objectDots objectAtIndex:2] CGPointValue].y);
    
    originalTriangle =  new SimpleTriangle(p0, p1, p2);
    testingTriangle = NULL;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [toleranceLabel release];
    [closeButton release];
    [self.objectDots release];
    
    if (originalTriangle) {
        for (int i = 0; i < 3; i++) {
            delete originalCursors[i];
        }
        originalCursors.clear();
        delete originalTriangle;
    }
    
    if (testingTriangle) {
        for (int i = 0; i < 3; i++) {
            delete testingCursors[i];
        }
        testingCursors.clear();
        delete testingTriangle;
    }
    [plotterView release];
    [super dealloc];
}


#pragma mark - touch handling

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self logTouchesStatesFromEvent:event];
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self logTouchesStatesFromEvent:event];    
    NSLog(@"\n\nTOUCHES CANCELED!");
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self logTouchesStatesFromEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self logTouchesStatesFromEvent:event];
}

- (void) logTouchesStatesFromEvent:(UIEvent *)event {
//    NSLog(@"\nneventNr: %d", eventCounter++);
//    for (UITouch * touch in event.allTouches) {
//        CGPoint touchPoint = [touch locationInView:self.view];
//        NSLog(@"\n%@", NSStringFromCGPoint(touchPoint));
//    }
    if (event.allTouches.count == 3)
        [self createTriangleFromDots: event];
        
}

#pragma mark - actions

- (IBAction)closeButtonPressed:(id)sender {
    if ([self parentViewController] != nil || ![self respondsToSelector:@selector(presentingViewController)]) {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    else
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - trianlge stuff

- (void) createTriangleFromDots: (UIEvent*) event {
    if (event.allTouches.count != 3) return;
    if (testingTriangle) {
        for (int i = 0; i < 3; i++) {
            delete testingCursors[i];
        }
        testingCursors.clear();
        delete testingTriangle;
    }
    
    for (UITouch * touch in event.allTouches) {
        CGPoint touchPoint = [touch locationInView:self.view];
        MyCursorInfo *p = new MyCursorInfo(touchPoint.x/self.view.frame.size.width, touchPoint.y/self.view.frame.size.height);
        testingCursors.push_back(p);
    }
    testingTriangle = new SimpleTriangle(testingCursors[0], testingCursors[1], testingCursors[2]);
    float aspectRatio = 1.333333f;
    
    float currentDiff = testingTriangle->getMaxSideDifference(originalTriangle, aspectRatio);
    NSLog(@"\ncurrent dif = %f", currentDiff);
    
    // draw current diff into 
    NSInteger roundedDiff = currentDiff*1000;
    if (roundedDiff < 100) {    // values >= 100 are not considered (accuracy is too low)
        // increment the number in appropriate bin and call drawrect
        roundedDiff = (roundedDiff * NUMBER_OF_BINS) / 100;
        NSInteger nr = [[self.plotterView.values objectAtIndex:roundedDiff] intValue];
        nr++;
        [self.plotterView.values replaceObjectAtIndex:roundedDiff withObject:[NSNumber numberWithInt:nr]];
        [self.plotterView setNeedsDisplay];
    }
    
    if (currentDiff > maxComputedTolerance) maxComputedTolerance = currentDiff;
    
    self.toleranceLabel.text = [NSString stringWithFormat:@"Max. tolerance = %.2f", maxComputedTolerance * 100];
}

#pragma mark - plotter View

- (void) preparePlotterView {
//    self.plotterView.values = [[NSMutableArray arrayWithCapacity:10] retain];
}

@end
