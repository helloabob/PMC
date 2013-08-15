//
//  WBSceneModelView.m
//  PMC
//
//  Created by wangbo on 13-8-13.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBSceneModelView.h"

#import <QuartzCore/QuartzCore.h>

static NSMutableDictionary *_groupRadioDic = nil;

@interface WBSceneModelView () {
    UILabel *lblTitle;
}

@end

@implementation WBSceneModelView

- (void)dealloc {
    self.groupID = nil;
    self.sceneID = nil;
    [super dealloc];
}

- (void)addToGroup {
    if(!_groupRadioDic){
        _groupRadioDic = [[NSMutableDictionary dictionary] retain];
    }
    
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:self.groupID];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    [_groupRadioDic setObject:_gRadios forKey:self.groupID];
}

- (void)removeFromGroup {
    if (_groupRadioDic) {
        NSMutableArray *_gRadios = [_groupRadioDic objectForKey:self.groupID];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_groupRadioDic removeObjectForKey:self.groupID];
            }
        }
    }
}

- (void)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:self.groupID];
    if (_gRadios.count > 0) {
        for (WBSceneModelView *_radio in _gRadios) {
            if (_radio.isSelected && ![_radio isEqual:self]) {
                _radio.isSelected = NO;
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:241.0/255.0 blue:199.0/255.0 alpha:1.0f];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    _isSelected = isSelected;
}

- (id)initWithFrame:(CGRect)frame withIcon:(NSString *)icon withTitle:(NSString *)title withGroupID:(NSString *)groupID {
    [self initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    _isSelected = NO;
    
    self.groupID = groupID;
    [self addToGroup];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    [btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    int nw = frame.size.height*3/5;
    iv.frame = CGRectMake(40, 10, nw, nw);
    [self addSubview:iv];
    [iv release];
    
    if (title && title.length > 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont boldSystemFontOfSize:18.0f];
        lbl.text = title;
        lbl.backgroundColor = [UIColor clearColor];
        [self addSubview:lbl];
        [lbl release];
        lblTitle = lbl;
    } else {
//        NSLog(@"%@",NSStringFromCGPoint(self.center));
//        NSLog(@"%@",NSStringFromCGPoint(CGPointMake(frame.size.width/2, frame.size.height/2)));
        iv.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    }
    
    
    return self;
}

- (void)setTitle:(NSString *)title {
    lblTitle.text = title;
}

- (void)btnTapped {
    if (_isSelected) {
        return;
    }
    [self uncheckOtherRadios];
    self.isSelected = !_isSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(viewDidTapped:withObject:)]) {
        [_delegate viewDidTapped:lblTitle.text withObject:self];
    }
    if (_isAutoUnselected && _isSelected) {
        [self performSelector:@selector(delayJob) withObject:nil afterDelay:0.1f];
    }
}

- (void)delayJob {
    self.isSelected = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
