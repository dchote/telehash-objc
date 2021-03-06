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

+ (DebugController *)sharedController {
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad {
	THLogMethodCall
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLists) name:THMeshStateChange object:nil];
}

- (void)refreshLists {
	THLogMethodCall
	
	[self.interfaceList reloadData];
	[self.endpointList reloadData];
}

#pragma -
#pragma mark IBActions

- (IBAction)refreshTransports:(id)sender {
	[self.mesh evaluateTransports];
}



#pragma -
#pragma mark OutlineView Delegation

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (outlineView == self.interfaceList) {
		return self.mesh.activeTransports.count;
	} else if (outlineView == self.endpointList) {
		NSArray* endpointKeys = [self.mesh.endpoints allKeys];
		return endpointKeys.count;
	}
	
	return 0;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (outlineView == self.interfaceList) {
		return [self.mesh.activeTransports objectAtIndex:index];
	} else if (outlineView == self.endpointList) {
		NSArray* endpointKeys = [self.mesh.endpoints allKeys];
		return [self.mesh.endpoints objectForKey:[endpointKeys objectAtIndex:index]];
	}
	
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (outlineView == self.endpointList) {
		return YES;
	}
	
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return NO;
}

/*
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	return [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
}
*/






#pragma mark -
#pragma mark Splitview Delegates

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index {
	return proposedCoordinate + 200.0f;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index {
	return proposedCoordinate - 200.0f;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
	return NO;
}

@end
