//
//  TBPlacementTableViewCell.h
//  TaboolaDemoApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaboolaSDK/TaboolaApi.h>

@interface TBPlacementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TBImageView *tbImageView;
@property (weak, nonatomic) IBOutlet TBTitleLabel *titleView;
@property (weak, nonatomic) IBOutlet TBBrandingLabel *brandingView;
@property (weak, nonatomic) IBOutlet UIButton *attributionButton;

@end
