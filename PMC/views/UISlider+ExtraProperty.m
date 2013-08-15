//
//  UISlider+ExtraProperty.m
//  PMC
//
//  Created by wangbo on 13-8-15.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "UISlider+ExtraProperty.h"

#import<objc/runtime.h>

@implementation UISlider (ExtraProperty)

@dynamic ip;

- (void)setIp:(NSString *)ip {
    objc_setAssociatedObject(self, "ip_key", ip, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ip {
    return objc_getAssociatedObject(self, "ip_key");
}

@end
