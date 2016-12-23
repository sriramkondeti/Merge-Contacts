//
//  MergeViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "MergeViewController.h"
#import "AppDelegate.h"
#import "MergeTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MergeViewController () {
  AppDelegate *delegate;
  NSMutableDictionary *mergedContactDict;
}

@end

@implementation MergeViewController
@synthesize tableview;
#pragma mark - View Lifecycle

- (void)viewDidLoad {
  // Do any additional setup after loading the view.*/
  [super viewDidLoad];
  delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  mergedContactDict =
      [delegate.contactArray objectAtIndex:delegate.selectedContact];
  _lblAccountNo.text =
      [[mergedContactDict objectForKey:@"Account"] objectAtIndex:0];
  [_avatar sd_setImageWithURL:
               [NSURL URLWithString:[[mergedContactDict
                                        objectForKey:@"PictureThumbnailUrl"]
                                        objectAtIndex:0]]
             placeholderImage:[UIImage imageNamed:@"Contacts-icon.png"]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[mergedContactDict allKeys] count];//NSMutableDictionary - count of Keys.
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return [[[mergedContactDict allValues] objectAtIndex:section] count];////NSMutableDictionary - count of Objects at each key.
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return [[mergedContactDict allKeys] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {

  UILabel *myLabel = [[UILabel alloc] init];
  myLabel.frame = CGRectMake(20, 8, 320, 20);
  myLabel.font = [UIFont boldSystemFontOfSize:14];
  myLabel.textColor = [UIColor darkGrayColor];
  myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
  UIView *headerView = [[UIView alloc] init];
  [headerView setBackgroundColor:[UIColor whiteColor]];
  [headerView addSubview:myLabel];
  return headerView;
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
    //Custom Cell Implementation.
  MergeTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell =
        [[MergeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }

  cell.lblValue.text = [[[mergedContactDict allValues]
      objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  if ([[[mergedContactDict allValues] objectAtIndex:indexPath.section] count] >
      1) {
    [cell.deleteBtn setHidden:NO];
  } else {
    [cell.deleteBtn setHidden:YES];
  }
  cell.backgroundView = [[UIImageView alloc]
      initWithImage:[[UIImage imageNamed:@"TableRow_Light.png"]
                        stretchableImageWithLeftCapWidth:0.0
                                            topCapHeight:5.0]];
    //Set the Delegate as self as this VC will be handing the deletion of Objects.
  cell.cellDelegate = self;
  return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  delegate.selectedContact = (int)indexPath.row;
}

#pragma mark - Table view Cell Delegate

- (void)deleteBtnPressed:(MergeTableViewCell *)cell {

  NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
  //Remove the Object at Indexpath & Update the table, Global Contact array.
  [[[mergedContactDict allValues] objectAtIndex:indexPath.section]
      removeObjectAtIndex:indexPath.row];
  [tableview reloadData];
}


@end
