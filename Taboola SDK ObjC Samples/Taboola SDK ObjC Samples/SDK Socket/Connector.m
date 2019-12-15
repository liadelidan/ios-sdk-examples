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
                NSString *mess = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                incoming_message = [NSString stringWithFormat:@"%@%@",incoming_message,mess];
                
                processedMessageString(buffer,len);

                _delegate.received(incoming_message);
            }
        }
    }
}

-(Message)processedMessageString:(uint8_t*)buffer (int)length{
    
    
    NSString *stringArrayinit = [[NSString alloc] initWithBytes:buffer->utf8text
                                                 length:length
                                               encoding:NSUTF8StringEncoding];
    
    NSString *stringArrayinit = init

    
    NSString stringArrayinit = (bytesNoCopy:length:encoding:freeWhenDone:)
    
    NSString* stringArray = NSString(buffer,length,.UTF8Char,true)
    
     let stringArray = String(
        bytesNoCopy: buffer,
        length: length,
        encoding: .utf8,
        freeWhenDone: true)?.components(separatedBy: ":"),
    var recieved = stringArray.first
    else {
        return nil
    }
}
    
    
//        recieved = String(recieved.filter { !" \n\t\r".contains($0) })
    taboolaObject = self.delegate?.getTaboolaObject()
    parentView = self.delegate?.getParentObject()
        if recieved.contains("showinfo")
        {
            let mnemonic: [String] =  [taboolaObject.publisher,taboolaObject.mode,taboolaObject.placement,taboolaObject.pageType,taboolaObject.pageUrl,taboolaObject.targetType]
            var myJsonString = ""
            do {
                let data =  try JSONSerialization.data(withJSONObject:mnemonic, options: .prettyPrinted)
                myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            } catch {
                print(error.localizedDescription)
            }

            send(message: myJsonString)
        }
        else if recieved.contains("showheights")
        {
            let taboolaWidth = taboolaObject.bounds.size.width.self
            let taboolaHeight = taboolaObject.bounds.size.height.self
            
            send(message: "The width of the widget is:  \(taboolaWidth) The height of the widget is:  \(taboolaHeight)")

        }
        else if recieved.contains("updatepublisher-")
        {
            taboolaObject.publisher = recieved.replacingOccurrences(of: "updatepublisher-", with: "")
            send(message: "Changed publisher name")
        }
        else if recieved.contains("refresh")
        {
            taboolaObject.fetchContent()
            taboolaObject.fetchContent()
            let uuid = UUID().uuidString

            let data = "Refreshed the WebView content of iPhone with UUID number: \(uuid)"
            send(message: data)
        }
        else if recieved.contains("updatewidget-")
        {
            taboolaObject.mode = recieved.replacingOccurrences(of: "updatewidget-", with: "")
            send(message: "Changed widget")
        }
        else if recieved.contains("updateplacement-")
        {
            taboolaObject.placement = recieved.replacingOccurrences(of: "updateplacement-", with: "")
            send(message: "Changed placement")
        }
        else if recieved.contains("updatepageurl-")
        {
            taboolaObject.pageUrl = recieved.replacingOccurrences(of: "updatepageurl-", with: "")
            send(message: "Changed page url")
        }
        else if recieved.contains("updatepagetype-")
        {
            taboolaObject.pageType = recieved.replacingOccurrences(of: "updatepagetype-", with: "")
            send(message: "Changed page type")
        }
        else if recieved.contains("updatetargettype-")
        {
            taboolaObject.targetType = recieved.replacingOccurrences(of: "updatetargettype-", with: "")
            send(message: "Changed target type")
        }
        else if recieved.contains("parentview")
        {
            taboolaObject.targetType = recieved.replacingOccurrences(of: "parentview", with: "")
            print(parentView.description)
            send(message: (parentView.description))
        }

    return Message(message: stringArray)
}

#pragma mark - TaboolaViewDelegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)event{
    switch (event) {
        case NSStreamEventHasBytesAvailable:
             NSInputStream
            break;
            
        default:
            break;
    }
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

@end
