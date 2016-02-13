//
//  THPacket.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"


@interface THPacket : NSObject

@property NSData* raw;

@property NSMutableDictionary* json;
@property unsigned short jsonLength;
@property NSData* body;

+ (THPacket *)packetWithJSON:(NSMutableDictionary *)json;
+ (THPacket *)packetFromData:(NSData *)data;

- (NSData *)encode;
@end
