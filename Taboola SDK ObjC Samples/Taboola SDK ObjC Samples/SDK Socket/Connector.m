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


@interface Connector () <NSStreamDelegate, ConnectorDelegateNew>

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
                
                Message *message = [self processedMessageString:buffer length:len];
                
                _delegate.received(message);
            }
        }
    }
}

-(Message*)processedMessageString:(uint8_t*)buffer length:(int)length{
    
    NSString *mess = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
    incoming_message = [NSString stringWithFormat:@"%@%@",incoming_message,mess];
    
    NSString *stringArrayinit = [[NSString alloc] initWithBytes:buffer->utf8text
                                                 length:length
                                               encoding:NSUTF8StringEncoding];
    
    NSString stringArrayinit = (bytesNoCopy:length:encoding:freeWhenDone:)
    
    NSString* stringArray = NSString(buffer,length,.UTF8Char,true).
    
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
