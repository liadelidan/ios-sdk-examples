//
//  TaboolaCollectionCell.h
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 2/6/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaboolaSDK/TaboolaSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface TaboolaCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet TaboolaView *taboolaView;
@end

NS_ASSUME_NONNULL_END
