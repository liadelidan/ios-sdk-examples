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
#import "Message.h"
#import "CollectionViewController.m"


@interface Connector () <NSStreamDelegate, ConnectorDelegate>

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
    
    _inputStream.delegate = self;
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}

-(void)joinConnection: (NSString*)publisherName{
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *stringData = [NSString stringWithFormat:@"UUID number - %@ with publisher-name - %@ is connected to the session\n", uuid, publisherName];
    
//    const char *dataUTF = [stringData UTF8String];
    self.publisherName = publisherName;
    
    NSData *data = [[NSData alloc] initWithData:[stringData dataUsingEncoding:NSASCIIStringEncoding]];
    
    [_outputStream write:[data bytes] maxLength:[data length]];
    
}

-(void)readAvailableBytes: (NSInputStream*)stream{
    if (stream == _inputStream) {
        int len;
        uint8_t buffer[1024];
        NSString* incoming_message = @"";
        while ([_inputStream hasBytesAvailable]) {
            len = (int)[_inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                [self processedMessageString:buffer length:len];
            }
        }
    }
}

-(void)processedMessageString: (uint8_t*)buffer length:(int)len{
    
//    NSString *mess = [[NSString alloc] initWithBytesNoCopy:buffer length:len encoding:NSUTF8StringEncoding freeWhenDone:TRUE];
//    NSString *incoming_message = [NSString stringWithFormat:@"%@%@",incoming_message,mess];
//
//    NSString *stringArrayinit = [[NSString alloc] initWithBytes:buffer
//                                                 length:len
//                                               encoding:NSUTF8StringEncoding];
    
    NSString *stringArrayinit = [[NSString alloc] initWithBytesNoCopy:buffer length:len encoding:NSUTF8StringEncoding freeWhenDone:TRUE];
    
    NSString *recieved = (NSString *)[stringArrayinit objectAtIndex:0];
    
    TaboolaView* taboolaObject = _delegate.getTaboolaObject;
    NSObject* parentView = _delegate.getParentObject;
    
    if stringArrayinit
}

-(void)stopSession{
    _inputStream.close;
    _outputStream.close;
}


#pragma mark - TaboolaViewDelegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)event{
    switch (event) {
        case NSStreamEventHasBytesAvailable:
            CFReadStreamHasBytesAvailable((_inputStream*)aStream);
        case NSStreamEventEndEncountered:
            stopSession
        case NSStreamEventErrorOccurred:
        
        case NSStreamEventHasSpaceAvailable:
            
        default:
            break;
    }
}

@end
