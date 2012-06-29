//
//  LearnViewController.h
//  TuioPad
//
//  Created by berimac on 14.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface LearnViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate> {
	IBOutlet UIButton *saveButton;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *clearButton;
    IBOutlet UILabel *theLabel;
    IBOutlet UILabel *exIDsLabel;
    IBOutlet UITextField *theTextField;
    DrawView *theView;
    
    int* m_Ids;
    
    NSMutableArray *m_IDsArray;
    int m_existingIDsCount;
    BOOL saveButtonState;
}

@property (readonly, nonatomic) IBOutlet DrawView *theView;
@property (readonly, nonatomic) IBOutlet UITextField *theTextField;

-(IBAction) saveButtonClicked:(id)sender;
-(IBAction) closeButtonClicked:(id)sender;
-(IBAction) clearButtonClicked:(id)sender;

- (void) changeButtonState: (id) sender;   

-(void)getExistingIDs;
-(BOOL)IDExists;

@end



