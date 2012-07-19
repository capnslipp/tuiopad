//
//  EvaluatingViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluatingViewController : UIViewController

@property (retain, nonatomic)     NSArray* objectDots;

@property (retain, nonatomic) IBOutlet UILabel *toleranceLabel;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeButtonPressed:(id)sender;

@end