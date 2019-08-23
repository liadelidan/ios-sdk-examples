//
//  Connector.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 14/08/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import TaboolaSDK
import Foundation
import UIKit

protocol ConnectorDelegate: class {
    func getTaboolaObject() -> TaboolaView
    func received(message: Message)
}

class Connector: NSObject {
    
    var taboolaObject: TaboolaView!

    weak var delegate: ConnectorDelegate?
    
    //1
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    //2
    var publisherName = ""
    
    var widgetName = "alternating-widget-without-video"
    //3
    let maxReadLength = 4096
    
    func setupNetworkCommunication() {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
//        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
//                                           "localhost" as CFString,
//                                           80,
//                                           &readStream,
//                                           &writeStream)
        var addr = getWiFiAddress()!
        print(addr)
        addr = "10.0.0.2"
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           addr as CFString,
                                           8080,
                                           &readStream,
                                           &writeStream)
        
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func joinConnection(publisherName: String) {
        //1
        let data = "iam:\(publisherName)".data(using: .utf8)!
        
        //2        
        self.publisherName = publisherName
        
        //3
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            //4
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        //2
        while stream.hasBytesAvailable {
            //3
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            //4
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            
            // Construct the Message object
            if let message =
                processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                // Notify interested parties
                delegate?.received(message: message)
            }
            
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> Message? {
        //1
        guard
             let stringArray = String(
                bytesNoCopy: buffer,
                length: length,
                encoding: .utf8,
                freeWhenDone: true)?.components(separatedBy: ":"),
            let recieved = stringArray.first
            else {
                return nil
        }
            if recieved.contains("showinfo")
            {
                taboolaObject = self.delegate?.getTaboolaObject()
                send(message: taboolaObject.publisher)
            }
            else if recieved.contains("updatepublisher-")
            {
                taboolaObject = self.delegate?.getTaboolaObject()
                taboolaObject.publisher = recieved.replacingOccurrences(of: "updatepublisher-", with: "")
                send(message: "Changed")
        }
            else if recieved.contains("refresh")
            {
                taboolaObject = self.delegate?.getTaboolaObject()
                taboolaObject.fetchContent()
                send(message: "Refreshed")
        }
        
        //3
        return Message(message: stringArray)
    }
    
    func send(message: String) {
        let data = "msg:\(message)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
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
            stopChatSession()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
}
