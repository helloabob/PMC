//
//  WBMonitorViewController.m
//  PMC
//
//  Created by wangbo on 13-8-15.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBMonitorViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface WBMonitorViewController ()

@end

@implementation WBMonitorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 320-40, self.view.bounds.size.height)];
    vv.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    vv.layer.shadowColor = [UIColor blackColor].CGColor;
    vv.layer.shadowOffset = CGSizeMake(3, 0);
    vv.layer.shadowOpacity = 1.0;
    
    [self.view addSubview:vv];
    
    UIView *vvv2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
    vvv2.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    vvv2.layer.borderColor = [UIColor colorWithRed:156.0/255.0 green:116.0/255.0 blue:81.0/255.0 alpha:1.0].CGColor;
    vvv2.layer.borderWidth = 1;
    vvv2.layer.cornerRadius = 5;
    [self.view addSubview:vvv2];
    
    for (int i = 1; i < 4; i ++) {
        UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(0, i*62, 44, 60)];
        vvv.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:213.0/255.0 blue:200.0/255.0 alpha:1.0];
        vvv.layer.borderColor = [UIColor colorWithRed:156.0/255.0 green:116.0/255.0 blue:81.0/255.0 alpha:1.0].CGColor;
        vvv.layer.borderWidth = 1;
        vvv.layer.cornerRadius = 5;
        [self.view addSubview:vvv];
    }
    [self.view bringSubviewToFront:vv];
    [self.view bringSubviewToFront:vvv2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
