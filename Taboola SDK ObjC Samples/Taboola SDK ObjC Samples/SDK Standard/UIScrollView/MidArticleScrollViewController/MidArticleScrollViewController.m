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
@property (weak, nonatomic) IBOutlet TaboolaView *feedTaboolaView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (nonatomic, strong) NSString *viewId;
@property (nonatomic) BOOL didLoadFeed;
@end

@implementation MidArticleScrollViewController

- (void)viewDidLoad {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    _viewId = [NSString stringWithFormat:@"%d",timestamp];
    [super viewDidLoad];
    
    //load mid tabolaView
    self.midTaboolaView.delegate = self;
    self.midTaboolaView.ownerViewController = self;
    self.midTaboolaView.publisher = @"sdk-tester";
    self.midTaboolaView.mode = @"alternating-widget-without-video-1-on-1";
    self.midTaboolaView.pageType = @"article";
    self.midTaboolaView.pageUrl = @"http://www.example.com";
    self.midTaboolaView.placement = @"Mid Article";
    self.midTaboolaView.targetType = @"mix";
    self.midTaboolaView.viewID = _viewId;
    self.midTaboolaView.logLevel = LogLevelDebug;
    [self.midTaboolaView fetchContent];
    
    //load feed tabolaView
    self.feedTaboolaView.delegate = self;
    self.feedTaboolaView.ownerViewController = self;
    self.feedTaboolaView.publisher = @"sdk-tester";
    self.feedTaboolaView.mode = @"thumbs-feed-01";
    self.feedTaboolaView.pageType = @"article";
    self.feedTaboolaView.pageUrl = @"http://www.example.com";
    self.feedTaboolaView.placement = @"Feed without video";
    self.feedTaboolaView.targetType = @"mix";
    [self.feedTaboolaView setInterceptScroll:YES];
    self.feedTaboolaView.viewID = _viewId;
    self.feedTaboolaView.logLevel = LogLevelDebug;
    
    
}

- (void)taboolaView:(UIView *)taboolaView didLoadPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    if ([placementName isEqualToString:@"Mid Article"]) {
        if (!_didLoadFeed) {
            _didLoadFeed = YES;
            // We are loading the feed only when the widget finished loading- for dedup.
            [_feedTaboolaView fetchContent];
        }
    }
}


@end
