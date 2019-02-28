//
//  TaboolaCollectionViewCell.h
//  UICollectionViewAppWithTaboola
//
//  Created by Roman Slyepko on 5/25/18.
//  Copyright © 2018 Taboola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaboolaSDK/TaboolaSDK.h>

@interface TaboolaViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet TaboolaView *taboolaView;
@end
