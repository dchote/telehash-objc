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

+ (DebugController *)sharedController
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




#pragma -
#pragma mark OutlineView Delegation

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	return 0;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	return [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
}

@end
