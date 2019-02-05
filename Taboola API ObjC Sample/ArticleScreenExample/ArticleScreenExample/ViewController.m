//
//  ViewController.m
//  ArticleScreenExample
//
//  Created by Vasyl Human on 8/3/17.
//  Copyright © 2017 Vasyl Human. All rights reserved.
//

#import "ViewController.h"
#import "TBItemTableViewCell.h"

@interface ViewController () <TaboolaApiClickDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) TaboolaApi *taboolaApi;
@property (nonatomic) TBRecommendationRequest *recomendationRequest;
@property (nonatomic) TBPlacement *placement;
@property (nonatomic) NSMutableArray *itemsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TBItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewIdentifier"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300.0;
    
    self.itemsArray = [NSMutableArray new];
    
    self.taboolaApi = [TaboolaApi sharedInstance];
    self.taboolaApi.clickDelegate = self;
    
    [self fetchRecommendation];
}

- (void)fetchRecommendation {
    
    self.recomendationRequest = [TBRecommendationRequest new];
    self.recomendationRequest.sourceType = TBSourceTypeText;
    [self.recomendationRequest setPageUrl:@"http://www.example.com"];
    
    TBPlacementRequest *parameters = [TBPlacementRequest new];
    parameters.name = @"article";
    parameters.recCount = 4;
    
    [self.recomendationRequest addPlacementRequest:parameters];
    
    [self.taboolaApi fetchRecommendations:self.recomendationRequest onSuccess:^(TBRecommendationResponse *response) {
        
        TBPlacement *placement = response.placements.firstObject;
        
        self.placement = placement;
        _itemsArray = [placement.listOfItems mutableCopy];
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Something went wrong");
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TBItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tableViewIdentifier"];
        
    TBItem *item = _itemsArray[indexPath.row];
    [item initThumbnailView:cell.tbImageView];
    [item initTitleView:cell.titleView];
    [item initBrandingView:cell.brandingView];
    
    return cell;
}

#pragma mark - TaboolaApiClickDelegate

- (BOOL)onItemClick:(NSString *)placemetName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return false;
}

@end
