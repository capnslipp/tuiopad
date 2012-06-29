//
//  AdvancedSettingsViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSettingsViewController : UIViewController <UINavigationControllerDelegate>
{
    NSArray *sections;
    NSDictionary *rows;
}
@end
