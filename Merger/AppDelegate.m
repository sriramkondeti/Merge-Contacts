//
//  AppDelegate.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize contactArray, selectedContact;
#pragma mark - App Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  // Global Apperance
  [[UINavigationBar appearance]
      setBarTintColor:[UIColor colorWithRed:35.0f / 255.0f
                                      green:180.0f / 255.0f
                                       blue:234.0f / 255.0f
                                      alpha:1.000]];

  // Navigation Bar - Title Color and Font Size
  [[UINavigationBar appearance]
      setTitleTextAttributes:[NSDictionary
                                 dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor],
                                     NSForegroundColorAttributeName,
                                     [UIFont fontWithName:@"Helvetica-Bold"
                                                     size:18.0f],
                                     NSFontAttributeName, nil]];

  // Navigation Bar - BarButtonItem Color
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  // UIBarButtonItem - Color and Font Size
  [[UIBarButtonItem appearance]
      setTitleTextAttributes:[NSDictionary
                                 dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor],
                                     NSForegroundColorAttributeName,
                                     [UIFont fontWithName:@"Helvetica-Bold"
                                                     size:14.0f],
                                     NSFontAttributeName, nil]
                    forState:UIControlStateNormal];
  selectedContact = 0;
  self.contactArray = [NSMutableArray array];//Array to Save all the Contacts received from the API.
  NSURLRequest *request = [NSURLRequest
       requestWithURL:
           [NSURL URLWithString:@"https://contacts-8d05b.firebaseio.com/.json"]
          cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:5.0];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask* dataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData* data, NSURLResponse* response,
            NSError* error) {
            if ([data length] > 0 && error == nil) {
                NSMutableArray* resultArr = [[NSMutableArray alloc] init];
                resultArr = [[[NSJSONSerialization
                    JSONObjectWithData:data
                               options:NSJSONReadingAllowFragments
                                 error:&error] objectForKey:@"d"]
                    objectForKey:@"results"];
                //Each value is inserted into an Array and resaved in to the Global Contact array.
                //This is to group objects with similiar keys into one record, without replacing the existing Values.
                for (int j = 0; j < resultArr.count; j++) {
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc]
                        initWithDictionary:[resultArr objectAtIndex:j]];
                    for (int i = 0; i < [[dict allKeys] count]; i++) {

                        [dict setObject:[[NSMutableArray alloc] initWithObjects:
                                              [dict objectForKey:[[dict allKeys]
                                                                     objectAtIndex:i]],
                                          nil]
                               forKey:[[dict allKeys] objectAtIndex:i]];
                    }
                    [self.contactArray addObject:dict];
                }
                //Post Notification to View to Reload the table data.
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"didReceiveData"
                                  object:nil];
            }

        }];

  [dataTask resume];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate
  // graphics rendering callbacks. Games should use this method to pause the
  // game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
