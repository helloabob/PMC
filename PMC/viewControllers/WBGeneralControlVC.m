//
//  WBGeneralControlVC.m
//  PMC
//
//  Created by wangbo on 13-8-13.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBGeneralControlVC.h"

#import "WBSceneModelView.h"

#import "WBSettingVC.h"

@interface WBGeneralControlVC () {
    NSInteger lastSceneTag;
}

@end

@implementation WBGeneralControlVC

- (void)dealloc {
    self.scenes = nil;
    self.sceneViews = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = app_default_background_color;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleDone target:self action:@selector(gotoSetting)];
    self.title = @"PHILIPS";
    
    self.scenes = [[PMCTool sharedInstance] getScenes];

    self.sceneViews = [NSMutableArray array];
    
    for (int i =0; i < self.scenes.count; i ++) {
        WBSceneModelView *smv = [[WBSceneModelView alloc] initWithFrame:CGRectMake(20, 20+(i*70), 280, 50) withIcon:[NSString stringWithFormat:@"icon%d",i+1] withTitle:[[self.scenes objectAtIndex:i] objectAtIndex:0] withGroupID:@"sceneGroup"];
        smv.delegate = self;
        smv.tag = [[[_scenes objectAtIndex:i] objectAtIndex:1] intValue];
        [self.view addSubview:smv];
        [smv release];
        [_sceneViews addObject:smv];
    }
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 300, 280, 35)];
    slider.minimumValue = 1;
    slider.maximumValue = maxDimmingLevel;
    slider.value = maxDimmingLevel / 2;
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider release];
    
    WBSceneModelView *sbtnn = [[WBSceneModelView alloc] initWithFrame:CGRectMake(20, 350, 120, 40) withIcon:@"turnon" withTitle:nil withGroupID:@"switchGroup"];
    sbtnn.delegate = self;
    sbtnn.isAutoUnselected = YES;
    sbtnn.tag = 1001;
    [self.view addSubview:sbtnn];
    [sbtnn release];
    
    WBSceneModelView *sbtnf = [[WBSceneModelView alloc] initWithFrame:CGRectMake(180, 350, 120, 40) withIcon:@"turnoff" withTitle:nil withGroupID:@"sceneGroup"];
    sbtnf.delegate = self;
    sbtnf.tag = 1000;
    [self.view addSubview:sbtnf];
    [sbtnf release];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scenes = [[PMCTool sharedInstance] getScenes];
    for (int i = 0; i < _sceneViews.count; i++) {
        WBSceneModelView *smv = [_sceneViews objectAtIndex:i];
        [smv setTitle:[[_scenes objectAtIndex:i] objectAtIndex:0]];
    }
}

- (void)sliderChanged:(UISlider *)slider {
    [[PMCTool sharedInstance] changeAllLightDimming:slider.value];
}

- (void)viewDidTapped:(NSString *)title withObject:(WBSceneModelView *)sceneModelView {
    if ([sceneModelView.groupID isEqualToString:@"switchGroup"]) {
//        if (sceneModelView.tag == 1000) {
//            NSLog(@"turn off");
//            [[PMCTool sharedInstance] switchAllLight:NO];
//        } else {
//            NSLog(@"turn on");
            [[PMCTool sharedInstance] switchAllLight:YES];
        WBSceneModelView *turnOff = (WBSceneModelView *)[self.view viewWithTag:1000];
        if (turnOff.isSelected == YES) {
            turnOff.isSelected = NO;
        }
        for (UIView *child in self.view.subviews) {
            if (child.tag == lastSceneTag && [child isMemberOfClass:[WBSceneModelView class]]) {
                WBSceneModelView *wmv = (WBSceneModelView *)child;
                if (wmv.isSelected == NO) {
                    wmv.isSelected = YES;
                }
            }
        }
//        }
    } else {
        if (sceneModelView.tag == 1000) {
            [[PMCTool sharedInstance] switchAllLight:NO];
        } else {
            [[PMCTool sharedInstance] changeToScene:sceneModelView.tag];
            [[PMCTool sharedInstance] switchAllLight:YES];
            lastSceneTag = sceneModelView.tag;
        }
    }
}

- (void)gotoSetting {
    WBSettingVC *setting = [[[WBSettingVC alloc] init] autorelease];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
