//
//  THEndpoint.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THHashname.h"
#import "THURI.h"
#import "THLink.h"

typedef enum {
	THEndpointStatusPending,
	THEndpointStatusReady,
	THEndpointStatusConnected,
	THEndpointStatusError,
} THEndpointStatus;

@interface THEndpoint : NSObject

@property THHashname* localHashname;
@property THHashname* remoteHashname;

@property THEndpointStatus status;

@property THLink* establishedLink;
@property NSMutableArray* pipes;


+ (THEndpoint *)initWithLocalHashname:(THHashname *)localHashname;
+ (THEndpoint *)endpointFromJSON:(NSData *)json withLocalHashname:(THHashname *)localHashname;
+ (THEndpoint *)endpointFromURI:(THURI *)uri withLocalHashname:(THHashname *)localHashname;
@end
