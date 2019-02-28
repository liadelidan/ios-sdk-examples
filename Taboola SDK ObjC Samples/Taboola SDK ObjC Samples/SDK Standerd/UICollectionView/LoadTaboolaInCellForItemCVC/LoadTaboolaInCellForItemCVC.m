//
//  SingleTaboolaMidArticleCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/30/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "LoadTaboolaInCellForItemCVC.h"
#import "TaboolaViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>
#import "RandomColor.h"

@interface LoadTaboolaInCellForItemCVC () <UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) TaboolaViewCell* taboolaMidViewCell;
@property (nonatomic) TaboolaViewCell* taboolaBelowViewCell;

@property (nonatomic) CGFloat taboolaMidHeight;
@property (nonatomic) CGFloat taboolaBelowHeight;

@end

typedef NS_ENUM(NSInteger, TaboolaSection) {
    TaboolaSectionMid = 1,
    TaboolaSectionBelow = 3
};

@implementation LoadTaboolaInCellForItemCVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadMidTaboola {
    _taboolaMidViewCell.taboolaView.delegate = self;
    _taboolaMidViewCell.taboolaView.mode = @"alternating-1x2-widget";
    _taboolaMidViewCell.taboolaView.publisher = @"sdk-tester";
    _taboolaMidViewCell.taboolaView.pageType = @"article";
    _taboolaMidViewCell.taboolaView.pageUrl = @"http://www.example.com";
    _taboolaMidViewCell.taboolaView.placement = @"Mid Article";
    _taboolaMidViewCell.taboolaView.targetType = @"mix";
    _taboolaMidViewCell.taboolaView.logLevel = LogLevelDebug;
    [_taboolaMidViewCell.taboolaView setOptionalPageCommands:@{@"useOnlineTemplate":[NSNumber numberWithBool:YES]}];
    [_taboolaMidViewCell.taboolaView fetchContent];
}

-(void)loadBelowTaboola {
    _taboolaBelowViewCell.taboolaView.delegate = self;
    _taboolaBelowViewCell.taboolaView.mode = @"alternating-widget-without-video";
    _taboolaBelowViewCell.taboolaView.publisher = @"sdk-tester";
    _taboolaBelowViewCell.taboolaView.pageType = @"article";
    _taboolaBelowViewCell.taboolaView.pageUrl = @"http://www.example.com";
    _taboolaBelowViewCell.taboolaView.placement = @"Below Article";
    _taboolaBelowViewCell.taboolaView.targetType = @"mix";
    _taboolaBelowViewCell.taboolaView.logLevel = LogLevelDebug;
    [_taboolaBelowViewCell.taboolaView setOptionalPageCommands:@{@"useOnlineTemplate":[NSNumber numberWithBool:YES]}];
    [_taboolaBelowViewCell.taboolaView fetchContent];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == TaboolaSectionMid || section == TaboolaSectionBelow) ? 1 : 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TaboolaSectionMid && _taboolaMidHeight > 0)
        return CGSizeMake(self.view.frame.size.width, _taboolaMidHeight);
    else if (indexPath.section == TaboolaSectionBelow && _taboolaBelowHeight > 0)
        return CGSizeMake(self.view.frame.size.width, _taboolaBelowHeight);
    else
        return CGSizeMake(self.view.frame.size.width, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TaboolaSectionMid) {
        TaboolaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        if (!_taboolaMidViewCell) {
            _taboolaMidViewCell = cell;
            [self loadMidTaboola];
        }
        cell.taboolaView = _taboolaMidViewCell.taboolaView;
        return cell;
    } else if (indexPath.section == TaboolaSectionBelow) {
        TaboolaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        if (!_taboolaBelowViewCell) {
            _taboolaBelowViewCell = cell;
            [self loadBelowTaboola];
        }
        cell.taboolaView = _taboolaBelowViewCell.taboolaView;
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"randomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [RandomColor setRandomColor];
        return cell;
    }
}

#pragma mark - TaboolaViewDelegate

- (void)taboolaView:(UIView *)taboolaView didLoadPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    if ([placementName isEqualToString:@"Mid Article"]) {
        _taboolaMidHeight = height;
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:TaboolaSectionMid]]];
    } else if ([placementName isEqualToString:@"Below Article"]) {
            _taboolaBelowHeight = height;
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:TaboolaSectionBelow]]];
    }
}

- (void)taboolaView:(UIView *)taboolaView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"%@", error);
}

-(BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return YES;
}

@end
