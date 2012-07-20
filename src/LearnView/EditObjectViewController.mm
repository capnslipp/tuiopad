//
//  EditObjectViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditObjectViewController.h"
#import "FileManagerHelper.h"
#include "MyCursorInfo.h"
#include "SimpleTriangle.h"

#import "UserDefaultsHelper.h"
#import "EvaluatingViewController.h"


@implementation ObjectDrawingView : UIView

@synthesize objectDots = _objectDots;
- (void)drawRect:(CGRect)rect {    
    MyCursorInfo p0 = MyCursorInfo([[self.objectDots objectAtIndex:0] CGPointValue].x, [[self.objectDots objectAtIndex:0] CGPointValue].y);
    MyCursorInfo p1 = MyCursorInfo([[self.objectDots objectAtIndex:1] CGPointValue].x, [[self.objectDots objectAtIndex:1] CGPointValue].y); 
    MyCursorInfo p2 = MyCursorInfo([[self.objectDots objectAtIndex:2] CGPointValue].x, [[self.objectDots objectAtIndex:2] CGPointValue].y);
    
    SimpleTriangle tri = SimpleTriangle(&p0, &p1, &p2);
    MyCursorInfo *orientationPoint = tri.getOrientationPoint();
    
    [[UIColor grayColor] setFill];
    UIRectFill(rect);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor blueColor] CGColor]);

    CGContextAddArc(ctx, p0.x * self.frame.size.width, p0.y * self.frame.size.width, 10.0f, 0.0f, 2.0f * M_PI, YES);
    CGContextFillPath(ctx);
    CGContextAddArc(ctx, p1.x * self.frame.size.width, p1.y * self.frame.size.width, 10.0f, 0.0f, 2.0f * M_PI, YES);
    CGContextFillPath(ctx);
    CGContextAddArc(ctx, p2.x * self.frame.size.width, p2.y * self.frame.size.width, 10.0f, 0.0f, 2.0f * M_PI, YES);
    CGContextFillPath(ctx);
    
    // empty circle for orientation point

    CGContextSetLineWidth(ctx, 5.0f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor greenColor] CGColor]);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(orientationPoint->x * self.frame.size.width - 10, orientationPoint->y * self.frame.size.width - 10, 20, 20));
    CGContextFillPath(ctx);
}

- (void)layoutSubviews {
    NSLog(@"objectdrawingview frame: %@", NSStringFromCGRect(self.frame) );
}

@end

@interface EditObjectViewController () {
    NSString* currentObjectID;
    NSString* objectValues;
    NSArray* dots;
    float currentTolerance;
}

- (void) toggleControlState:(BOOL)On;

@end

@implementation EditObjectViewController
@synthesize drawingView;
@synthesize defaultSwitch;
@synthesize evaluateButton;
@synthesize slider;
@synthesize toleranceValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithObjectID:(NSString*) ID andValues:(NSString*) values{
    [self initWithNibName:@"EditObjectViewController" bundle:nil];      // ipad version?
    if (self) {
        currentObjectID = ID;
        objectValues = values;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSMutableArray *dotsTemp = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray * singleValues = [[[NSMutableArray alloc] initWithArray:[objectValues componentsSeparatedByString:@" "] copyItems: YES] autorelease];
    for (int i = 0; i < 3; i++) {
        float x = [[singleValues objectAtIndex:i*2] floatValue];
        float y = [[singleValues objectAtIndex:i*2 + 1] floatValue];
        CGPoint point = CGPointMake(x, y);
        NSValue* pointValue = [NSValue valueWithCGPoint:point];
        [dotsTemp addObject:pointValue];
    }
    dots = [[NSArray alloc] initWithArray:dotsTemp];
    self.drawingView.objectDots = dots;
    [self.drawingView setNeedsDisplay];
    
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = 0.1f;
    NSString* tolString = [FileManagerHelper getCustomRecognitionTolerance:currentObjectID];
    
    if ([tolString isEqualToString:@"default"]) {
        currentTolerance = [UserDefaultsHelper defaultTolerance];
        self.defaultSwitch.on = YES;
        [self toggleControlState:YES];
    }
    else {
        currentTolerance = [tolString floatValue];
        self.defaultSwitch.on = NO;
    }
    
    self.slider.value = currentTolerance;
    
    self.toleranceValue.text = [NSString stringWithFormat:@"%.2f %%", self.slider.value * 100];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSString *tolString;
    if (self.defaultSwitch.on) 
        tolString = @"default";
    else 
        tolString = [NSString stringWithFormat:@"%f", currentTolerance];
    [FileManagerHelper setCustomRecognitionTolerance:tolString forObjectWithID:currentObjectID];
}

- (void)viewDidUnload
{
    [self setDrawingView:nil];
    [self setDefaultSwitch:nil];
    [self setEvaluateButton:nil];
    [self setSlider:nil];
    [self setToleranceValue:nil];
    dots = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [drawingView release];
    [defaultSwitch release];
    [evaluateButton release];
    [slider release];
    [toleranceValue release];
    [dots release];
    [super dealloc];
}
- (IBAction)evaluateButtonPressed:(id)sender {
    EvaluatingViewController *evaluatingVC = [[EvaluatingViewController alloc] init];
    evaluatingVC.objectDots = dots;
    [self presentModalViewController:evaluatingVC animated:YES];
}

- (IBAction)switchValueChanged:(id)sender {
    [self toggleControlState:self.defaultSwitch.on];
}

- (IBAction)sliderValueChanged:(id)sender {
    currentTolerance = self.slider.value;
    self.toleranceValue.text = [NSString stringWithFormat:@"%.2f %%", self.slider.value * 100];
}

- (void) toggleControlState:(BOOL)On {
    [self.evaluateButton setHidden:On];
    [self.slider setEnabled:!On];
    if (On) {
        currentTolerance = [UserDefaultsHelper defaultTolerance];
        self.slider.value = currentTolerance;
        self.toleranceValue.text = [NSString stringWithFormat:@"%.2f %%", self.slider.value * 100];
    }
}
@end
