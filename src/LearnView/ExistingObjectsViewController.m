//
//  ExistingObjectsViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import "ExistingObjectsViewController.h"
#import "FileManagerHelper.h"

@interface ExistingObjectsViewController ()

@end

@implementation ExistingObjectsViewController
@synthesize tableView;
@synthesize objectsDict = _objectsDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.objectsDict = [FileManagerHelper getObjects];
        [self setTitle:@"Existing Objects"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
}
 
- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objectsDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Object ID %@", [[self.objectsDict allKeys] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - actions

- (IBAction)clearButtonPressed:(id)sender {
    UIActionSheet *myMenu = [[UIActionSheet alloc]
                             initWithTitle: @"Clear the complete pattern list?"
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:@"Clear"
                             otherButtonTitles:nil];
    [myMenu showInView:self.view];  
}

#pragma mark action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx
{
    if (buttonIdx!=0) {
        [actionSheet release];
        return;
    }

    [FileManagerHelper deleteAllObjects];
    self.objectsDict = [FileManagerHelper getObjects];
    [self.tableView reloadData];
    [actionSheet release];
}

#pragma mark DEALLOC!!!!!

- (void)dealloc {
    [tableView release];
    [self.objectsDict release];
    [super dealloc];
}
@end
