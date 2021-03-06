//
//  THTransportNetworkAdapter.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THTransport.h"

@interface THTransportNetworkAdapter : THTransport <GCDAsyncUdpSocketDelegate>

@property NSString* interfaceType;

@property NSString* IPv4Address;
@property NSString* IPv4Netmask;

@property NSString* IPv6Address;
@property NSString* IPv6Netmask;

@property uint16_t udpListenPort;
@property uint16_t tcpListenPort;


@property NSMutableArray* pipes;



- (BOOL)hasIPAddress;
- (void)bindToPort:(uint16_t)port;


@end
