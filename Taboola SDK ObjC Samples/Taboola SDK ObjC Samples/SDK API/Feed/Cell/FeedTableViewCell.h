//
//  FeedTableViewCell.h
//  Taboola API ObjC Samples
//
//  Created by Roman Slyepko on 1/17/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaboolaSDK/TaboolaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TBImageView *mainImageView;
@property (weak, nonatomic) IBOutlet TBTitleLabel *titleView;
@property (weak, nonatomic) IBOutlet TBBrandingLabel *brandingView;
@property (weak, nonatomic) IBOutlet TBDescriptionLabel *descriptionView;

@end

NS_ASSUME_NONNULL_END
