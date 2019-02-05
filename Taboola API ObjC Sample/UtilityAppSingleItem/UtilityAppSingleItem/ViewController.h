//
//  ViewController.h
//  UtilityAppSingleItem
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaboolaSDK/TaboolaApi.h>
@interface ViewController : UIViewController 

@property (weak, nonatomic) IBOutlet TBImageView *imageView;
@property (weak, nonatomic) IBOutlet TBBrandingLabel *brandingLabel;
@property (weak, nonatomic) IBOutlet TBTitleLabel *titleLabel;

@end
