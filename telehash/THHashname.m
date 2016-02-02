//
//  THHashname.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THHashname.h"

@implementation THHashname

- (id)init
{
	self = [super init];
	
	self.secrets = [NSMutableDictionary dictionary];
	self.keys = [NSMutableDictionary dictionary];
	
	return self;
}

@end
