//
//  DetailsViewController.h
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNo;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *btnMergeContacts;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

@end
