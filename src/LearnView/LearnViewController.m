//
//  LearnViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 14.12.11.
//  Copyright 2011 Oleg Langer. All rights reserved.
//

#import "LearnViewController.h"
#import "FileManagerHelper.h"


@implementation LearnViewController
@synthesize theTextField;
@synthesize IDsArray = _IDsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Learning Mode";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rect = CGRectMake(0.0f, 256.0f, 768.0f, 768.0f);
	}     
    
    else 
        rect = CGRectMake(0.0f, 116.0f, 320.0f, 320.0f);
    
    theView = [[DrawView alloc] initWithFrame:rect];
    [self.view addSubview:theView];    
    [theView release];
    
    self.theTextField.delegate = self;
    
    saveButtonState = YES;
    
    self.IDsArray = [FileManagerHelper getExistingIDs];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
}

- (void) viewDidAppear:(BOOL)animated {
    [theTextField becomeFirstResponder];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


-(IBAction)saveButtonClicked:(id)sender {
    if (theTextField.text.length==0) {
        theLabel.text = @"No ID specified";
        return;
    }
    
    else if(theView.dots.count != 3)
    {
        theLabel.text = [NSString stringWithFormat:@"Triangle with %d points?",  [[theView dots] count]];
        return;
    }
    
    else if([self IDExists]) 
    {        
        NSLog(@"\nID already exists");
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"ID already exists!"
                                   message: @"Overwrite?"
                                  delegate: self
                         cancelButtonTitle: @"Cancel"
                         otherButtonTitles: @"Yes", nil];
        [alert show];
        [alert release];
        return;
    }
    
    else [self performSaving];
}

- (void) performSaving {
    NSString *dotsInString = @"";
    
    for (int i = 0; i < [[theView dots] count]; i++) {
        NSValue* value = [theView.dots objectAtIndex:i];
        CGPoint aDot = [value CGPointValue];
        NSString *dotStr = [NSString stringWithFormat:@"%f %f ", aDot.x/theView.frame.size.width, aDot.y/theView.frame.size.height];
        dotsInString = [dotsInString stringByAppendingString:dotStr];
    }
    
    NSString *symbID = [NSString stringWithFormat:@"%@ ", theTextField.text];
    
    [FileManagerHelper saveObject:dotsInString withID:symbID];
    self.IDsArray = [FileManagerHelper getExistingIDs];
    theLabel.text = [NSString stringWithFormat:@"Saved triangle"];
}

- (void) performOverwrite {
    NSString *dotsInString = @"";
    
    for (int i = 0; i < [[theView dots] count]; i++) {
        NSValue* value = [theView.dots objectAtIndex:i];
        CGPoint aDot = [value CGPointValue];
        NSString *dotStr = [NSString stringWithFormat:@"%f %f ", aDot.x/theView.frame.size.width, aDot.y/theView.frame.size.height];
        dotsInString = [dotsInString stringByAppendingString:dotStr];
    }
    
    NSString *symbID = [NSString stringWithFormat:@"%@ ", theTextField.text];
    
    [FileManagerHelper overwriteObjectWithID:symbID withObject:dotsInString];
    self.IDsArray = [FileManagerHelper getExistingIDs];
    theLabel.text = [NSString stringWithFormat:@"Saved triangle (overwritten)"];
}

-(IBAction)closeButtonClicked:(id)sender {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[self viewWillDisappear:YES];
	[self.view removeFromSuperview];
	[self viewDidDisappear:YES];
	[UIView commitAnimations];
}


- (void) changeButtonState:(id)sender {
    if (saveButtonState) 
        [(UIButton*)sender setTitle:@"New" forState:UIControlStateNormal];
    else 
        [(UIButton*)sender setTitle:@"Save" forState:UIControlStateNormal];
    saveButtonState = !saveButtonState;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{ 
    [textField resignFirstResponder]; 
    return YES;
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (range.length == 1){
        return YES;
    }else{
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
    }
}

-(BOOL)IDExists
{
    int temp = [theTextField.text intValue];
    for(int i = 0; i < [self.IDsArray count]; i ++)
    {
        if([[self.IDsArray objectAtIndex:i] intValue] == temp) {
            return true;
        }
    }
    return false;
}



#pragma mark - alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    else if (buttonIndex == 1)
    {
        [self performOverwrite];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [self.IDsArray release];
    [super dealloc];
}


@end
