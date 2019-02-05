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
    
    [self fetchRecommendation];
}

- (void)checkForDuplicates {
    
    for (int i = 0; i <  self.itemsArray.count; i++) {
        TBItem * item1 = self.itemsArray[i];
        for (int j = i + 1; j < self.itemsArray.count; j++) {
            TBItem * item2 = self.itemsArray[j];
            if ([[item1 valueForKeyPath:@"model.name"] isEqualToString:[item2 valueForKeyPath:@"model.name"]]) {
                NSLog(@"DUPLICATES = YES");
                return;
            }
        }
    }
    NSLog(@"DUPLICATES = NO");
}

- (void)fetchRecommendation {
    self.recomendationRequest = [TBRecommendationRequest new];
    self.recomendationRequest.sourceType = TBSourceTypeText;
    [self.recomendationRequest setPageUrl: @"http://www.example.com"];
    
    TBPlacementRequest *parameters = [TBPlacementRequest new];
    parameters.name = @"article";
    parameters.recCount = 2;
    
    [self.recomendationRequest addPlacementRequest:parameters];
    
    [self.taboolaApi fetchRecommendations:self.recomendationRequest onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        self.placement = placement;
        _itemsArray = [placement.listOfItems mutableCopy];
        [self.tableView reloadData];
        [self checkForDuplicates];
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)fetchNextPage {
    if (self.placement == nil) {
        return;
    }
    [self.taboolaApi getNextBatchForPlacement:self.placement itemsCount:3 onSuccess:^(TBRecommendationResponse *response) {
        TBPlacement *placement = response.placements.firstObject;
        self.placement = placement;
        [_itemsArray addObjectsFromArray:placement.listOfItems];
        [self.tableView reloadData];
        [self checkForDuplicates];
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
    return [_itemsArray count]*3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBPlacementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placementCell" forIndexPath:indexPath];
    cell.tbImageView.image = nil;
    if (indexPath.row % 3 == 2) {
        TBItem *item = _itemsArray[(NSUInteger)indexPath.row / 3];
        [item initThumbnailView:cell.tbImageView];
        [item initTitleView:cell.titleView];
        [item initBrandingView:cell.brandingView];
    } else {
        cell.attributionButton.hidden = true;
        cell.titleView.text = @"Some intriguing heading";
        cell.tbImageView.image = [UIImage imageNamed:@"imageIcon"];
        cell.brandingView.text = @"Link to an amazing site";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.itemsArray.count - 1) {
        [self fetchNextPage];
    }
}

#pragma mark - TaboolaApiClickDelegate

- (BOOL)onItemClick:(NSString *)placemetName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
