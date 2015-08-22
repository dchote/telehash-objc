//
//  DebugController.m
//  telehash
//
//  Created by Daniel Chote on 8/21/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "DebugController.h"

@interface DebugController ()

@end

@implementation DebugController

+ (DebugController*)sharedController
{
	static DebugController *sharedDebugControllerInstance = nil;
	
	static dispatch_once_t predicate;
	
	dispatch_once(&predicate, ^{
		sharedDebugControllerInstance = [[self alloc] init];
	});
	
	return sharedDebugControllerInstance;
}


- (id)init {
	THLogMethodCall
	
	self = [super initWithWindowNibName:@"Debug"];
	
	return self;
}

- (void)dealloc {
	THLogMethodCall
}

- (void)windowDidLoad
{
	THLogMethodCall
	
	
}

@end
