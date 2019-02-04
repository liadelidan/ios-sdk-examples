//
//  MidArticleScrollViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/24/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "MidArticleScrollViewController.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface MidArticleScrollViewController () <TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet TaboolaView *midTaboolaView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;

@end

@implementation MidArticleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load tabolaView
    self.midTaboolaView.delegate = self;
    self.midTaboolaView.ownerViewController = self;
    self.midTaboolaView.mode = @"thumbnails-sdk1";
    self.midTaboolaView.publisher = @"betterbytheminute-app";
    self.midTaboolaView.pageType = @"article";
    self.midTaboolaView.pageUrl = @"http://www.example.com";
    self.midTaboolaView.placement = @"Mobile";
    self.midTaboolaView.targetType = @"mix";
    self.midTaboolaView.enableClickHandler = YES;
    [self.midTaboolaView setInterceptScroll:YES];
    self.midTaboolaView.logLevel = LogLevelDebug;
    
    [self.midTaboolaView fetchContent];
}




@end
