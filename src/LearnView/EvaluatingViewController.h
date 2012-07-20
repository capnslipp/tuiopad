//
//  EvaluatingViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlotterView : UIView

@property (retain, nonatomic) NSMutableArray* values;

@end

@interface EvaluatingViewController : UIViewController

@property (retain, nonatomic)     NSArray* objectDots;

@property (retain, nonatomic) IBOutlet UILabel *toleranceLabel;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet PlotterView *plotterView;


@end
