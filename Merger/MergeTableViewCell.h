//
//  MergeTableViewCell.h
//  Merger
//
//  Created by Sri Ram on 12/21/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mergeTableViewCellDelegate;

@interface MergeTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UITextField *lblValue;
@property(nonatomic, retain) id<mergeTableViewCellDelegate> cellDelegate;
@property(weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
@protocol mergeTableViewCellDelegate <NSObject>
//Implement the function in the Delegate.
- (void)deleteBtnPressed:(MergeTableViewCell *)cell;

@end

