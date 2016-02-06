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
		self.localHashname = nil;
		self.enabledTransportIDs = nil;
		self.enabledTransportPathTypes = nil;
		self.networkListenPort = 0;
		self.serialBaudRates = [NSDictionary dictionary];
		self.routerLinks = [NSMutableArray array];
	}
	
	return self;
}

+ (THMeshConfiguration *)initWithConfigFile:(NSString *)filePath {
	THLogMethodCall
	
	THMeshConfiguration* meshConfig = [[THMeshConfiguration alloc] init];
	
	// TODO load actual config
	
	return meshConfig;
}


- (void)saveConfigToFile:(NSString *)filePath {
	THLogMethodCall
	
	// TODO save actual config
}

@end
