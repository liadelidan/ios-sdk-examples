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
  
  init(message: String, messageSender: MessageSender, username: String) {
    self.message = message.withoutWhitespace()
    print("Message is: ", terminator:"")
    print(message.withoutWhitespace())
    self.messageSender = messageSender
    print("Message sender is: ", terminator:"")
    print(messageSender)
    self.senderUsername = username
    print("Message publisher is: ", terminator:"")
    print(username)
  }
}
