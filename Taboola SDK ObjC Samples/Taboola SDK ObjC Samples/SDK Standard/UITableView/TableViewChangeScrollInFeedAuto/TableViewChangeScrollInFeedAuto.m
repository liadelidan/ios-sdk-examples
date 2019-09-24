//
//  TableViewChangeScrollInFeedAuto.m
//  Taboola SDK ObjC Samples
//
//  Created by Liad Elidan on 22/09/2019.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "TableViewChangeScrollInFeedAuto.h"
#import "TaboolaTableViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>
#import "RandomColor.h"

@interface TableViewChangeScrollInFeedAuto () <UITableViewDelegate,UITableViewDataSource, TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) TaboolaView* taboolaWidget;
@property (nonatomic) TaboolaView* taboolaFeed;

@property (nonatomic) CGFloat taboolaWidgetHeight;

@property (nonatomic, strong) NSString *viewId;

@property (nonatomic) BOOL didLoadFeed;

@end

typedef NS_ENUM(NSInteger, TaboolaSection) {
    TaboolaSectionMid = 1,
    TaboolaSectionFeed = 3
};

@implementation TableViewChangeScrollInFeedAuto

- (void)viewDidLoad {
    [super viewDidLoad];
    int timestamp = [[NSDate date] timeIntervalSince1970];
    _viewId = [NSString stringWithFormat:@"%d",timestamp];
    _taboolaWidget = [self loadTaboolaWithMode:@"alternating-widget-without-video" placement:@"Below Article" scrollIntercept:NO];
    _taboolaFeed = [self loadTaboolaWithMode:@"thumbs-feed-01" placement:@"Feed without video" scrollIntercept:YES];
    
    [_taboolaWidget fetchContent];
}

- (TaboolaView*)loadTaboolaWithMode:(NSString*)mode placement:(NSString*)placement scrollIntercept:(BOOL)scrollIntercept {
    TaboolaView *taboolaView = [[TaboolaView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    taboolaView.delegate = self;
    taboolaView.mode = mode;
    taboolaView.publisher = @"sdk-tester";
    taboolaView.pageType = @"article";
    taboolaView.pageUrl = @"http://www.example.com";
    taboolaView.placement = placement;
    taboolaView.targetType = @"mix";
    [taboolaView setInterceptScroll:scrollIntercept];
    taboolaView.logLevel = LogLevelDebug;
    taboolaView.viewID = _viewId;
    return taboolaView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4){
        return _taboolaWidgetHeight;
    }
    else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == TaboolaSectionMid) {
        TaboolaTableViewCell *cell = [tableView dequeueReusableCellWithReuseIdentifier:@"MyIdentifier"];

        TaboolaTableViewCell* taboolaCell = [tableView dequeueReusableCellWithReuseIdentifier:@"TaboolaTableCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:taboolaCell];
        return taboolaCell;

    } else if (indexPath.section == TaboolaSectionFeed) {
        TaboolaTableViewCell* taboolaCell = [tableView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:taboolaCell];
        [taboolaCell.contentView addSubview:_taboolaFeed];
        return taboolaCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithReuseIdentifier:@"randomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [RandomColor setRandomColor];
        return cell;
    }
}

-(void)clearTaboolaInReusedCell:(TaboolaTableViewCell*)cell {
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
}

-(void)dealloc {
    [_taboolaWidget reset];
    [_taboolaFeed reset];
}

#pragma mark - TaboolaViewDelegate

- (void)taboolaView:(UIView *)taboolaView didLoadPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    if ([placementName isEqualToString:@"Below Article"]) {
        _taboolaWidgetHeight = height;
        [self.tableView.setNeedsLayout];
        [myView setNeedsLayout];
        if (!_didLoadFeed) {
            _didLoadFeed = YES;
            // We are loading the feed only when the widget finished loading- for dedup.
            [_taboolaFeed fetchContent];
        }
    }
}

- (void)taboolaView:(UIView *)taboolaView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"%@", error);
}

-(BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return YES;
}

@end

