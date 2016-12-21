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
    NSMutableArray *mergableContactArr;
    NSMutableDictionary *temp;

}
@end

@implementation DetailsViewController
@synthesize detailsTextview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict =temp = [NSMutableDictionary dictionary];
    mergableContactArr = [NSMutableArray array];
    dict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
    NSArray *keyArray = [dict allKeys];
    for (int i=0; i<keyArray.count ; i++) {
        if (![[keyArray objectAtIndex:i] isEqual:@"PictureThumbnailUrl"] && ![[keyArray objectAtIndex:i] isEqual:@"ID"] ) {
        detailsTextview.text = [NSString stringWithFormat:@"%@%@ : %@\n\n", detailsTextview.text, [keyArray objectAtIndex:i],[dict objectForKey:[keyArray objectAtIndex:i]]];
        }
    }
    for (int i=0; i<delegate.contactArray.count; i++) {
        if (i!=delegate.selectedContact) {
            
            temp = [delegate.contactArray objectAtIndex:i];
            if ([[temp objectForKey:@"Account"] isEqual:[dict objectForKey:@"Account"]] ) {
                [mergableContactArr addObject:temp];
            }
        }
    }
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return mergableContactArr.count ;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    temp = [mergableContactArr objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [temp objectForKey:@"FullName"]?[temp objectForKey:@"FullName"]:[temp objectForKey:@"FirstName"];
    cell.textLabel.text = [temp objectForKey:@"Account"];
    return cell;
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
