//
//  MidArticleCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/28/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "MidArticleCollectionViewController.h"
#import "TaboolaCollectionViewCell.h"
#import "TaboolaCollectionCell.h"
#import <TaboolaSDK/TaboolaSDK.h>
@interface MidArticleCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MidArticleCollectionViewController {
    NSUInteger midTaboolaSection;
    NSUInteger feedTaboolaSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    midTaboolaSection = 1;
    feedTaboolaSection = 3;
    [self setupCollectionView];
}

- (void)setupCollectionView {
//    [self.collectionView registerClass:NSClassFromString( @"TaboolaCollectionCell") forCellWithReuseIdentifier:@"TaboolaCell"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"TaboolaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TaboolaCell"];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == midTaboolaSection || section == feedTaboolaSection) ? 1 : 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == midTaboolaSection)
        return CGSizeMake(self.view.frame.size.width, 250);
    else if (indexPath.section == feedTaboolaSection)
        return CGSizeMake(self.view.frame.size.width, TaboolaView.widgetHeight);
    else
        return CGSizeMake(self.view.frame.size.width, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == midTaboolaSection) {
        TaboolaCollectionCell* taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        taboolaCell.taboolaView.delegate = self;
        taboolaCell.taboolaView.publisher = @"sdk-tester";
        taboolaCell.taboolaView.mode = @"alternating-widget-without-video-1-on-1";
        taboolaCell.taboolaView.pageType = @"article";
        taboolaCell.taboolaView.pageUrl = @"http://www.example.com";
        taboolaCell.taboolaView.placement = @"Mid Article";
        taboolaCell.taboolaView.targetType = @"mix";
        taboolaCell.taboolaView.autoResizeHeight = YES;
        taboolaCell.taboolaView.logLevel = LogLevelDebug;
        [taboolaCell.taboolaView fetchContent];
        return taboolaCell;
    } else if (indexPath.section == feedTaboolaSection) {
        TaboolaCollectionCell* taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        taboolaCell.taboolaView.delegate = self;
        taboolaCell.taboolaView.publisher = @"sdk-tester";
        taboolaCell.taboolaView.mode = @"thumbs-feed-01";
        taboolaCell.taboolaView.pageType = @"article";
        taboolaCell.taboolaView.pageUrl = @"http://www.example.com";
        taboolaCell.taboolaView.placement = @"Feed without video";
        taboolaCell.taboolaView.targetType = @"mix";
        [taboolaCell.taboolaView setInterceptScroll:YES];
        taboolaCell.taboolaView.logLevel = LogLevelDebug;
        [taboolaCell.taboolaView fetchContent];
        return taboolaCell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"randomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [self randomColor];
        return cell;
    }
}

- (UIColor*)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

- (void)taboolaView:(UIView *)taboolaView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"%@", error);
}

@end
