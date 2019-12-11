//
//  Connector.m
//  Taboola SDK ObjC Samples
//
//  Created by Liad Elidan on 11/12/2019.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import <TaboolaSDK/TaboolaSDK.h>
#import "CollectionViewController.h"
#import "TaboolaCollectionViewCell.h"
#import "Connector.h"
#import "ConnectorDelegate.h"

@interface Connector () <ConnectorDelegate>

@property (nonatomic) TaboolaView* taboolaObject;

@property (nonatomic) int maxReadLength;

@property (nonatomic) NSString* publisherName;

@property (nonatomic) NSObject* parentView;

@property (nonatomic) id<ConnectorDelegate> delegate;

@property (nonatomic) NSInputStream* InputStream;

@property (nonatomic) NSOutputStream* OutputStream;

@end

#pragma mark - TaboolaViewDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)event;

- (void)taboolaView:(UIView *)taboolaView didLoadPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    if ([placementName isEqualToString:@"Below Article"]) {
        _taboolaWidgetHeight = height;
        [self.collectionView.collectionViewLayout invalidateLayout];
        if (!_didLoadFeed) {
            _didLoadFeed = YES;
            // We are loading the feed only when the widget finished loading- for dedup.
            [_taboolaFeed fetchContent];
        }
    }
}

extension Connector: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            print("stopping chat session")
            stopSession()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
}
