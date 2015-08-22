//
//  THPipe.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THLog.h"
#import "THLink.h"
#import "THTransport.h"

@interface THPipe : NSObject

@property (weak) THLink* link;
@property (weak) THTransport* transport;

@end
