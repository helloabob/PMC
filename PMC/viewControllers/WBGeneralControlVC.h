//
//  WBGeneralControlVC.h
//  PMC
//
//  Created by wangbo on 13-8-13.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBSceneModelView.h"

@interface WBGeneralControlVC : UIViewController<WBSceneModelViewDelegate>

@property (nonatomic, strong) NSArray *scenes;

@property (nonatomic, strong) NSMutableArray *sceneViews;

//@property (nonatomic, strong) NSString *office_id;

@end
