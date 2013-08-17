//
//  WBSceneConfigVC.m
//  PMC
//
//  Created by wangbo on 13-8-14.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBSceneConfigVC.h"

#import "UISlider+ExtraProperty.h"

@interface WBSceneConfigVC ()

@end

@implementation WBSceneConfigVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    self.lights = nil;
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
    
    self.title = @"CONFIGURATION";
    self.view.backgroundColor = app_default_background_color;
    self.tbl.backgroundColor = [UIColor clearColor];
    self.tbl.backgroundView = nil;
    
    
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 setImage:[UIImage imageNamed:@"scene_save"] forState:UIControlStateNormal];
//    btn3.titleLabel.text = @"Save";
//    [btn3 setTitle:@"Save" forState:UIControlStateNormal];
//    btn3.frame = CGRectMake(0, 0, 30, 30);
////    btn3.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
//    [self.view addSubview:btn3];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setImage:[UIImage imageNamed:@"scene_save"] forState:UIControlStateNormal];
//    [btn1 setTitle:@"Save" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
//    btn1.frame = CGRectMake(0, 0, 40, 40);
//    btn1.titleEdgeInsets = UIEdgeInsetsMake(35, -60, 0, 0);
//    btn1.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
//    [btn1 addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    [item1 setWidth:155];
//    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setImage:[UIImage imageNamed:@"scene_cancel"] forState:UIControlStateNormal];
//    [btn2 setTitle:@"Cancel" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
//    btn2.frame = CGRectMake(0, 0, 40, 40);
//    btn2.titleEdgeInsets = UIEdgeInsetsMake(35, -60, 0, 0);
//    btn2.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
//    [btn2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
//    [item2 setWidth:155];
//    
//    NSArray *array = [NSArray arrayWithObjects:item1, item2, nil];
//    
//    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
//    tool.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
//    tool.tintColor = [UIColor blackColor];
//    [self.view addSubview:tool];
//    [tool release];
//    [tool setItems:array];
//    
//    [item1 release];
//    [item2 release];
    
    self.lights = [[PMCTool sharedInstance] getLightsForScene:_sceneId];
    self.tbl.delegate = self;
    self.tbl.dataSource = self;
    self.tbl.scrollEnabled = NO;
    
    self.txtSceneName.text = [[_lights objectAtIndex:0] objectAtIndex:3];
    self.txtSceneName.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)txtValueChanged:(NSNotification *)notif {
    if (self.txtSceneName.text.length > 13) {
        self.txtSceneName.text = [self.txtSceneName.text substringToIndex:13];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)save {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.lights.count; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[_lights objectAtIndex:i] objectAtIndex:2] forKey:@"scene_resource_id"];
        UITableViewCell *cell = [_tbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSNumber *dimming = [NSNumber numberWithFloat:((UISlider *)[cell.contentView.subviews lastObject]).value];
        [dict setObject:dimming forKey:@"scene_bright"];
        [array addObject:dict];
    }
    if (array.count > 0) {
        [[PMCTool sharedInstance] updateLightsForScene:_sceneId withData:array withSceneName:self.txtSceneName.text];
//        [[PMCTool sharedInstance] updateLightsForScene:self.sceneName withData:array];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _lights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.backgroundColor = [UIColor clearColor];
//        cell.textLabel.frame = CGRectMake(40, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 60, 30)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont boldSystemFontOfSize:18.0f];
//        lbl.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lbl];
        [lbl release];
        
        UISlider *iv = [[UISlider alloc] init];
        iv.minimumValue = 1;
        iv.maximumValue = maxDimmingLevel;
        iv.frame = CGRectMake(80, 10, 200, 25);
        [iv addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:iv];
        [iv release];
        
    }
    ((UISlider *)[cell.contentView.subviews lastObject]).value = [[[_lights objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
    ((UISlider *)[cell.contentView.subviews lastObject]).ip = [[_lights objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *str = [NSString stringWithFormat:@"Light%@",[[_lights objectAtIndex:indexPath.row] objectAtIndex:2]];
    ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = str;
    
    //    if (indexPath.section == 0) {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //        if (indexPath.row == 0) {
    //            cell.textLabel.text = @"Select All Words";
    //        } else if (indexPath.row == 1){
    //            cell.textLabel.text = @"Quit";
    //        } else {
    //            cell.textLabel.text = @"Unselect All Words";
    //        }
    //    } else {
    //        NSString *str = [[WBCommon getQuestionArray] objectAtIndex:indexPath.row];
    //        NSRange range = [str rangeOfString:@":"];
    //        cell.textLabel.text = [str substringToIndex:range.location];
    //        if ([[str substringFromIndex:range.location+1] isEqualToString:@"1"]) {
    //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //        } else {
    //            cell.accessoryType = UITableViewCellAccessoryNone;
    //        }
    //    }
    // Configure the cell...
    
    return cell;
}

- (void)sliderValueChanged:(UISlider *)slider {
    [[PMCTool sharedInstance] changeLightDimming:slider.value ForIP:slider.ip];
}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        [tableView beginUpdates];
//        NSMutableArray *preAdd = [NSMutableArray array];
//        for (int i = 0; i < _scenes.count; i ++) {
//            NSIndexPath *ip = [NSIndexPath indexPathForRow:i+1 inSection:0];
//            [preAdd addObject:ip];
//        }
//        if (!isExpand) {
//            [tableView insertRowsAtIndexPaths:preAdd withRowAnimation:UITableViewRowAnimationAutomatic];
//        } else {
//            [tableView deleteRowsAtIndexPaths:preAdd withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        isExpand = !isExpand;
//        [tableView endUpdates];
//    } else if ((indexPath.row == 1 && isExpand == NO) || (indexPath.row == self.scenes.count+1 && isExpand == YES)) {
//        //click monitor cell.
//    } else {
//        WBSceneConfigVC *vc = [[[WBSceneConfigVC alloc] init] autorelease];
//        vc.sceneName = [[self.scenes objectAtIndex:indexPath.row-1] objectAtIndex:0];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
