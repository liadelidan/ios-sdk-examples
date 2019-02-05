//
//  TBPlacementTableViewCell.m
//  TaboolaDemoApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import "TBPlacementTableViewCell.h"

@implementation TBPlacementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)attributionButtonClicked:(id)sender {
    [[TaboolaApi sharedInstance]handleAttributionClick];
}

@end
