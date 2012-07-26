//
//  ExistingObjectsViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import "ExistingObjectsViewController.h"
#import "FileManagerHelper.h"
#import "EditObjectViewController.h"

@interface ExistingObjectsViewController ()

- (IBAction)rightButtonPressed:(id)sender;

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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButtonPressed:)];
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
    NSString *currentObjID = [[self.objectsDict allKeys] objectAtIndex:indexPath.row];
    EditObjectViewController *editObjVC = [[EditObjectViewController alloc] initWithObjectID:currentObjID andValues:[self.objectsDict objectForKey:currentObjID]];
    [self.navigationController pushViewController:editObjVC animated:YES];
    [editObjVC release];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // delete Object
        [FileManagerHelper deleteObjectWithId:[[self.objectsDict allKeys] objectAtIndex:indexPath.row]];
        self.objectsDict = [FileManagerHelper getObjects];
        [self.tableView reloadData];
    } 
}

#pragma mark - actions

- (IBAction)rightButtonPressed:(id)sender {
    if (self.tableView.editing == YES) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        [self.tableView setEditing:NO animated:YES];
    } else {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rightButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark DEALLOC!!!!!

- (void)dealloc {
    [tableView release];
    [self.objectsDict release];
    [super dealloc];
}
@end
