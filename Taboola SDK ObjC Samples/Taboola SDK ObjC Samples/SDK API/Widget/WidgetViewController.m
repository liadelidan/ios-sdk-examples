//
//  WidgetViewController.m
//  Taboola API ObjC Sample
//
//  Created by Roman Slyepko on 1/18/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

#import "WidgetViewController.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface WidgetViewController () <UITableViewDelegate, UITableViewDataSource, TaboolaApiClickDelegate>
@property (nonatomic) TaboolaApi *taboolaApi;
@property (nonatomic) TBRecommendationRequest *recomendationRequest;
@property (nonatomic) TBPlacement *placement;

// taboola iboutles
@property (weak, nonatomic) IBOutlet TBImageView *imageView;
@property (weak, nonatomic) IBOutlet TBTitleLabel *titleView;
@property (weak, nonatomic) IBOutlet TBBrandingLabel *brandingView;
@property (weak, nonatomic) IBOutlet TBDescriptionLabel *descriptionView;

@property (nonatomic) NSArray *itemsArray;
@end

@implementation WidgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsArray = [NSArray new];
    
    self.taboolaApi = [TaboolaApi sharedInstance];
    [self.taboolaApi startWithPublisherID:@"sdk-tester" andApiKey:@"d39df1418f5a4819c9eae2ca02595d57de98c246"];
    [self.taboolaApi setExtraPropetries:@{@"fsdfds":@1}];
    self.taboolaApi.clickDelegate = self;
    
    [self fetchRecommendation];
}

- (void)updateTaboolaUI {
    TBItem *item = self.itemsArray.firstObject;
    [item initThumbnailView:self.imageView];
    [item initTitleView:self.titleView];
    [item initBrandingView:self.brandingView];
    [item initDescriptionView:self.descriptionView];
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
        self.itemsArray = [placement.listOfItems copy];
        [self updateTaboolaUI];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Taboola API: error fetching recommendations: \n%@", error.localizedDescription);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WidgetFeed"];
    cell.textLabel.text = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem";
    return cell;
}

#pragma mark - Taboola API Click Delegate


- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
