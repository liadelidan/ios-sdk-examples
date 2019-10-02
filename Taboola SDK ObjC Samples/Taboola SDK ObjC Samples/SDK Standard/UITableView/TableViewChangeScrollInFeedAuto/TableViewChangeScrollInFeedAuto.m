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


@interface TableViewChangeScrollInFeedAuto () <TaboolaViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TaboolaView *taboolaView;
@property (nonatomic) NSUInteger taboolaSection;

@end

@implementation TableViewChangeScrollInFeedAuto

- (void)viewDidLoad {
    [super viewDidLoad];
    _taboolaSection = 1;
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
    [_taboolaView setOptionalPageCommands:@{@"useOnlineTemplate":[NSNumber numberWithBool:YES]}];
    [_taboolaView fetchContent];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == _taboolaSection ? 1 : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == _taboolaSection) {
        TaboolaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaboolaTableCell" forIndexPath:indexPath];
        [self clearTaboolaInReusedCell:cell];
        [cell.contentView addSubview:_taboolaView];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"randomCellTable" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [RandomColor setRandomColor];
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

@end
