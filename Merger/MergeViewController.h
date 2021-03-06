//
//  MergeViewController.h
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MergeTableViewCell.h"

@interface MergeViewController
    : UIViewController <UITableViewDelegate, UITableViewDataSource,
                        mergeTableViewCellDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNo;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
