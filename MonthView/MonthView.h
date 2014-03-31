//
//  MonthView.h
//  MonthView
//
//  Created by Wayne Cochran on 3/30/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthView : UIView

@property (assign, nonatomic) NSInteger month; // jan = 1, .., dec = 12
@property (assign, nonatomic) NSInteger year;  // >= 1800 (Gregorian)

@end
