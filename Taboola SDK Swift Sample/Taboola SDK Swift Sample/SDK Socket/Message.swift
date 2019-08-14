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
    print("MESSAGE DETAILS")
    self.message = message.withoutWhitespace()
    print("MESSAGE IS: ")
    print(message.withoutWhitespace())
    self.messageSender = messageSender
    print("MESSAGE SENDER IS: ")
    print(messageSender)
    self.senderUsername = username
    print("MESSAGE USERNAME IS: ")
    print(username)
  }
}
