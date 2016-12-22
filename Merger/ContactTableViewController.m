//
//  ContactTableViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactTableViewController.h"

@interface ContactTableViewController () {
  AppDelegate *delegate;
  NSMutableDictionary *temp;
}
@end

@implementation ContactTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  temp = [NSMutableDictionary dictionary];
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
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }
  temp = [delegate.contactArray objectAtIndex:indexPath.row];
   
  cell.textLabel.text =
      [[temp objectForKey:@"FullName"] objectAtIndex:0]
          ? [[temp objectForKey:@"FullName"] objectAtIndex:0]
          : [[temp objectForKey:@"FirstName"] objectAtIndex:0];
  cell.detailTextLabel.text = [[temp objectForKey:@"Account"] objectAtIndex:0];
    cell.imageView.image = [UIImage imageNamed:@"Contacts-icon.png"];
    NSURL *url = [NSURL URLWithString:[[temp objectForKey:@"PictureThumbnailUrl"] objectAtIndex:0]];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.imageView.image = image;
                });
            }
        }
    }];
    [task resume];
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
