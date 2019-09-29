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
#import <WebKit/WebKit.h>


@interface TableViewChangeScrollInFeedAuto () <TaboolaViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TaboolaView *taboolaView;
@property (nonatomic) NSUInteger taboolaSection;

@end

@implementation TableViewChangeScrollInFeedAuto

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _taboolaSection = 1;
    [self setupCollectionView];
    _taboolaView = [[TaboolaView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _taboolaView.delegate = self;
    _taboolaView.mode = @"thumbs-feed-01";
    _taboolaView.publisher = @"sdk-tester";
    _taboolaView.pageType = @"article";
    _taboolaView.pageUrl = @"http://www.example.com";
    _taboolaView.placement = @"Feed without video";
    _taboolaView.targetType = @"mix";
    _taboolaView.logLevel = LogLevelDebug;
    [_taboolaView setInterceptScroll:YES];
    [_taboolaView setProgressBarAnimationTime:0.7];
//    [_taboolaView setOptionalPageCommands:@{@"useOnlineTemplate":[NSNumber numberWithBool:YES]}];
    [_taboolaView fetchContent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 10, *)) {
        for (UIView *wView in _taboolaView.subviews) {
            if ([wView isKindOfClass:[WKWebView class]]) {
                [wView setNeedsLayout];
            }
        }
    }
    
}

- (void)setupCollectionView {
    [self.tableView registerNib:[UINib nibWithNibName:@"TaboolaTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaboolaTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"randomCell" bundle:nil] forCellReuseIdentifier:@"randomCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == _taboolaSection ? 1 : 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == _taboolaSection) {
        TaboolaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaboolaTableCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:cell];
        [cell.contentView addSubview:_taboolaView];
        [self setTaboolaConstraintsToSuper:cell.contentView];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"randomCellTable" forIndexPath:indexPath];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == _taboolaSection ? TaboolaView.widgetHeight : 200;
}


-(void)clearTaboolaInReusedCell:(TaboolaTableViewCell*)cell {
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
}


-(void)setTaboolaConstraintsToSuper:(UIView*)superView {
    CGRect tabooleRect = _taboolaView.frame;
    tabooleRect.size.width = self.view.frame.size.width;
    [_taboolaView setFrame:tabooleRect];
    _taboolaView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Trailing
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                   constraintWithItem:_taboolaView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:superView
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Leading
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:_taboolaView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:superView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Bottom
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:_taboolaView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:superView
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.f];
    
    
    //Top
    NSLayoutConstraint *top =[NSLayoutConstraint
                              constraintWithItem:_taboolaView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:superView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:0.f];
    
    //Add constraints to the Parent
    [superView addConstraint:trailing];
    [superView addConstraint:bottom];
    [superView addConstraint:leading];
    [superView addConstraint:top];
}


@end
