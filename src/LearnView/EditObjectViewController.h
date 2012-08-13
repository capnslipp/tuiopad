//
//  EditObjectViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectDrawingView : UIView 
@property (nonatomic, assign) NSArray *objectDots;
@end


@interface EditObjectViewController : UIViewController
@property (retain, nonatomic) IBOutlet ObjectDrawingView *drawingView;
@property (retain, nonatomic) IBOutlet UISwitch *defaultSwitch;
@property (retain, nonatomic) IBOutlet UIButton *evaluateButton;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UILabel *toleranceValue;

- (IBAction)evaluateButtonPressed:(id)sender;
- (IBAction)switchValueChanged:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

- (id) initWithObjectID:(NSString*) ID andValues:(NSString*) values;

@end
