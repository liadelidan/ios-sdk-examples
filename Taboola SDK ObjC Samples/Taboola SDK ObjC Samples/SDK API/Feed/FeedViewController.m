//
//  FeedViewController.m
//  Taboola API ObjC Samples
//
//  Created by Roman Slyepko on 1/17/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface FeedViewController () <TaboolaApiClickDelegate>
@property (nonatomic) TaboolaApi *taboolaApi;
@property (nonatomic) TBRecommendationRequest *recomendationRequest;
@property (nonatomic) NSMutableArray *itemsArray;
@property (nonatomic) TBPlacement *placement;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsArray = [NSMutableArray new];
    
    self.taboolaApi = [TaboolaApi sharedInstance];
    [self.taboolaApi startWithPublisherID:@"sdk-tester" andApiKey:@"d39df1418f5a4819c9eae2ca02595d57de98c246"];
    [self.taboolaApi setExtraPropetries:@{@"fsdfds":@1}];
    self.taboolaApi.clickDelegate = self;
    
    [self fetchRecommendation];
}

- (void)fetchRecommendation {
    self.recomendationRequest = [TBRecommendationRequest new];
    self.recomendationRequest.sourceType = TBSourceTypeText;
    [self.recomendationRequest setPageUrl: @"http://www.example.com"];
    
    TBPlacementRequest *parameters = [TBPlacementRequest new];
    parameters.name = @"article";
    parameters.recCount = 2;
    
    [self.recomendationRequest addPlacementRequest:parameters];
    
    __weak FeedViewController *weakSelf = self;
    [self.taboolaApi fetchRecommendations:self.recomendationRequest onSuccess:^(TBRecommendationResponse *response) {
        
        TBPlacement *placement = response.placements.firstObject;
        
        weakSelf.placement = placement;
        weakSelf.itemsArray = [placement.listOfItems mutableCopy];
        [weakSelf.tableView reloadData];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Taboola API: error fetching recommendations: \n%@", error.localizedDescription);
    }];
}

- (void)fetchNextPage {
    if (self.placement == nil) {
        return;
    }
    __weak FeedViewController *weakSelf = self;
    [self.taboolaApi getNextBatchForPlacement:self.placement itemsCount:3 onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        weakSelf.placement = placement;
        [weakSelf.itemsArray addObjectsFromArray:placement.listOfItems];
        [weakSelf.tableView reloadData];
    } onFailure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifier = @"FeedCell";
    FeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    TBItem *item = self.itemsArray[indexPath.row];
    [item initThumbnailView:cell.mainImageView];
    [item initTitleView:cell.titleView];
    [item initBrandingView:cell.brandingView];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.itemsArray.count - 1) {
        [self fetchNextPage];
    }
}

#pragma mark - Taboola API Click Delegate

- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
