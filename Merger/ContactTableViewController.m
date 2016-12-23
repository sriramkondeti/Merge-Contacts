//
//  ContactTableViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactTableViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ContactTableViewCell.h"

@interface ContactTableViewController () {
  AppDelegate *delegate;
  NSMutableDictionary *contactDict;
}
@end

@implementation ContactTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [MBProgressHUD showHUDAddedTo:self.view animated:YES];//Activity Indicator
  delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  contactDict = [NSMutableDictionary dictionary];
    //Add Observer to receive the NSNotification.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveData)
                                               name:@"didReceiveData"
                                             object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotificationcenter


- (void)didReceiveData {
  dispatch_async(dispatch_get_main_queue(), ^{

    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];//Make sure to Reload on Main Thread as Notification is sent via BG thread.
  });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return delegate.contactArray.count;
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Remove seperator inset
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  // Prevent the cell from inheriting the Table View's margin settings
  if ([cell
          respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  // Explictly set your cell's layout margins
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
    //CustomTableview Cell.
  ContactTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  contactDict = [delegate.contactArray objectAtIndex:indexPath.row];
  cell.textlbl.text =
      [[contactDict objectForKey:@"FullName"] objectAtIndex:0]
          ? [[contactDict objectForKey:@"FullName"] objectAtIndex:0]
          : [[contactDict objectForKey:@"FirstName"] objectAtIndex:0];
  cell.detailTextlbl.text =
      [[contactDict objectForKey:@"Account"] objectAtIndex:0];
   NSMutableDictionary * temp = [NSMutableDictionary dictionary];
   NSMutableArray *duplicateContactArr = [NSMutableArray array];
    //Find Duplicate contacts for each contact and display.
    for (int i = 0; i < delegate.contactArray.count; i++) {
        if (i != indexPath.row) {
            temp = [delegate.contactArray objectAtIndex:i];
            if ([[[temp objectForKey:@"Account"] objectAtIndex:0]
                 isEqual:[[contactDict objectForKey:@"Account"] objectAtIndex:0]]) {
                [duplicateContactArr addObject:temp];
            }
        }
    }
    cell.lblDuplicates.text = [NSString stringWithFormat:@"%d", (int)[duplicateContactArr count]];
    cell.lblDuplicates.backgroundColor =[duplicateContactArr count]>0? [UIColor colorWithRed:(255.0/255.0) green:(23.0/255.0) blue:(68.0/255.0)alpha:1]:[UIColor colorWithRed:(6.0/255.0) green:(220.0/255.0) blue:(167.0/255.0)alpha:1];
    //Cahce UIimage to avoid Redownloading when the cells are dequed & Resued.
  [cell.avatar
      sd_setImageWithURL:
          [NSURL
              URLWithString:[[contactDict objectForKey:@"PictureThumbnailUrl"]
                                objectAtIndex:0]]
        placeholderImage:[UIImage imageNamed:@"Contacts-icon.png"]];
    
  return cell;
}
#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  delegate.selectedContact = (int)indexPath.row;
}

@end
