//
//  THTransportNetworkAdapter.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THTransport.h"

@interface THTransportNetworkAdapter : THTransport

@property NSString* interfaceType;

@property NSString* IPv4Address;
@property NSString* IPv4Netmask;

@property NSString* IPv6Address;
@property NSString* IPv6Netmask;


- (BOOL)hasIPAddress;
- (NSDictionary*)description;
- (void)bindToPort:(uint16_t)port;


@end
