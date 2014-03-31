//
//  MonthViewController.m
//  MonthView
//
//  Created by Wayne Cochran on 3/30/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "MonthViewController.h"
#import "MonthView.h"

@interface MonthViewController ()
@property (weak, nonatomic) IBOutlet MonthView *monthView;

@end

@implementation MonthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.monthView.month = 3;
    self.monthView.year = 2014;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
