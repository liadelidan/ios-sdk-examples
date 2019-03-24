//
//  MidArticleCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/28/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "CollectionViewChangeScrollInFeedAuto.h"
#import "TaboolaCollectionViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>
#import "RandomColor.h"

@interface CollectionViewChangeScrollInFeedAuto () <UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) TaboolaView* taboolaWidget;
@property (nonatomic) TaboolaView* taboolaFeed;

@property (nonatomic) CGFloat taboolaWidgetHeight;

@end

typedef NS_ENUM(NSInteger, TaboolaSection) {
    TaboolaSectionMid = 1,
    TaboolaSectionFeed = 3
};

@implementation CollectionViewChangeScrollInFeedAuto

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _taboolaWidget = [self loadTaboolaWithMode:@"alternating-widget-without-video" placement:@"Below Article" scrollIntercept:NO];
    _taboolaFeed = [self loadTaboolaWithMode:@"thumbs-feed-01" placement:@"Feed without video" scrollIntercept:YES];
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *viewID = [NSString stringWithFormat:@"%d",timestamp];
    _taboolaWidget.viewID = viewID;
    _taboolaFeed.viewID = viewID;
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
    [taboolaView setOptionalPageCommands:@{@"useOnlineTemplate":[NSNumber numberWithBool:YES]}];
    [taboolaView fetchContent];
    return taboolaView;
}

-(void)dealloc {
    [_taboolaWidget reset];
    [_taboolaFeed reset];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == TaboolaSectionMid || section == TaboolaSectionFeed) ? 1 : 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TaboolaSectionMid) {
        if (_taboolaWidgetHeight > 0)
            return CGSizeMake(self.view.frame.size.width, _taboolaWidgetHeight);
        else
            return CGSizeMake(self.view.frame.size.width, 0);
    }
    else if (indexPath.section == TaboolaSectionFeed)
        return CGSizeMake(self.view.frame.size.width, TaboolaView.widgetHeight);
    else
        return CGSizeMake(self.view.frame.size.width, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TaboolaSectionMid) {
        TaboolaCollectionViewCell* taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:taboolaCell];
        [taboolaCell.taboolaContainer addSubview:_taboolaWidget];
        return taboolaCell;
    } else if (indexPath.section == TaboolaSectionFeed) {
        TaboolaCollectionViewCell* taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:taboolaCell];
        [taboolaCell.taboolaContainer addSubview:_taboolaFeed];
        return taboolaCell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"randomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [RandomColor setRandomColor];
        return cell;
    }
}

-(void)clearTaboolaInReusedCell:(TaboolaCollectionViewCell*)cell {
    for (UIView *view in [cell.taboolaContainer subviews]) {
        [view removeFromSuperview];
    }
}

#pragma mark - TaboolaViewDelegate

- (void)taboolaView:(UIView *)taboolaView didLoadPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    if ([placementName isEqualToString:@"Below Article"]) {
        _taboolaWidgetHeight = height;
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:TaboolaSectionMid]]];
    }
}

- (void)taboolaView:(UIView *)taboolaView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"%@", error);
}

-(BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return YES;
}


@end
