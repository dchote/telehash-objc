//
//  THMeshConfiguration.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THMeshConfiguration.h"

@implementation THMeshConfiguration

- (id)init {
	if (self) {
		self.enabledTransportIDs = nil;
		self.networkListenPort = 0;
		self.serialBaudRates = [NSDictionary dictionary];
	}
	
	return self;
}

@end
