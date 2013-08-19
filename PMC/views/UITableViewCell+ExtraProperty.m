//
//  UITableViewCell+ExtraProperty.m
//  PMC
//
//  Created by wangbo on 13-8-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "UITableViewCell+ExtraProperty.h"

#import <objc/runtime.h>

@implementation UITableViewCell (ExtraProperty)

@dynamic ip;

- (void)setIp:(NSString *)ip {
    objc_setAssociatedObject(self, "ip_key", ip, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ip {
    return objc_getAssociatedObject(self, "ip_key");
}

- (void)setLblPower:(UILabel *)lblPower{
    objc_setAssociatedObject(self, "power_key", lblPower, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblPower {
    return objc_getAssociatedObject(self, "power_key");
}

- (void)setLblDimming:(UILabel *)lblDimming {
    objc_setAssociatedObject(self, "dim_key", lblDimming, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblDimming {
    return objc_getAssociatedObject(self, "dim_key");
}

- (void)setLblRunning:(UILabel *)lblRunning {
    objc_setAssociatedObject(self, "run_key", lblRunning, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblRunning {
    return objc_getAssociatedObject(self, "run_key");
}

@end
