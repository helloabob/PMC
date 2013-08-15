//
//  WBSettingVC.m
//  PMC
//
//  Created by wangbo on 13-8-13.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBSettingVC.h"

#import "WBSceneConfigVC.h"

#import "WBMonitorViewController.h"

@interface WBSettingVC () {
    BOOL isExpand;
    UITableView *_tblView;
}

@end

@implementation WBSettingVC

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
    self.title = @"SETTINGS";
    
    
    UITableView *tbl = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbl.backgroundColor = [UIColor clearColor];
    tbl.backgroundView = nil;
    tbl.delegate = self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];
    [tbl release];
    _tblView = tbl;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isExpand = YES;
    self.scenes = [[PMCTool sharedInstance] getScenes];
    [_tblView reloadData];
    
//    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(tt) userInfo:nil repeats:NO];
}

- (void)tt {
    NSLog(@"%f",[_tblView rowHeight]);
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
    if (isExpand == YES && indexPath.row > 0 && indexPath.row <= _scenes.count) {
        return 38.0;
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (isExpand) {
        return self.scenes.count+2;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.frame = CGRectMake(40, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, 200, 30)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont boldSystemFontOfSize:18.0f];
        [cell.contentView addSubview:lbl];
        [lbl release];
        
        UIImageView *iv = [[UIImageView alloc] init];
        iv.frame = CGRectMake(10, 10, 25, 25);
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:iv];
        [iv release];
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = ((UIImageView *)[cell.contentView.subviews lastObject]);
    UILabel *lbl = ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]);
    iv.frame = CGRectMake(10, 10, 25, 25);
    lbl.frame = CGRectMake(50, 7, 200, 30);
    if (indexPath.row == 0) {
        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:@"configuration_icon"];
        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = @"Configuration";
    } else if ((indexPath.row == 1 && isExpand == NO) || (indexPath.row == self.scenes.count+1 && isExpand == YES)) {
        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:@"monitor_icon"];
        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = @"Monitor";
    } else {
        iv.frame = CGRectMake(40, 7, 25, 25);
        lbl.frame = CGRectMake(80, 4, 200, 30);
        cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0f];
        NSString *image_url = [NSString stringWithFormat:@"icon%d",indexPath.row];
        ((UIImageView *)[cell.contentView.subviews lastObject]).image = [UIImage imageNamed:image_url];
        NSString *scene_name = [[self.scenes objectAtIndex:indexPath.row - 1] objectAtIndex:0];
        ((UILabel *)[cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-2]).text = scene_name;
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [tableView beginUpdates];
        NSMutableArray *preAdd = [NSMutableArray array];
        for (int i = 0; i < _scenes.count; i ++) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i+1 inSection:0];
            [preAdd addObject:ip];
        }
        if (!isExpand) {
            [tableView insertRowsAtIndexPaths:preAdd withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [tableView deleteRowsAtIndexPaths:preAdd withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        isExpand = !isExpand;
        [tableView endUpdates];
    } else if ((indexPath.row == 1 && isExpand == NO) || (indexPath.row == self.scenes.count+1 && isExpand == YES)) {
        //click monitor cell.
        WBMonitorViewController *vc = [[[WBMonitorViewController alloc] init] autorelease];
//        vc.sceneId = [[[self.scenes objectAtIndex:indexPath.row-1] objectAtIndex:1] intValue];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WBSceneConfigVC *vc = [[[WBSceneConfigVC alloc] init] autorelease];
        vc.sceneId = [[[self.scenes objectAtIndex:indexPath.row-1] objectAtIndex:1] intValue];
        [self.navigationController pushViewController:vc animated:YES];
    }

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
