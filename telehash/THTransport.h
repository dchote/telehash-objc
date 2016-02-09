//
//  THTransport.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

#import "THLog.h"
#import "THPipe.h"
#import "THPath.h"


typedef enum {
	THTransportStatusStartup,
	THTransportStatusReady,
	THTransportStatusError
} THTransportStatus;


extern NSInteger const THTransportInitDelay;
extern NSInteger const THTransportTimeout;


@class THTransport;

@protocol THTransportDelegate <NSObject>
- (void)THTransportReady:(THTransport *)transport;
- (void)THTransportError:(THTransport *)transport error:(NSError *)error;
@end;


@interface THTransport : NSObject

@property id delegate;

@property BOOL active;
@property NSString* identifier;
@property NSString* name;
@property NSString* type;
@property THTransportStatus status;

@property (readonly) NSString* addressDescription;

@property int MTU;

@property NSArray* supportedPathTypes;
@property NSMutableArray* enabledPathTypes;

@property (nonatomic, readonly) NSArray* paths;
@property (nonatomic, readonly) NSDictionary* info;

- (void)shutdown;

- (THPipe *)pipeFromPath:(THPath *)path;
@end
