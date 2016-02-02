//
//  THMeshConfiguration.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THHashname.h"

@interface THMeshConfiguration : NSObject

@property THHashname* localHashname;

@property NSArray* enabledTransportIDs;

@property uint16_t networkListenPort;
@property NSDictionary* serialBaudRates;

@end
