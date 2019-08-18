//
//  Connector.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 14/08/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import Foundation

struct Message {
  let message: String
  let senderUsername: String
  let messageSender: MessageSender
  
  init(message: String, messageSender: MessageSender, publisherName: String) {
    self.message = message.withoutWhitespace()
    print("Widget is: ", terminator:"")
    if self.message == "" {
        print("alternating-widget-without-video")
    }
    else
    {
        print(message.withoutWhitespace())
    }
    self.messageSender = messageSender
    print("The message sender is: ", terminator:"")
    print(messageSender)
    self.senderUsername = publisherName
    print("The publisher is: ", terminator:"")
    print(publisherName)
  }
}
