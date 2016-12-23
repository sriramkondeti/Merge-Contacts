//
//  ContactTableViewCell.m
//  Merger
//
//  Created by Sri Ram on 12/23/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize lblDuplicates,textlbl,detailTextlbl;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
