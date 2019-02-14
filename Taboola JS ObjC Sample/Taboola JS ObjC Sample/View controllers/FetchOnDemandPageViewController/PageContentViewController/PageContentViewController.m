//
//  PageContentViewController.m
//  Taboola JS ObjC Sample
//
//  Created by Roman Slyepko on 1/23/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

#import "PageContentViewController.h"
#import <TaboolaSDK/TaboolaSDK.h>
#import <WebKit/WebKit.h>

@interface PageContentViewController () <TaboolaJSDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexLabel.text = [NSString stringWithFormat:@"%lu", self.pageIndex];
    [TaboolaJS sharedInstance].delegate = self;
    [[TaboolaJS sharedInstance] setLogLevel:LogLevelDebug];
    [[TaboolaJS sharedInstance] registerWebView:self.webView];
    [self loadExamplePage:self.webView];
}

- (void)loadExamplePage:(UIView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"sampleContentPageLazyLoad" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:appHtml baseURL:[NSURL URLWithString:@"http://cdn.taboola.com/mobile-sdk/init/"]];
}
- (IBAction)fetchButtonPressed:(id)sender {
    [[TaboolaJS sharedInstance] fetchContent:self.webView];
}

@end
