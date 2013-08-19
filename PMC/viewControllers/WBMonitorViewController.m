//
//  WBMonitorViewController.m
//  PMC
//
//  Created by wangbo on 13-8-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBMonitorViewController.h"

#import "UITableViewCell+ExtraProperty.h"

#import "MBProgressHUD.h"

#import "AFNetworking.h"

const float selectedRowHeight   = 150.0;
const float unselectedRowHeight = 1.0;

@interface WBMonitorViewController ()

@end

@implementation WBMonitorViewController

- (void)dealloc {
    self.powerList = nil;
    self.tblView = nil;
    self.lights = nil;
    self.rowHeightArray = nil;
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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = app_default_background_color;
    self.title = @"Monitor";
    
    self.lights = [[PMCTool sharedInstance] getLightsInOffice];
    self.rowHeightArray = [NSMutableArray array];
    for (int i = 0; i < self.lights.count; i ++) {
        [_rowHeightArray addObject:[NSNumber numberWithFloat:44.0f]];
        [_rowHeightArray addObject:[NSNumber numberWithFloat:unselectedRowHeight]];
    }
//    self.lights = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    
    UITableView *tbl = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbl.backgroundColor = [UIColor clearColor];
    tbl.backgroundView = nil;
    tbl.delegate = self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];
    [tbl release];
    self.tblView = tbl;

    self.powerList = [NSMutableDictionary dictionary];
    self.runningList = [NSMutableDictionary dictionary];
    self.dimmingList = [NSMutableDictionary dictionary];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.labelText = @"Loading";
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    for (NSArray *row in _lights) {
        NSURL *url = [NSURL URLWithString:getLightsPowerForOffice([row objectAtIndex:0], [row objectAtIndex:1])];
        //    NSURLRequest *request_ = [NSURLRequest requestWithURL:url];
        NSURLRequest *request_ = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f];
        AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request_] autorelease];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
            [_powerList setObject:str forKey:[row objectAtIndex:0]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_powerList setObject:@"Not Found" forKey:[row objectAtIndex:0]];
        }];
        [operation start];
        [NSThread detachNewThreadSelector:@selector(running_thread_job:) toTarget:self withObject:[row objectAtIndex:0]];
    }
    
    [hud hide:YES afterDelay:6.0f];
    [tbl performSelector:@selector(reloadData) withObject:nil afterDelay:6.0f];
}

- (void)running_thread_job:(NSString *)key {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *dict = [[PMCTool sharedInstance] getLightStatusWithIP:key];
    if (dict) {
        NSString *str = [NSString stringWithFormat:@"%dH %dM", [[dict objectForKey:@"h"] intValue], [[dict objectForKey:@"m"] intValue]];
        [self.runningList setObject:str forKey:key];
        double dimming = [[dict objectForKey:@"b"] doubleValue];
        NSString *strDimming = [NSString stringWithFormat:@"%.f%%",dimming/maxDimmingLevel];
        [self.dimmingList setObject:strDimming forKey:key];
    } else {
        [self.runningList setObject:@"Not Found" forKey:key];
        [self.dimmingList setObject:@"Not Found" forKey:key];
    }
    [pool drain];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.rowHeightArray objectAtIndex:indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.lights.count*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % 2 == 0) {
        
        static NSString *CellIdentifier = @"MasterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Light%d",indexPath.row/2+1];
//        cell.ip = [[self.lights objectAtIndex:indexPath.row/2] objectAtIndex:0];
        
        return cell;
    } else {
        
        static NSString *CellIdentifier = @"DetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Power:";
            lbl.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:lbl];
            [lbl release];
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width/2, 20, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"0.00(w)";
            lbl.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbl];
            [lbl release];
            cell.lblPower = lbl;
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Dimming Level:";
            lbl.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:lbl];
            [lbl release];
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width/2, 60, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"100%";
            lbl.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbl];
            [lbl release];
            cell.lblDimming = lbl;
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Running Time:";
            lbl.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:lbl];
            [lbl release];
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width/2, 100, cell.bounds.size.width/2-15, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"0H 0M";
            lbl.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbl];
            [lbl release];
            cell.lblRunning = lbl;
            
        }
        
        if ([_powerList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]]) {
            cell.lblPower.text = [_powerList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]];
        }
        if ([_runningList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]]) {
            cell.lblRunning.text = [_runningList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]];
        }
        if ([_dimmingList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]]) {
            cell.lblDimming.text = [_dimmingList objectForKey:[[_lights objectAtIndex:indexPath.row/2] objectAtIndex:0]];
        }
        
//        ((UILabel *)([cell.contentView.subviews lastObject])).text = [NSString stringWithFormat:@"Power:%f(w)",1.0f];
        
        
        
        
        return cell;
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //    cell.backgroundColor = [UIColor whiteColor];
//    UIImageView *iv = ((UIImageView *)[cell.contentView.subviews lastObject]);
//    UILabel *lbl = ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]);
//    iv.frame = CGRectMake(10, 10, 25, 25);
//    lbl.frame = CGRectMake(50, 7, 200, 30);
//    if (indexPath.row == 0) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:@"configuration_icon"];
//        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = @"Configuration";
//    } else if ((indexPath.row == 1 && isExpand == NO) || (indexPath.row == self.scenes.count+1 && isExpand == YES)) {
//        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:@"monitor_icon"];
//        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = @"Monitor";
//    } else {
//        iv.frame = CGRectMake(40, 7, 25, 25);
//        lbl.frame = CGRectMake(80, 4, 200, 30);
//        //        cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0f];
//        NSString *image_url = [NSString stringWithFormat:@"icon%d",indexPath.row];
//        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:image_url];
//        NSString *scene_name = [[self.scenes objectAtIndex:indexPath.row - 1] objectAtIndex:0];
//        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = scene_name;
//    }
    
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
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2==0) {
        if ([[_rowHeightArray objectAtIndex:indexPath.row+1] floatValue] == selectedRowHeight
            ) {
            [self.rowHeightArray setObject:[NSNumber numberWithFloat:unselectedRowHeight] atIndexedSubscript:indexPath.row+1];
        } else {
            [self.rowHeightArray setObject:[NSNumber numberWithFloat:selectedRowHeight] atIndexedSubscript:indexPath.row+1];
        }
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
//        WBMonitorViewController *vc = [[[WBMonitorViewController alloc] init] autorelease];
//        //        vc.sceneId = [[[self.scenes objectAtIndex:indexPath.row-1] objectAtIndex:1] intValue];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        WBSceneConfigVC *vc = [[[WBSceneConfigVC alloc] init] autorelease];
//        vc.sceneId = [[[self.scenes objectAtIndex:indexPath.row-1] objectAtIndex:1] intValue];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5f];
}
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
