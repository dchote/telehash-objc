//
//  THPacket.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THPacket.h"

@implementation THPacket

- (id)init {
	self = [super init];
	
	self.json = [NSMutableDictionary dictionary];
	
	return self;
}

+ (THPacket *)packetWithJSON:(NSMutableDictionary *)json {
	THPacket* packet = [[THPacket alloc] init];
	
	packet.json = json;
	
	return packet;
}

+ (THPacket *)packetFromData:(NSData *)data {
	unsigned short jsonLength;
	[data getBytes:&jsonLength length:sizeof(short)];
	jsonLength = ntohs(jsonLength);
	
	if (jsonLength > data.length) {
		THLogErrorMessage(@"invalid json header length");
		return nil;
	}
	
	if (data.length == 0 || (data.length == 2 && jsonLength == 0)) {
		THLogDebugMessage(@"ignoring keepalive packet");
		return nil;
	}
	
	NSError* error;
	NSMutableDictionary* jsonDictionary;
	
	if (jsonLength >= 2) {
		jsonDictionary = [NSJSONSerialization JSONObjectWithData:[data subdataWithRange:NSMakeRange(2, jsonLength)] options:0 error:&error];
		if (jsonDictionary == nil || ![jsonDictionary isKindOfClass:[NSDictionary class]]) {
			THLogErrorMessage(@"json parse error: %@", [error localizedDescription]);
			return nil;
		}
	}
	
	THPacket* packet = [[THPacket alloc] init];
	
	packet.raw = data;
	packet.json = jsonDictionary;
	
	if (jsonLength == 1) --jsonLength;
	
	packet.body = [data subdataWithRange:NSMakeRange(2 + jsonLength, (data.length - jsonLength - 2))];
	
	return packet;
}

- (NSData *)encode {
	NSError* error;
	NSData* encodedJSON;
	
	if (self.json.count > 0) {
		encodedJSON = [NSJSONSerialization dataWithJSONObject:self.json options:0 error:&error];
	}
	
	unsigned short totalLength = encodedJSON.length + self.body.length + 2;
	NSMutableData* data = [NSMutableData dataWithCapacity:totalLength];
	
	totalLength = htons(MAX(encodedJSON.length, self.jsonLength));
	[data appendBytes:&totalLength length:sizeof(short)];
	
	if (encodedJSON.length > 0) {
		[data appendData:encodedJSON];
	}
	
	[data appendData:self.body];
	
	return self.raw = data;
}

@end
