//
//  THMesh.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THMeshDelegate <NSObject>
- (void)ready;
- (void)error:(NSError*)error;
@end;

@interface THMesh : NSObject

@end
