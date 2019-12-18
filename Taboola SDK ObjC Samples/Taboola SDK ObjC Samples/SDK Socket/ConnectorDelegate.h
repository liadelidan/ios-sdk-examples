//
//  ConnectorDelegate.h
//  Taboola SDK ObjC Samples
//
//  Created by Liad Elidan on 11/12/2019.
//  Copyright © 2019 Taboola. All rights reserved.
//

#import <TaboolaSDK/TaboolaSDK.h>
#import "Message.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ConnectorDelegate <NSObject>
    
@required
-(TaboolaView*)getTaboolaObject;
-(NSObject*)getParentObject;
@end

NS_ASSUME_NONNULL_END
