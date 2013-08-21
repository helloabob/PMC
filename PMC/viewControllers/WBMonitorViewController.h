//
//  WBMonitorViewController.h
//  PMC
//
//  Created by wangbo on 13-8-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface WBMonitorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    MBProgressHUD *hud;
    BOOL canDo;
}

@property (nonatomic, strong) NSArray *lights;

@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@property (nonatomic, strong) UITableView *tblView;

@property (atomic, strong) NSMutableDictionary *powerList;

@property (atomic, strong) NSMutableDictionary *runningList;

@property (atomic, strong) NSMutableDictionary *dimmingList;

@end
