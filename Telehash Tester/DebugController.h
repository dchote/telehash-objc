//
//  DebugController.h
//  telehash
//
//  Created by Daniel Chote on 8/21/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THLog.h"
#import "THMesh.h"

@interface DebugController : NSWindowController <NSWindowDelegate>

@property (weak) THMesh* mesh;

@property IBOutlet NSSplitView* horizontalSplit;
@property IBOutlet NSOutlineView* interfaceList;
@property IBOutlet NSOutlineView* endpointList;
@property IBOutlet NSTableView* packetLog;


- (IBAction)refreshTransports:(id)sender;

+ (DebugController *)sharedController;

- (void)refreshLists;

@end
