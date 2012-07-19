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

@interface EvaluatingViewController () {
    SimpleTriangle *originalTriangle;
    SimpleTriangle *testingTriangle;
    std::vector<MyCursorInfo*> originalCursors;
    std::vector<MyCursorInfo*> testingCursors;
    float maxComputedTolerance;
}

- (void) logTouchesStatesFromEvent: (UIEvent*) event;
- (void) createTriangleFromDots: (UIEvent*) event;

@end

@implementation EvaluatingViewController
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
    
    [super dealloc];
}


#pragma mark - touch handling

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self logTouchesStatesFromEvent:event];
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self logTouchesStatesFromEvent:event];    
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
    if (currentDiff > maxComputedTolerance) maxComputedTolerance = currentDiff;
    
    self.toleranceLabel.text = [NSString stringWithFormat:@"Max. tolerance = %.2f", maxComputedTolerance * 100];
}

@end
