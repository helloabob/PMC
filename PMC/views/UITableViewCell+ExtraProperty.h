//
//  UITableViewCell+ExtraProperty.h
//  PMC
//
//  Created by wangbo on 13-8-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ExtraProperty)

@property (nonatomic, strong) NSString *ip;

@property (nonatomic, strong) UILabel *lblPower;
@property (nonatomic, strong) UILabel *lblDimming;
@property (nonatomic, strong) UILabel *lblRunning;

@end
