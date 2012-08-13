//
//  LearnViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 14.12.11.
//  Copyright 2011 Oleg Langer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface LearnViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	IBOutlet UIButton *saveButton;
    IBOutlet UIButton *closeButton;
    IBOutlet UILabel *theLabel;
    IBOutlet UILabel *exIDsLabel;
    IBOutlet UITextField *theTextField;
    DrawView *theView;
}

@property (readonly, nonatomic) IBOutlet UITextField *theTextField;
@property (retain, nonatomic) NSMutableArray *IDsArray;

-(IBAction) saveButtonClicked:(id)sender;
-(IBAction) closeButtonClicked:(id)sender;

- (void) performSaving;
- (void) performOverwrite;

-(BOOL)IDExists;

@end


