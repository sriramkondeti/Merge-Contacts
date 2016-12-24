//
//  DetailsViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "MergeTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DetailsViewController () {
  AppDelegate *delegate;
  NSMutableArray *mergableContactArr;
  NSMutableDictionary *temp, *detailDict;
    UIBarButtonItem * btnTemp;
}
@end

@implementation DetailsViewController
#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [self reloadData];//To load Picture & User Account NO
  [self findMergable]; //Identify Duplicate Contacts for the COntact selected.
  [_tableview reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Object Methods

- (void)reloadData {
  detailDict = [NSMutableDictionary dictionary];
  detailDict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
  _lblAccountNo.text = [[detailDict objectForKey:@"Account"] objectAtIndex:0];
  [_avatar
      sd_setImageWithURL:
          [NSURL URLWithString:[[detailDict objectForKey:@"PictureThumbnailUrl"]
                                   objectAtIndex:0]]
        placeholderImage:[UIImage imageNamed:@"Contacts-icon.png"]];
}
- (void)findMergable {
    btnTemp = _btnEdit;//Retain barButtonItem reference.
  temp = [NSMutableDictionary dictionary];
  mergableContactArr = [NSMutableArray array];
    //Identify Duplicate Contacts
  for (int i = 0; i < delegate.contactArray.count; i++) {
    if (i != delegate.selectedContact) {
      temp = [delegate.contactArray objectAtIndex:i];
      if ([[[temp objectForKey:@"Account"] objectAtIndex:0]
              isEqual:[[detailDict objectForKey:@"Account"] objectAtIndex:0]]) {
        [mergableContactArr addObject:temp];
      }
    }
  }
    //Enable or Disable Merge Btn Based on the Duplicate Contact Count.
    if ([mergableContactArr count]>0) {
        [_btnMergeContacts setEnabled:YES];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        [_btnMergeContacts setEnabled:NO];
        self.navigationItem.rightBarButtonItem = btnTemp;
    }
    //Enable Edit Only if Redundancy Found.
    for (NSMutableArray *arr in [detailDict allValues])
    {
        if ([arr count]>1){
            self.navigationItem.rightBarButtonItem = btnTemp;
            break;
        }
        else
            self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[detailDict allKeys] count];//NSMutableDictionary -  Count of Keys
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return [[[detailDict allValues] objectAtIndex:section] count]; //NSMutableDictionary -  objects returned for Each key.
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

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return [[detailDict allKeys] objectAtIndex:section];//NSMutableDictionary Key as the Section Title
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
    //Custom Cell Implementation
  MergeTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell =
        [[MergeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }

  cell.lblValue.text = [[[detailDict allValues] objectAtIndex:indexPath.section]
      objectAtIndex:indexPath.row];

  [cell.deleteBtn setHidden:YES];
  cell.backgroundView = [[UIImageView alloc]
      initWithImage:[[UIImage imageNamed:@"TableRow_Light.png"]
                        stretchableImageWithLeftCapWidth:0.0
                                            topCapHeight:5.0]];

  return cell;
}



#pragma mark - Navigation

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    //when the Segue Unwinds DetailsVC.
  [self reloadData];
  [self findMergable];
  [_tableview reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  //User Selected Contact details
  NSArray *selectedKeyArr = [NSMutableArray array];
  NSArray *selectedValArr = [NSMutableArray array];
  //User Duplicate Contact details
  NSArray *mergeKeyArr = [NSMutableArray array];
  NSArray *mergeValArr = [NSMutableArray array];

  selectedKeyArr =
      [[delegate.contactArray objectAtIndex:delegate.selectedContact] allKeys];
  selectedValArr = [
      [delegate.contactArray objectAtIndex:delegate.selectedContact] allValues];
//For Every Duplicate Contact
  for (int i = 0; i < mergableContactArr.count; i++) {
    mergeKeyArr = [[mergableContactArr objectAtIndex:i] allKeys];
    mergeValArr = [[mergableContactArr objectAtIndex:i] allValues];

    for (int j = 0; j < [mergeKeyArr count]; j++) {
//If User selected contact contains the same Key as Duplicate Contact, merge the Duplicate content to the User selected Contact instaed of Replacing.
      if ([selectedKeyArr containsObject:[mergeKeyArr objectAtIndex:j]]) {

        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = [[delegate.contactArray objectAtIndex:delegate.selectedContact]
            objectForKey:[mergeKeyArr objectAtIndex:j]];
          //While Merging, Make sure that the Dupliacte content is not present in the User selected Contact,  to Avoid redudndacy.Add Value if its not Preseent in the User Selected Contact.
        if (![arr containsObject:[[mergeValArr objectAtIndex:j]
                                     objectAtIndex:0]]) {
          [arr addObject:[[mergeValArr objectAtIndex:j] objectAtIndex:0]];
          [[delegate.contactArray objectAtIndex:delegate.selectedContact]
              setObject:arr
                 forKey:[mergeKeyArr objectAtIndex:j]];
        }
      }
//if User selected contact doesn't contain the Key/Value present in Duplicate Contact, Add it to the User seelcted Contact.
      else if (![selectedKeyArr containsObject:[mergeKeyArr objectAtIndex:j]]) {
        [[delegate.contactArray objectAtIndex:delegate.selectedContact]
            setObject:[mergeValArr objectAtIndex:j]
               forKey:[mergeKeyArr objectAtIndex:j]];
      }
    }
  }
    
    
//Delete the Duplicate contact from the Global Contact Array, Since its data Merged.
  for (int j = 0; j < mergableContactArr.count; j++) {

    for (int i = 0; i < delegate.contactArray.count; i++) {

      temp = [delegate.contactArray objectAtIndex:i];
      NSString *mergeID = [[[mergableContactArr objectAtIndex:j]
          objectForKey:@"ID"] objectAtIndex:0];
      NSString *contactID = [[temp objectForKey:@"ID"] objectAtIndex:0];
      if ([mergeID isEqual:contactID]) {

        NSString *selectedID =
            [[[delegate.contactArray objectAtIndex:delegate.selectedContact]
                objectForKey:@"ID"] objectAtIndex:0];
        [delegate.contactArray removeObjectAtIndex:i];
        i = 0;
          //Make sure to Keep Track of User selected contact as removing Objects changes the Order of Global contact array.
        for (int k = 0; k < delegate.contactArray.count; k++) {
          temp = [delegate.contactArray objectAtIndex:k];
          if ([[[temp objectForKey:@"ID"] objectAtIndex:0]
                  isEqual:selectedID]) {
            delegate.selectedContact = k;
          }
        }
      }
    }
  }
//Broadcast the change to the View COntrollers.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveData"
                                                      object:nil];
}

@end
