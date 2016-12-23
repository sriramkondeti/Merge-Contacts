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

@interface ContactTableViewController () {
  AppDelegate *delegate;
  NSMutableDictionary *contactDict;
}
@end

@implementation ContactTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  contactDict = [NSMutableDictionary dictionary];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveData)
                                               name:@"didReceiveData"
                                             object:nil];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)didReceiveData {
  dispatch_async(dispatch_get_main_queue(), ^{

    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return delegate.contactArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  contactDict = [delegate.contactArray objectAtIndex:indexPath.row];
  cell.textLabel.text = [[contactDict objectForKey:@"FullName"] objectAtIndex:0] ? [[contactDict objectForKey:@"FullName"] objectAtIndex:0] : [[contactDict objectForKey:@"FirstName"] objectAtIndex:0];
  cell.detailTextLabel.text = [[contactDict objectForKey:@"Account"] objectAtIndex:0];
 [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[contactDict objectForKey:@"PictureThumbnailUrl"] objectAtIndex:0]]
     
                      placeholderImage:[UIImage imageNamed:@"Contacts-icon.png"]];
    

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  delegate.selectedContact = (int)indexPath.row;
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
