//
//  MidArticleCollectionViewController.m
//  Taboola SDK ObjC Samples
//
//  Created by Roman Slyepko on 1/28/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import "MidArticleCollectionViewController.h"
#import "TaboolaCollectionViewCell.h"
#import <TaboolaSDK/TaboolaSDK.h>
@interface MidArticleCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource, TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MidArticleCollectionViewController {
    NSUInteger taboolaSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taboolaSection = 1;
    [self setupCollectionView];
    
    // Do any additional setup after loading the view.
}

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == taboolaSection ? CGSizeMake(self.view.frame.size.width, TaboolaView.widgetHeight) : CGSizeMake(self.view.frame.size.width, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == taboolaSection) {
        TaboolaCollectionViewCell* taboolaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCell" forIndexPath:indexPath];
        if (taboolaCell.taboolaView.subviews.count)
            return taboolaCell;
        TaboolaView* taboolaView = [[TaboolaView alloc] initWithFrame:CGRectMake(0, 0, taboolaCell.frame.size.width, 200)];
        
        taboolaView.delegate = self;
        taboolaView.mode = @"thumbnails-feed";
        taboolaView.publisher = @"betterbytheminute-app";
        taboolaView.pageType = @"article";
        taboolaView.pageUrl = @"http://www.example.com";
        taboolaView.placement = @"feed-sample-app";
        taboolaView.targetType = @"mix";
        [taboolaView setInterceptScroll:YES];
        taboolaView.logLevel = LogLevelDebug;
        [taboolaView fetchContent];
        
        [taboolaCell.taboolaView addSubview:taboolaView];
        
        taboolaCell.taboolaView.translatesAutoresizingMaskIntoConstraints = NO;

        NSArray* horizConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[taboolaView]-0-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"taboolaView": taboolaView}];
        NSArray* vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[taboolaView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"taboolaView": taboolaView}] ;
        [taboolaCell.taboolaView addConstraints:horizConstraints];
        [taboolaCell.taboolaView addConstraints:vertConstraints];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
