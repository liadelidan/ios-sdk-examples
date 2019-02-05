//
//  InfiniteTableViewController.m
//  EndlessFeedExample
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import "InfiniteTableViewController.h"
#import "TBPlacementTableViewCell.h"

@interface InfiniteTableViewController () <TaboolaApiClickDelegate>

@property (nonatomic) TaboolaApi *taboolaApi;
@property (nonatomic) TBRecommendationRequest *recomendationRequest;
@property (nonatomic) NSMutableArray *itemsArray;
@property (nonatomic) TBPlacement *placement;

@end

@implementation InfiniteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsArray = [NSMutableArray new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 298.0;
    
    self.taboolaApi = [TaboolaApi sharedInstance];
    self.taboolaApi.clickDelegate = self;
    [self.taboolaApi setExtraPropetries:@{@"enabledRawDataResponse":[NSNumber numberWithBool:YES]}];
    
    [self fetchRecommendation];
}

- (void)fetchRecommendation {
    self.recomendationRequest = [TBRecommendationRequest new];
    self.recomendationRequest.sourceType = TBSourceTypeText;
    [self.recomendationRequest setPageUrl:@"http://www.golf.lefigaro.fr/"];
    
    TBPlacementRequest *parameters = [TBPlacementRequest new];
    [parameters setThumbnailSize:CGSizeMake(400,300)];
    parameters.name = @"Below Article App Feed Thumbnails X";
    parameters.recCount = 10;
    
    [self.recomendationRequest addPlacementRequest:parameters];
    
    [self.taboolaApi fetchRecommendations:self.recomendationRequest onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        self.placement = placement;
        _itemsArray = [placement.listOfItems mutableCopy];
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)fetchNextPage {
    if (self.placement == nil) {
        return;
    }
    [self.taboolaApi getNextBatchForPlacement:self.placement itemsCount:10 onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        self.placement = placement;
        [_itemsArray addObjectsFromArray:placement.listOfItems];
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TBPlacementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placementCell" forIndexPath:indexPath];
    cell.tbImageView.image = nil;
    TBItem *item = _itemsArray[indexPath.row];
    NSLog(@"row data: %@",item.extraDataDictionary);
    [item initThumbnailView:cell.tbImageView];
    [item initTitleView:cell.titleView];
    [item initBrandingView:cell.brandingView];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.itemsArray.count - 1) {
//        [self fetchNextPage];
//    }
}

#pragma mark - TaboolaApiClickDelegate

- (BOOL)onItemClick:(NSString *)placemetName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
