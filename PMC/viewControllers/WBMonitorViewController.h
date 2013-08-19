//
//  WBMonitorViewController.h
//  PMC
//
//  Created by wangbo on 13-8-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBMonitorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *lights;

@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@property (nonatomic, strong) UITableView *tblView;

@property (nonatomic, strong) NSMutableDictionary *powerList;

@property (nonatomic, strong) NSMutableDictionary *runningList;

@property (nonatomic, strong) NSMutableDictionary *dimmingList;

@end
