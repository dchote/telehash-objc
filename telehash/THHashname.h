//
//  THHashname.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"

@interface THHashname : NSObject

@property (readonly) NSString* hashname;

@property NSMutableDictionary* secrets;
@property NSMutableDictionary* keys;

@end
