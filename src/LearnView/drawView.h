//
//  drawView.h
//  TuioPad
//
//  Created by Oleg Langer on 03.01.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawView : UIView

@property (nonatomic, retain) NSMutableArray *dots;

- (void) addPointsFromTouches:(NSSet *)touches withEvent:(UIEvent *)event;

@end
