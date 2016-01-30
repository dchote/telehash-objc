//
//  THTransport.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

#import "THLog.h"

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

@property int MTU;


- (void)shutdown;
- (NSDictionary *)description;
@end
