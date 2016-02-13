//
//  THEndpoint.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THEndpoint.h"
#import "THMesh.h"

#import "MF_Base32Additions.h"


@implementation THEndpoint

- (id)init {
	self = [super init];
	
	self.mesh = nil;
	self.hashname = nil;

	self.paths = [NSMutableArray array];
	
	self.link = [THLink initWithEndpoint:self];
	self.channels = [NSMutableArray array];

	return self;
}

- (NSString *)addressDescription {
	NSString* addressDescription = @"";
	
	for (THPath* path in self.paths) {
		addressDescription = [addressDescription stringByAppendingFormat:@"%@ ", path.description];
	}
	
	return [addressDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (THEndpoint *)initWithMesh:(THMesh *)mesh {
	THLogMethodCall
	
	THEndpoint* endpoint = [[THEndpoint alloc] init];
	endpoint.mesh = mesh;
	
	return endpoint;
}

+ (THEndpoint *)endpointFromFile:(NSString *)filePath withMesh:(THMesh *)mesh {
	THLogInfoMessage(@"loading json file %@", filePath);
	
	// TODO load json file
	NSData* json = [NSData dataWithContentsOfFile:filePath];
	
	THEndpoint* endpoint = [THEndpoint endpointFromJSON:json withMesh:mesh];
	
	return endpoint;
}

+ (THEndpoint *)endpointFromJSON:(NSData *)json withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];

	if (json.length > 0) {
		NSError* error;
		NSMutableDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
		
		if (error) {
			THLogErrorMessage(@"json decode error: %@", [error localizedDescription]);
		} else if (jsonDictionary) {
			THHashname* hashname = [[THHashname alloc] init];
			
			NSDictionary* keys = [jsonDictionary objectForKey:@"keys"];
			[keys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				unsigned char CSID = [E3X CSIDFromString:(NSString *)key];
				NSData* keyData = [NSData dataWithBase32String:(NSString *)obj];
				
				if (CSID != 0x0 && keyData) {
					[hashname.keys setObject:keyData forKey:[E3X CSIDString:CSID]];
				}
			}];
			
			if (hashname.keys.count > 0) {
				endpoint.hashname = hashname;
			}
			
			NSArray* paths = [jsonDictionary objectForKey:@"paths"];
			for (NSDictionary* path in paths) {
				THPath* endpointPath = [[THPath alloc] init];
				endpointPath.ip = [path objectForKey:@"ip"];
				endpointPath.port = [[path objectForKey:@"port"] unsignedIntegerValue];
				endpointPath.type = [path objectForKey:@"type"];
				
				[endpoint.paths addObject:endpointPath];
			}
			
			if (endpoint.paths.count > 0) {
				[endpoint.link generatePipesFromPaths:endpoint.paths];
			}
			
		}
	}
	
	return endpoint;
}

+ (THEndpoint *)endpointFromURI:(THURI *)uri withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	if (uri) {
		THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];
		
		if (uri.hashname) {
			endpoint.hashname = uri.hashname;
		}
		
		[endpoint.link generatePipesFromPaths:uri.paths];
		
		return endpoint;
	}
	
	return nil;
}

@end
