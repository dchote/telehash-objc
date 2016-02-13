//
//  THEndpoint.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THHashname.h"
#import "THURI.h"
#import "THLink.h"

@class THMesh;


@interface THEndpoint : NSObject

@property THMesh* mesh;

@property THHashname* hashname;

@property NSMutableArray* paths;

@property THLink* link;
@property NSMutableArray* channels;


@property (readonly) NSString* addressDescription;


+ (THEndpoint *)initWithMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromFile:(NSString *)filePath withMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromJSON:(NSData *)json withMesh:(THMesh *)mesh;
+ (THEndpoint *)endpointFromURI:(THURI *)uri withMesh:(THMesh *)mesh;
@end
