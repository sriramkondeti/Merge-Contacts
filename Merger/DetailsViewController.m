//
//  DetailsViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
@interface DetailsViewController ()
{
    AppDelegate *delegate ;
}
@end

@implementation DetailsViewController
@synthesize detailsTextview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
    NSArray *keyArray = [dict allKeys];
    for (int i=0; i<keyArray.count ; i++) {
        if (![[keyArray objectAtIndex:i] isEqual:@"PictureThumbnailUrl"] && ![[keyArray objectAtIndex:i] isEqual:@"ID"] ) {
        detailsTextview.text = [NSString stringWithFormat:@"%@%@ : %@\n", detailsTextview.text, [keyArray objectAtIndex:i],[dict objectForKey:[keyArray objectAtIndex:i]] ];
        }
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
