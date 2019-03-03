//
//  FeedTableViewCell.m
//  Taboola API ObjC Samples
//
//  Created by Roman Slyepko on 1/17/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.mainImageView.image = nil;
}

@end
