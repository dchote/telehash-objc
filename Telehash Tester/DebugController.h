//
//  DebugController.h
//  telehash
//
//  Created by Daniel Chote on 8/21/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THLog.h"

@interface DebugController : NSWindowController <NSWindowDelegate>


+ (DebugController*)sharedController;

@end
