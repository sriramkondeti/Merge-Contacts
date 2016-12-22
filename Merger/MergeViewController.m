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

@interface MergeViewController () {
  AppDelegate *delegate;
  NSMutableDictionary *mergedContactDict;
}

@end

@implementation MergeViewController
@synthesize tableview;
- (void)viewDidLoad {
  [super viewDidLoad];
  delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  mergedContactDict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
  _lblAccountNo.text = [[mergedContactDict objectForKey:@"Account"] objectAtIndex:0];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   NSURL *url = [NSURL
                       URLWithString:[[mergedContactDict objectForKey:@"PictureThumbnailUrl"]
                                         objectAtIndex:0]];
                   NSData *data = [NSData dataWithContentsOfURL:url];
                     UIImage *image = [[UIImage alloc] initWithData:data]?[[UIImage alloc] initWithData:data]:[UIImage imageNamed:@"Contacts-icon.png"];
                   dispatch_async(dispatch_get_main_queue(), ^{
                     [_avatar setImage:image];
                   });
                 });

  // Do any additional setup after loading the view.*/
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[mergedContactDict allKeys] count];
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return [[[mergedContactDict allValues] objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [[mergedContactDict allKeys] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
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
  MergeTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[MergeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }

  cell.lblValue.text = [[[mergedContactDict allValues] objectAtIndex:indexPath.section]
      objectAtIndex:indexPath.row];
  if ([[[mergedContactDict allValues] objectAtIndex:indexPath.section] count] > 1) {
    [cell.deleteBtn setHidden:NO];
  } else {
    [cell.deleteBtn setHidden:YES];
  }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"TableRow_Light.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.cellDelegate = self;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  delegate.selectedContact = (int)indexPath.row;
}

- (void)deleteBtnPressed:(MergeTableViewCell *)cell {

  NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
  [[[mergedContactDict allValues] objectAtIndex:indexPath.section]
      removeObjectAtIndex:indexPath.row];
  [tableview reloadData];
}

/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
