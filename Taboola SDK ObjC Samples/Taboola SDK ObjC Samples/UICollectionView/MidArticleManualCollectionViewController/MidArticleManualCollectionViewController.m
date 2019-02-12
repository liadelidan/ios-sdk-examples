//
//  MidArticleManualCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 2/4/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "MidArticleManualCollectionViewController.h"
#import "TaboolaCollectionCell.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface MidArticleManualCollectionViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MidArticleManualCollectionViewController {
    NSUInteger midTaboolaSection;
    NSUInteger feedTaboolaSection;
    TaboolaView* feedTaboolaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView.delegate = self;
    midTaboolaSection = 1;
    feedTaboolaSection = 3;
    
    [self setupCollectionView];
    
    // Do any additional setup after loading the view.
}

- (void)setupCollectionView {
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
        return CGSizeMake(self.view.frame.size.width, 300);
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
        
        [taboolaCell.taboolaView setOverrideScrollIntercept:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll! %f",scrollView.contentOffset.y);
    [self didEndScrollOfParentScroll];
}

-(BOOL)didEndScrollOfParentScroll {
    float h = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    float inset = 0;
    if (@available(iOS 11.0, *)) {
        inset = self.collectionView.adjustedContentInset.bottom;
    } else {
        inset = self.collectionView.contentInset.bottom;
    }
    float y = self.collectionView.contentOffset.y - inset;
    if (h <= y && self.collectionView.scrollEnabled && self.collectionView.contentSize.height > TaboolaView.widgetHeight) {
        NSLog(@"did finish scrolling");
        [feedTaboolaView setScrollEnable:YES];
        self.collectionView.scrollEnabled = NO;
        return YES;
    }
    return NO;
}

- (void)scrollViewDidScrollToTopTaboolaView:(UIView*)taboolaView {
    if (feedTaboolaView.scrollEnable) {
        NSLog(@"did finish scrolling taboola");
        [feedTaboolaView setScrollEnable:NO];
        self.collectionView.scrollEnabled = YES;
    }
    
}

@end
