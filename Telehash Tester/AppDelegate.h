//
//  AppDelegate.h
//  Telehash Tester
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THMesh.h"


@interface AppDelegate : NSObject <THMeshDelegate, NSApplicationDelegate> {
	THMesh* mesh;
}

@end

