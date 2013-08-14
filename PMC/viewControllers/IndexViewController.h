//
//  IndexViewController.h
//  LampIphoneApp
//
//  Created by wangbo on 13-5-31.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface IndexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblSystem;

@property (strong, nonatomic) NSArray *arrayMenu;

@property (strong, nonatomic) NSString *scanResult;

@property (strong, nonatomic) IBOutlet UITextField *txtRoom;

- (IBAction)btnEnterTapped:(id)sender;


@end
