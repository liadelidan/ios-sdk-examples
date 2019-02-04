//
//  SingleTaboolaMidArticleCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/30/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "SingleTaboolaMidArticleCollectionViewController.h"
#import "TaboolaCollectionViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>

@interface SingleTaboolaMidArticleCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) TaboolaCollectionViewCell* taboolaCell;
@property (nonatomic) TaboolaView* taboolaView;
@end

@implementation SingleTaboolaMidArticleCollectionViewController {
    NSUInteger taboolaSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    taboolaSection = 1;
    [self setupCollectionView];
    
    self.taboolaView = [[TaboolaView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.taboolaView.delegate = self;
    self.taboolaView.mode = @"thumbnails-feed";
    self.taboolaView.publisher = @"betterbytheminute-app";
    self.taboolaView.pageType = @"article";
    self.taboolaView.pageUrl = @"http://www.example.com";
    self.taboolaView.placement = @"feed-sample-app";
    self.taboolaView.targetType = @"mix";
    [self.taboolaView setInterceptScroll:YES];
    self.taboolaView.logLevel = LogLevelDebug;
    [self.taboolaView fetchContent];
}

#pragma mark - Supporting functions
- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TaboolaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TaboolaCell"];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == taboolaSection ? 1 : 5;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == taboolaSection ? CGSizeMake(self.view.frame.size.width, TaboolaView.widgetHeight) : CGSizeMake(self.view.frame.size.width, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == taboolaSection) {
        if (!self.taboolaCell) {
            self.taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
            NSLog(@"before willMoveToSuperview");
            [self.taboolaCell.taboolaView addSubview:_taboolaView];
            NSLog(@"after willMoveToSuperview");
        }
        return self.taboolaCell;
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
