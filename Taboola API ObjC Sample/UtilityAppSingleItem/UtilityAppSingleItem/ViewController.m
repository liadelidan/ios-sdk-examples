//
//  ViewController.m
//  UtilityAppSingleItem
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <TaboolaApiClickDelegate>
@property (nonatomic) TaboolaApi *taboolaApi;
@property (nonatomic) TBRecommendationRequest *recomendationRequest;
@property (nonatomic) TBPlacement *placement;
@property (nonatomic) TBItem *taboolaItem;

@end

@implementation ViewController {
    BOOL torchEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taboolaApi = [TaboolaApi sharedInstance];
    self.taboolaApi.clickDelegate = self;
    
    [self fetchRecommendation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchRecommendation {
    self.recomendationRequest = [TBRecommendationRequest new];
    self.recomendationRequest.sourceType = TBSourceTypeText;
    [self.recomendationRequest setPageUrl: @"http://www.example.com"];
    
    TBPlacementRequest *parameters = [TBPlacementRequest new];
    parameters.name = @"article";
    parameters.recCount = 1;
    
    [self.recomendationRequest addPlacementRequest:parameters];
    
    [self.taboolaApi fetchRecommendations:self.recomendationRequest onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        self.placement = placement;
        [self updateTaboolaViewWithItem:[placement.listOfItems firstObject]];
        
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)updateTaboolaViewWithItem:(TBItem*) item {
    [item initThumbnailView:self.imageView];
    [item initTitleView:self.titleLabel];
    [item initBrandingView:self.brandingLabel];
}

- (IBAction)attributionButtonClicked:(id)sender {
    [[TaboolaApi sharedInstance]handleAttributionClick];
}

- (IBAction)switchTorch:(id)sender {
    [self setTorchEnabled:!torchEnabled];
    [(UIButton*)sender setSelected:torchEnabled];
}


- (void)setTorchEnabled:(BOOL)enabled {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isTorchAvailable] && [device isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [device lockForConfiguration:nil];
        if (success) {
            if (enabled)
                [device setTorchMode:AVCaptureTorchModeOn];
            else
                [device setTorchMode:AVCaptureTorchModeOff];
            torchEnabled = enabled;
            [device unlockForConfiguration];
        }
    } else
        NSLog(@"Torch is not available");
}


#pragma mark - TaboolaApiClickDelegate

- (BOOL)onItemClick:(NSString *)placemetName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
