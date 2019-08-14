//
//  Connector.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 14/08/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

enum MessageSender {
  case ourself
  case someoneElse
}

class MessageTableViewCell: UITableViewCell {
  var messageSender: MessageSender = .ourself
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
