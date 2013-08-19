//
//  IndexViewController.m
//  LampIphoneApp
//
//  Created by wangbo on 13-5-31.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "IndexViewController.h"

//#import "RootViewController.h"

//#import "ConfigurationManager.h"

#import "WBAppDelegate.h"

#import "WBGeneralControlVC.h"

#import "AFNetworking.h"

#import "JSON.h"

#import "MBProgressHUD.h"

@interface IndexViewController () {
//    NSString *scanResult;
}

@end

@implementation IndexViewController

@synthesize scanResult = _scanResult;

@synthesize tblSystem = _tblSystem;

@synthesize arrayMenu = _arrayMenu;

@synthesize txtRoom = _txtRoom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.txtRoom = nil;
    self.tblSystem.delegate = nil;
    self.tblSystem.dataSource = nil;
    self.tblSystem = nil;
    self.arrayMenu = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"PHILIPS";
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0f];
    
    UIButton *btn = [UIButton buttonWithType:110];
    btn.tintColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 240, 120, 40);
//    btn.titleLabel.text = @"Start";
    [btn addTarget:self action:@selector(gotoScan) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Scan" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:110];
    btn.frame = CGRectMake(230, 350, 80, 35);
    [btn addTarget:self action:@selector(btnEnterTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Enter" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
//    self.arrayMenu = [NSArray arrayWithObjects:@"my office",@"Electronics labs", nil];
    
//    self.arrayMenu = [ConfigurationManager objectForKey:OfficeUserDefaultKey];
    
    self.tblSystem.delegate = self;
    self.tblSystem.dataSource = self;
    self.txtRoom.delegate = self;
    self.txtRoom.returnKeyType = UIReturnKeyDone;
//    self.tblSystem.backgroundColor = app_default_background_color;
    
    DBProcessTask *task = [[DBProcessTask alloc] init];
    task.sql = @"select office_id from office_mstr";
    task.taskType = TaskQueryData;
    [[DBHelper sharedInstance] doTask:task];
    if (task.resultCode == 1) {
        self.arrayMenu = task.resultCollection;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)checkAndValidation:(NSString *)code {
    [[PMCTool sharedInstance] setOfficeId:code];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.labelText = @"Loading";
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    NSURL *url = [NSURL URLWithString:getLightsForOffice(code)];
//    NSURLRequest *request_ = [NSURLRequest requestWithURL:url];
    NSURLRequest *request_ = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request_] autorelease];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
//        NSLog(@"%@",[str JSONValue]);
        
        NSArray *array = [str JSONValue];
        
        if (array==nil || array.count == 0) {
            hud.labelText = @"Room number is wrong.";
        
            [hud hide:YES afterDelay:1.0f];
            return ;
        }
        
        BOOL flag = [[PMCTool sharedInstance] replaceLightsInfo:array];
        
        if (flag == YES) {
            [hud hide:YES];
            [self gotoNextView];
        } else {
            hud.labelText = @"Error in loading";
            [hud hide:YES afterDelay:1.0f];
        }
        
//        WBGeneralControlVC *detailViewController = [[WBGeneralControlVC alloc] init];
        ////        detailViewController.office_id = self.txtRoom.text;
        ////        RootViewController *detailViewController = [[RootViewController alloc] init];
//        [self.navigationController pushViewController:detailViewController animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
//        [[PMCTool sharedInstance] setOfficeId:code];
        NSArray *array = [[PMCTool sharedInstance] getLightsInOffice];
        if (array && array.count > 0) {
            [hud hide:YES];
            [self gotoNextView];
        } else {
            hud.labelText = @"Error in loading";
            [hud hide:YES afterDelay:1.0f];
        }
    }];
    [operation start];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request_ success:^(NSURLRequest *request,NSHTTPURLResponse *response,id JSON){
//        NSLog(@"%@",JSON);
//    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
//        NSLog(@"error:%@",error);
//    }];
//    [operation start];
}

- (void)gotoNextView {
    WBGeneralControlVC *detailViewController = [[[WBGeneralControlVC alloc] init] autorelease];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)btnEnterTapped:(id)sender {
    [self checkAndValidation:self.txtRoom.text];
//    BOOL canFind = NO;
//    for (NSArray *dict in self.arrayMenu) {
//        if ([[dict objectAtIndex:0] isEqualToString:self.txtRoom.text]) {
//            canFind = YES;
//            break;
//        }
////        if ([[dict objectForKey:OfficeNameKey] isEqualToString:self.txtRoom.text]) {
////            canFind = YES;
////            break;
////        }
//    }
//    if (canFind) {
////        [Common setCurrentOfficeName:self.txtRoom.text];
//        [[PMCTool sharedInstance] setOfficeId:self.txtRoom.text];
//        WBGeneralControlVC *detailViewController = [[WBGeneralControlVC alloc] init];
////        detailViewController.office_id = self.txtRoom.text;
////        RootViewController *detailViewController = [[RootViewController alloc] init];
//        [self.navigationController pushViewController:detailViewController animated:YES];
//        [detailViewController release];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Room %@ is not exist!", self.txtRoom.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (void)gotoScan {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
//    for (UIView *view in [[reader.view.subviews objectAtIndex:0] subviews]) {
//        NSLog(@"view:%@",view);
//    }
    
//    UIBarButtonItem *ii = [[UIBarButtonItem alloc] init];
    
    
    for (id vv in reader.view.subviews) {
        if ([vv isKindOfClass:[UIView class]]) {
            for (id dd in ((UIView *)vv).subviews) {
                if ([dd isKindOfClass:[UIToolbar class]]) {
                    for (id aa in ((UIView *)dd).subviews) {
                        if ([aa isKindOfClass:[UIButton class]]) {
                            [aa removeFromSuperview];
                        }
                        if ([aa isKindOfClass:[NSClassFromString(@"UIToolbarTextButton") class]]) {
                            NSLog(@"dd:%@",aa);
//                            [aa setTitle:@"Cancel"];
                        }
                    }
                }
            }
        }
    }
    
    
//    for (UIButton *btn in reader.view.subviews) {
//        NSLog(@"button:%@",btn);
//    }
    
    // present and release the controller
//    [self presentModalViewController: reader
//                            animated: YES];
    
    [self presentViewController:reader animated:YES completion:nil];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
//    resultText.text = symbol.data;
    
    self.scanResult = symbol.data;
    
    NSLog(@"scan:%@",symbol.data);
    
    // EXAMPLE: do something useful with the barcode image
//    resultImage.image =
//    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [reader dismissModalViewControllerAnimated: YES];
    [reader dismissViewControllerAnimated:YES completion:^{
        [self checkScan];
    }];
}

- (void)checkScan {
    [self checkAndValidation:self.scanResult];
//    BOOL canFind = NO;
//    for (NSArray *dict in self.arrayMenu) {
//        if ([[dict objectAtIndex:0] isEqualToString:self.scanResult]) {
//            canFind = YES;
//            break;
//        }
////        if ([[dict objectForKey:OfficeNameKey] isEqualToString:self.scanResult]) {
////            canFind = YES;
////            break;
////        }
//    }
//    if (canFind) {
////        [Common setCurrentOfficeName:self.scanResult];
//        [[PMCTool sharedInstance] setOfficeId:self.scanResult];
//        WBGeneralControlVC *detailViewController = [[WBGeneralControlVC alloc] init];
////        RootViewController *detailViewController = [[RootViewController alloc] init];
//        [self.navigationController pushViewController:detailViewController animated:YES];
//        [detailViewController release];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Barcode may be wrong!result:%@",self.scanResult] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return self.arrayMenu.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell1";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"abc";
//    cell.textLabel.text = [[self.arrayMenu objectAtIndex:indexPath.row] objectForKey:OfficeNameKey];
    return cell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 35.0f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
//    _headerView.backgroundColor = [UIColor lightGrayColor];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width, _headerView.frame.size.height)];
//    lbl.text = @"Office List";
//    [lbl setFont:[UIFont systemFontOfSize:13.0f]];
//    lbl.backgroundColor = [UIColor clearColor];
//    [lbl setTextAlignment:NSTextAlignmentCenter];
//    [lbl setTextColor:[UIColor whiteColor]];
//    [_headerView addSubview:lbl];
//    [lbl release];
//    return [_headerView autorelease];
//}

- (void)unselectCurrentRow {
    [self.tblSystem deselectRowAtIndexPath:[self.tblSystem indexPathForSelectedRow] animated:YES];
}


@end
