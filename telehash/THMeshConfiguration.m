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
		self.listenPort = 0;
		self.enabledTransportIDs = nil;
	}
	
	return self;
}

@end
