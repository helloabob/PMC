//
//  WBSceneModelView.h
//  PMC
//
//  Created by wangbo on 13-8-13.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBSceneModelViewDelegate;

@interface WBSceneModelView : UIView {
    
}

@property (nonatomic, assign) id<WBSceneModelViewDelegate>delegate;

@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *sceneID;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithFrame:(CGRect)frame withIcon:(NSString *)icon withTitle:(NSString *)title withGroupID:(NSString *)groupID;

@end

@protocol WBSceneModelViewDelegate <NSObject>

@required
- (void)viewDidTapped:(NSString *)title withObject:(WBSceneModelView *)sceneModelView;

@end
