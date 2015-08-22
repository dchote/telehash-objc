//
//  AppDelegate.h
//  Telehash Tester
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "THLog.h"
#import "THMesh.h"
#import "THMeshConfiguration.h"
#import "THTransport.h"


@interface AppDelegate : NSObject <THMeshDelegate, NSApplicationDelegate> {
	THLog* logger;
	THMesh* mesh;
	
}

@end

