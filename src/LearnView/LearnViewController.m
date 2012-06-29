//
//  LearnViewController.m
//  TuioPad
//
//  Created by berimac on 14.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LearnViewController.h"


@implementation LearnViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Learning Mode";
    }
    return self;
}


@synthesize theView, theTextField;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rect = CGRectMake(0.0f, 256.0f, 768.0f, 768.0f);
	}     
    
    else 
        rect = CGRectMake(0.0f, 160.0f, 320.0f, 320.0f);
    
    theView = [[DrawView alloc] initWithFrame:rect];
    [self.view addSubview:theView];    
    
    self.theTextField.delegate = self;
    
    saveButtonState = YES;
    
    [self getExistingIDs];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
}


-(IBAction)saveButtonClicked:(id)sender {
    if (!saveButtonState) {
        theView.userInteractionEnabled = YES;
        [self changeButtonState:sender];
        return;
    }
    
    if(theView.dots.count != 3)
    {
        theLabel.text = [NSString stringWithFormat:@"Triangle with %d points?",  [[theView dots] count]];
        return;
    }
    
    if([self IDExists]) 
    {        
        NSLog(@"\nID already exists");
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"ID already exists"
                                   message: @"Choose another ID!"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    // we have 3 points and the id doesn't exist -> store the triangle in the datafile.dat
    // disable user interaction -> the dots are frozen

    theView.userInteractionEnabled = NO;
    [self changeButtonState:sender];

    
    
    NSString *dotsInString = @"";
    
    for (int i = 0; i < [[theView dots] count]; i++) {
//        Dot *aDot = [[theView dots] objectAtIndex:i];
//        CGPoint aDot = [[theView dots] objectAtIndex:i];
        NSValue* value = [theView.dots objectAtIndex:i];
        CGPoint aDot = [value CGPointValue];
        NSString *dotStr = [NSString stringWithFormat:@"%f %f ", aDot.x/theView.frame.size.width, aDot.y/theView.frame.size.height];
//        NSLog(@"%@", dotStr);
        dotsInString = [dotsInString stringByAppendingString:dotStr];
    }
    
    NSString *symbID = [NSString stringWithFormat:@"%@ ", theTextField.text];
    dotsInString = [dotsInString stringByAppendingString:symbID];
    NSLog(@"%@", dotsInString);
    
    NSFileManager *filemgr;
    NSData *databuffer;
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        // Read file contents and display in textBox
        NSData *databuffer;
        databuffer = [filemgr contentsAtPath: dataFile];
        
        NSString *datastring = [[NSString alloc] initWithData: databuffer encoding:NSASCIIStringEncoding];
        
        dotsInString = [datastring stringByAppendingString:dotsInString];
        [datastring release];
    }
    
    databuffer = [dotsInString dataUsingEncoding: NSASCIIStringEncoding];
    
    [filemgr createFileAtPath: dataFile contents: databuffer attributes:nil];
    
    [filemgr release];
    
    theLabel.text = [NSString stringWithFormat:@"Saved triangle"];

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

-(IBAction)clearButtonClicked:(id)sender{
    // file handling
    
    UIActionSheet *myMenu = [[UIActionSheet alloc]
                             initWithTitle: @"Clear the complete pattern list?"
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:@"Clear"
                             otherButtonTitles:nil];
    [myMenu showInView:self.view];    
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

#pragma mark getIDs

-(void)getExistingIDs {
    m_IDsArray = [[NSMutableArray alloc] init];
    
    // file handling
    NSFileManager *filemgr;
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    // Check if the file already exists
    if ([filemgr fileExistsAtPath: dataFile])
    {
        // Read file contents and display in textBox
        NSData *databuffer;
        databuffer = [filemgr contentsAtPath: dataFile];
        
        NSString *datastring = [[NSString alloc] initWithData: databuffer encoding:NSASCIIStringEncoding];
        NSMutableArray * singleValues = [[NSMutableArray alloc] initWithArray:[datastring componentsSeparatedByString:@" "] copyItems: YES];
        NSInteger objCount = [singleValues count]/7;
        m_existingIDsCount = objCount;
        
        //m_Ids = malloc(sizeof(int)*m_existingIDsCount);
        
        for(int i = 0; i < m_existingIDsCount; i++)
        {
            //m_Ids[i] = [[singleValues objectAtIndex:6+(i*7)] intValue];
            [m_IDsArray addObject:[singleValues objectAtIndex:6+(i*7) ]];
        }
        
        [datastring release];
    }
    
    [filemgr release];
    NSString *temp = exIDsLabel.text;
    for (int i = 0; i< m_IDsArray.count; i++) {
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@" %d,", [[m_IDsArray objectAtIndex:i] intValue]]]; 
    }
    exIDsLabel.text = temp;
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
    NSLog(@"textfield text = %d", temp);
    NSLog(@"\nidsarray count is %d", [m_IDsArray count]);
    for(int i = 0; i < [m_IDsArray count]; i ++)
    {
        //if (m_Ids[i] == [theTextField.text intValue]) {
        if([[m_IDsArray objectAtIndex:i] intValue] == temp) {
            return true;
        }
    }
    return false;
}



#pragma mark - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx
{
    if (buttonIdx!=0) {
        [actionSheet release];
        return;
    }
    NSFileManager *filemgr;
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    if ([filemgr fileExistsAtPath: dataFile])
    {
        [filemgr removeItemAtPath:dataFile error:nil];
    }
    [actionSheet release];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
