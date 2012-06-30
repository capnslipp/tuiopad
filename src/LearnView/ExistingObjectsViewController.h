//
//  ExistingObjectsViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExistingObjectsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSDictionary *objectsDict;

- (IBAction)clearButtonPressed:(id)sender;

@end
