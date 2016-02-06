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
#import "THTransportAssistant.h"

@class THMesh;

typedef enum {
	THEndpointStatusPending,
	THEndpointStatusReady,
	THEndpointStatusConnected,
	THEndpointStatusError,
} THEndpointStatus;

@interface THEndpoint : NSObject

@property (weak) THMesh* mesh;

@property THHashname* remoteHashname;

@property THEndpointStatus status;

@property THLink* establishedLink;
@property NSMutableArray* pipes;


+ (THEndpoint *)initWithMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromFile:(NSString *)filePath withMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromJSON:(NSData *)json withMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromURI:(THURI *)uri withMesh:(THMesh *)mesh;

- (void)generatePipesFromPaths:(NSArray *)paths;
@end
