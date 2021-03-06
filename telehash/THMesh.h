//
//  THMesh.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THEndpoint.h"
#import "THHashname.h"
#import "THURI.h"
#import "THMeshConfiguration.h"
#import "THTransportAssistant.h"
#import "THTransport.h"

extern NSString* const THMeshStateChange;

@class THMesh;

typedef enum {
	THMeshStatusStartup,
	THMeshStatusReady,
	THMeshStatusError
} THMeshStatus;


@protocol THMeshDelegate <NSObject>
- (void)THMeshReady:(THMesh *)mesh;
- (void)THMeshError:(THMesh *)mesh error:(NSError *)error;
@end;




@interface THMesh : NSObject <THTransportDelegate>

@property id delegate;
@property THMeshStatus status;


@property THMeshConfiguration* config;
@property THHashname* localHashname;
@property THTransportAssistant* transportAssistant;
@property NSMutableArray* transports;
@property NSMutableArray* activeTransports;

@property NSMutableDictionary* endpoints;


- (void)bootstrapWithConfig:(THMeshConfiguration *)config;
- (void)evaluateTransports;
- (void)shutdown;
- (void)establishRouterLinks;
@end
