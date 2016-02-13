//
//  THLink.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"

@class THMesh;
@class THEndpoint;

typedef enum {
	THLinkStatusPending,
	THLinkStatusReady,
	THLinkStatusEstablishing,
	THLinkStatusConnected,
	THLinkStatusError,
} THLinkStatus;

@interface THLink : NSObject

@property THEndpoint* endpoint;

@property THLinkStatus status;

@property NSMutableArray* pipes;

@property NSUInteger lastInboundActivity;
@property NSUInteger lastOutboundActivity;

+ (THLink *)initWithEndpoint:(THEndpoint *)endpoint;

- (void)generatePipesFromPaths:(NSArray *)paths;

- (void)establish;
- (void)sync;
- (void)handshake;
@end
