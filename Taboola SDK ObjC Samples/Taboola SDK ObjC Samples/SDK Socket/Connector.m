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

@interface Connector () <ConnectorDelegate, NSStreamDelegate>

@property (nonatomic) TaboolaView* taboolaObject;

@property (nonatomic) int maxReadLength;

@property (nonatomic) NSString* publisherName;

@property (nonatomic) NSObject* parentView;

@property (nonatomic) id<ConnectorDelegate> delegate;

@property (nonatomic, retain) NSInputStream *inputStream;

@property (nonatomic, retain) NSOutputStream *outputStream;

@end


@implementation Connector

-(void)setupNetworkCommunicatio{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;

    NSString *addr = @"ps001.taboolasyndication.com";
    //        addr = "localhost"
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)(addr), 9090, &readStream, &writeStream);

    _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);

    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}

#pragma mark - TaboolaViewDelegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)event{
    
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

@end
