//
//  DetailsViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
@interface DetailsViewController () {
  AppDelegate *delegate;
  NSMutableArray *mergableContactArr;
  NSMutableDictionary *temp;
}
@end

@implementation DetailsViewController
@synthesize detailsTextview;
- (void)viewDidLoad {
  [super viewDidLoad];

  delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [self reloadData];
}

- (void)reloadData {
  detailsTextview.text = @"";
  NSMutableDictionary *detailDict = temp = [NSMutableDictionary dictionary];
  mergableContactArr = [NSMutableArray array];
  detailDict = [delegate.contactArray objectAtIndex:delegate.selectedContact];

  NSArray *keyArray = [detailDict allKeys];
  for (int i = 0; i < keyArray.count; i++) {
    detailsTextview.text = [NSString
        stringWithFormat:@"%@%@ : %@\n\n", detailsTextview.text,
                         [keyArray objectAtIndex:i],
                         [[detailDict objectForKey:[keyArray objectAtIndex:i]]
                             objectAtIndex:0]];
  }
  for (int i = 0; i < delegate.contactArray.count; i++) {
    if (i != delegate.selectedContact) {

      temp = [delegate.contactArray objectAtIndex:i];
      if ([[[temp objectForKey:@"Account"] objectAtIndex:0]
              isEqual:[[detailDict objectForKey:@"Account"] objectAtIndex:0]]) {
        [mergableContactArr addObject:temp];
      }
    }
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return mergableContactArr.count;
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
  temp = [mergableContactArr objectAtIndex:indexPath.row];

  cell.detailTextLabel.text =
      [[temp objectForKey:@"FullName"] objectAtIndex:0]
          ? [[temp objectForKey:@"FullName"] objectAtIndex:0]
          : [[temp objectForKey:@"FirstName"] objectAtIndex:0];
  cell.textLabel.text = [[temp objectForKey:@"Account"] objectAtIndex:0];
  return cell;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  NSArray *selectedKeyArr = [NSMutableArray array];
  NSArray *selectedValArr = [NSMutableArray array];
  NSArray *mergeKeyArr = [NSMutableArray array];
  NSArray *mergeValArr = [NSMutableArray array];

  selectedKeyArr =
      [[delegate.contactArray objectAtIndex:delegate.selectedContact] allKeys];
  selectedValArr = [
      [delegate.contactArray objectAtIndex:delegate.selectedContact] allValues];

  for (int i = 0; i < mergableContactArr.count; i++) {
    mergeKeyArr = [[mergableContactArr objectAtIndex:i] allKeys];
    mergeValArr = [[mergableContactArr objectAtIndex:i] allValues];

    for (int j = 0; j < [mergeKeyArr count]; j++) {

      if ([selectedKeyArr containsObject:[mergeKeyArr objectAtIndex:j]]) {

        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = [[delegate.contactArray objectAtIndex:delegate.selectedContact]
            objectForKey:[mergeKeyArr objectAtIndex:j]];
        if (![arr containsObject:[[mergeValArr objectAtIndex:j]
                                     objectAtIndex:0]]) {
          [arr addObject:[[mergeValArr objectAtIndex:j] objectAtIndex:0]];
          [[delegate.contactArray objectAtIndex:delegate.selectedContact]
              setObject:arr
                 forKey:[mergeKeyArr objectAtIndex:j]];
        }
      }

      else if (![selectedKeyArr containsObject:[mergeKeyArr objectAtIndex:j]]) {
        [[delegate.contactArray objectAtIndex:delegate.selectedContact]
            setObject:[mergeValArr objectAtIndex:j]
               forKey:[mergeKeyArr objectAtIndex:j]];
      }
    }
  }

  for (int j = 0; j < mergableContactArr.count; j++) {

    for (int i = 0; i < delegate.contactArray.count; i++) {
      if (i != delegate.selectedContact) {

        temp = [delegate.contactArray objectAtIndex:i];
        NSString *mergeID = [[[mergableContactArr objectAtIndex:j]
            objectForKey:@"ID"] objectAtIndex:0];
        NSString *contactID = [[temp objectForKey:@"ID"] objectAtIndex:0];
        if ([mergeID isEqual:contactID]) {

          NSString *selectedID =
              [[[delegate.contactArray objectAtIndex:delegate.selectedContact]
                  objectForKey:@"ID"] objectAtIndex:0];
          [delegate.contactArray removeObjectAtIndex:i];

          for (int k = 0; k < delegate.contactArray.count; k++) {
            temp = [delegate.contactArray objectAtIndex:k];
            if ([[[temp objectForKey:@"ID"] objectAtIndex:0]
                    isEqual:selectedID]) {
              delegate.selectedContact = k;
            };
          }
        }
      }
    }
  }
  [self reloadData];
  [_tableview reloadData];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveData"
                                                      object:nil];
}

@end
