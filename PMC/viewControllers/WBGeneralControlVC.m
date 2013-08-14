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

@interface WBGeneralControlVC ()

@end

@implementation WBGeneralControlVC

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

    for (int i =0; i < self.scenes.count; i ++) {
        WBSceneModelView *smv = [[WBSceneModelView alloc] initWithFrame:CGRectMake(20, 20+(i*70), 280, 50) withIcon:[NSString stringWithFormat:@"icon%d",i+1] withTitle:[[self.scenes objectAtIndex:i] objectAtIndex:0] withGroupID:@"sceneGroup"];
        smv.delegate = self;
        [self.view addSubview:smv];
        [smv release];
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
    sbtnn.tag = 1001;
    [self.view addSubview:sbtnn];
    [sbtnn release];
    
    WBSceneModelView *sbtnf = [[WBSceneModelView alloc] initWithFrame:CGRectMake(180, 350, 120, 40) withIcon:@"turnoff" withTitle:nil withGroupID:@"switchGroup"];
    sbtnf.delegate = self;
    sbtnf.tag = 1000;
    [self.view addSubview:sbtnf];
    [sbtnf release];
    
}

- (void)sliderChanged:(UISlider *)slider {
    [[PMCTool sharedInstance] changeAllLightDimming:slider.value];
    
}

- (void)viewDidTapped:(NSString *)title withObject:(WBSceneModelView *)sceneModelView {
    if ([sceneModelView.groupID isEqualToString:@"switchGroup"]) {
        if (sceneModelView.tag == 1000) {
//            NSLog(@"turn off");
            [[PMCTool sharedInstance] switchAllLight:NO];
        } else {
//            NSLog(@"turn on");
            [[PMCTool sharedInstance] switchAllLight:YES];
        }
    } else {
//        NSLog(@"change scene:%@",title);
        [[PMCTool sharedInstance] changeToScene:title];
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
