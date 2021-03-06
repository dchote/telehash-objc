//
//  THURI.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "E3X.h"
#import "THHashname.h"
#import "THPath.h"

@interface THURI : NSObject

@property THHashname* hashname;
@property NSMutableArray* paths;


+ (THURI *)initWithLinkURI:(NSString *)link;

@end
