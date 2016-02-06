//
//  THPipe.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THPath.h"
#import "THLink.h"

@class THTransport;

typedef enum {
	THPipeStatusDown,
	THPipeStatusUp,
	THPipeStatusError
} THPipeStatus;

@interface THPipe : NSObject

@property NSString* type;
@property NSUInteger keepalive;

@property BOOL cloaked;

@property (retain) THPath* path;
@property (weak) THLink* link;
@property (weak) THTransport* transport;

@property THPipeStatus status;

@property (readonly) NSDictionary* info;

@property NSUInteger lastInboundActivity;
@property NSUInteger lastOutboundActivity;


- (void)send:(NSData *)data;
- (void)recieved:(NSData *)data;
- (void)close;
@end
