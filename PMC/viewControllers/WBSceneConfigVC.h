//
//  WBSceneConfigVC.h
//  PMC
//
//  Created by wangbo on 13-8-14.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSceneConfigVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtSceneName;

@property (nonatomic, strong) IBOutlet UITableView *tbl;

@property (nonatomic, strong) NSString *sceneName;

@property (nonatomic, strong) NSArray *lights;

@end
