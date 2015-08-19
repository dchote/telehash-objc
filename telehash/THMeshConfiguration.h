//
//  THMeshConfiguration.h
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THMeshConfiguration : NSObject

@property uint16_t listenPort;
@property NSArray* enabledTransportIDs;

@end
