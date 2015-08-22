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
#import "THLink.h"

@interface THEndpoint : NSObject

@property THHashname* localHashname;
@property THHashname* remoteHashname;

@property THLink* link;
@property NSMutableArray* pipes;

@end
