//
//  WBAppDelegate.m
//  PMC
//
//  Created by wangbo on 13-8-12.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "WBAppDelegate.h"

#import "IndexViewController.h"


@implementation WBAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (void)recei:(NSNotification *)notif {
    NSDictionary *dict = notif.userInfo;
    if ([dict objectForKey:@"task"]) {
//        DBProcessTask *task = [dict objectForKey:@"task"];
    }
}

//register info 
- (void)registerData {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"poe.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[DBHelper sharedInstance] setDBPath:path];
        return;
    }
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[DBHelper sharedInstance] setDBPath:path];
    DBProcessTask *task = [[DBProcessTask alloc] init];
    task.sql = @"CREATE TABLE IF NOT EXISTS light_mstr(light_id INTEGER PRIMARY KEY, light_office_id TEXT, light_group_id INTEGER, light_mac TEXT, light_ip TEXT); CREATE TABLE IF NOT EXISTS office_mstr(office_id TEXT PRIMARY KEY , office_desc TEXT, office_image_url TEXT);  CREATE TABLE IF NOT EXISTS scene_mstr(scene_id INTEGER PRIMARY KEY AUTOINCREMENT, scene_name TEXT); CREATE TABLE IF NOT EXISTS scene_det(scene_det_id INTEGER, scene_resource_id INTEGER, scene_bright INTEGER);";
//    task.notificationName = @"createDB";
    task.taskType = TaskCreateTable;
    [[DBHelper sharedInstance] doTask:task];
    [task release];
    task = nil;
    
    //office_mstr
//    NSString *office_id = @"No2_2F20#";
//    task = [[DBProcessTask alloc] init];
//    task.sql = [NSString stringWithFormat:@"INSERT INTO office_mstr(office_id) VALUES(\"%@\")",office_id];
//    task.taskType = TaskExecCommand;
//    [[DBHelper sharedInstance] doTask:task];
//    [task release];
//    task = nil;
    
    
    //light_mstr
//    NSArray *arrayMAC = [NSArray arrayWithObjects:@"706f77d54031", @"706f77d63964", @"706f77d72756", @"706f77d82750", nil];
//    NSArray *arrayIP = [NSArray arrayWithObjects:@"192.168.1.138", @"192.168.1.140", @"192.168.1.142", @"192.168.1.149", nil];
//    for (int i = 0; i < 4; i ++) {
//        task = [[DBProcessTask alloc] init];
//        task.sql = [NSString stringWithFormat:@"INSERT INTO light_mstr (light_office_id, light_mac, light_ip) VALUES(\"%@\", \"%@\", \"%@\")",office_id, [arrayMAC objectAtIndex:i], [arrayIP objectAtIndex:i]];
//        task.taskType = TaskExecCommand;
//        [[DBHelper sharedInstance] doTask:task];
//        if (task.resultCode == -1) {
//            NSLog(@"error in %d",i+1);
//        }
//        [task release];
//        task = nil;
//    }
    
    //scene_mstr
    NSArray *arrayScene = [NSArray arrayWithObjects:@"Presentation", @"Meeting", @"Working", @"Leisure", nil];
    for (int i = 0; i < 4; i ++) {
            task = [[DBProcessTask alloc] init];
            task.sql = [NSString stringWithFormat:@"INSERT INTO scene_mstr (scene_name) VALUES(\"%@\")", [arrayScene objectAtIndex:i]];
            task.taskType = TaskExecCommand;
            [[DBHelper sharedInstance] doTask:task];
            if (task.resultCode == -1) {
                NSLog(@"error in %d",i+1);
            }
            [task release];
    }
    
    //scene_det
//    for (int i = 0; i < 4; i ++) {
//        for (int j = 0; j < 4; j ++) {
//            task = [[DBProcessTask alloc] init];
//            task.sql = [NSString stringWithFormat:@"INSERT INTO scene_det (scene_det_id,  scene_resource_id, scene_bright) VALUES(%d, %d, %d)", i+1, j+1, 100];
//            task.taskType = TaskExecCommand;
//            [[DBHelper sharedInstance] doTask:task];
//            if (task.resultCode == -1) {
//                NSLog(@"error in %d",i+1);
//            }
//            [task release];
//        }
//    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //register user default data.
    [self registerData];
//    [ConfigurationManager registerDefaultData];
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil] autorelease];
//
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    
    /*test*/
//    WBMonitorViewController *vc = [[[WBMonitorViewController alloc] init] autorelease];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    
    
    nav.navigationBar.tintColor = [UIColor blackColor];
    nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:16.0] forKey:UITextAttributeFont];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
