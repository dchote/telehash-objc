//
//  THPath.h
//  telehash
//
//  Created by Daniel Chote on 2/3/16.
//  Copyright © 2016 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"

@interface THPath : NSObject

@property NSString* type;

@property NSString* host;
@property uint16_t port;

@property NSString* url; // only when type==http

@end
