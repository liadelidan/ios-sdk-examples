//
//  MidArticleManualScrollViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/28/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "MidArticleManualScrollViewController.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface MidArticleManualScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TaboolaView *midTaboolaView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@end

@implementation MidArticleManualScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    //load tabolaView
    self.midTaboolaView.delegate = self;
    self.midTaboolaView.ownerViewController = self;
    self.midTaboolaView.mode = @"thumbnails-sdk1";
    self.midTaboolaView.publisher = @"betterbytheminute-app";
    self.midTaboolaView.pageType = @"article";
    self.midTaboolaView.pageUrl = @"http://www.example.com";
    self.midTaboolaView.placement = @"Mobile";
    self.midTaboolaView.targetType = @"mix";
//    self.midTaboolaView.autoResizeHeight = YES;
//    self.midTaboolaView.scrollEnable = NO;
    self.midTaboolaView.enableClickHandler = YES;
    self.midTaboolaView.logLevel = LogLevelDebug;
    [self.midTaboolaView setOverrideScrollIntercept:YES];
    [self.midTaboolaView fetchContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll! %f",scrollView.contentOffset.y);
    [self didEndScrollOfParentScroll];
}

-(BOOL)didEndScrollOfParentScroll {
    float h = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    float inset = 0;
    if (@available(iOS 11.0, *)) {
        inset = self.scrollView.adjustedContentInset.bottom;
    } else {
        inset = self.scrollView.contentInset.bottom;
    }
    float y = self.scrollView.contentOffset.y - inset;
    if (h <= y && self.scrollView.scrollEnabled && self.scrollView.contentSize.height > TaboolaView.widgetHeight) {
        NSLog(@"did finish scrolling");
        [self.midTaboolaView setScrollEnable:YES];
        self.scrollView.scrollEnabled = NO;
        return YES;
    }
    return NO;
}

- (void)scrollViewDidScrollToTopTaboolaView:(UIView*)taboolaView {
    if (self.midTaboolaView.scrollEnable) {
        NSLog(@"did finish scrolling taboola");
        [self.midTaboolaView setScrollEnable:NO];
        self.scrollView.scrollEnabled = YES;
    }

}

@end
