//
//  THTransportAssistant.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "THTransport.h"
#import "THTransportNetworkAdapter.h"
//#import "THTransportSerial.h"
//#import "THTransportMultipeerConnectivity.h"

extern NSString* const THTransportStateRefreshRequest;
extern NSString* const THTransportStateChangedNotification;


@interface THTransportAssistant : NSObject

@property NSMutableDictionary* allTransports;

- (NSArray*)getAllTransports;
@end
