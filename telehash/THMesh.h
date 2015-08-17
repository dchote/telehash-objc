//
//  THMesh.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THMeshConfiguration.h"
#import "THTransportAssistant.h"


@protocol THMeshDelegate <NSObject>
- (void)ready;
- (void)error:(NSError*)error;
@end;




@interface THMesh : NSObject

@property THMeshConfiguration* config;
@property THTransportAssistant* transportAssistant;
@property NSMutableArray* transports;

+ (id)initWithConfig:(THMeshConfiguration*)config;
- (void)bootstrapWithConfig:(THMeshConfiguration*)config;
- (void)shutdown;
@end
