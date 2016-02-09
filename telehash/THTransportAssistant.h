//
//  THTransportAssistant.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import "ORSSerialPortManager.h"

#import "THLog.h"
#import "THTransport.h"
#import "THTransportNetworkAdapter.h"
#import "THTransportSerial.h"
#import "THTransportMultipeerConnectivity.h"

typedef enum {
	THHostIPv4Address,
	THHostIPv6Address,
	THHostHostname
} THHostType;

extern NSString* const THTransportStateRefreshRequest;
extern NSString* const THTransportStateChangedNotification;

extern NSString* const THTransportReachabilityStateChanged;


@interface THTransportAssistant : NSObject

@property NSMutableDictionary* allTransports;
@property BOOL suppressNotifications;

+ (THHostType)determineHostType:(NSString *)host;

- (void)refreshTransportState;
- (NSArray *)getAllTransports;
- (void)setupGlobalReachability;

@end
