//
//  THPipe.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THPipe.h"

@implementation THPipe

- (id)init
{
	self = [super init];
	
	self.type = nil;
	self.keepalive = 60;
	self.cloaked = NO;
	
	self.link = nil;
	self.transport = nil;
	
	self.status = THPipeStatusDown;
	
	self.lastInboundActivity = 0;
	self.lastOutboundActivity = 0;
	
	return self;
}

@end
