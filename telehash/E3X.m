//
//  E3X.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "E3X.h"

@implementation E3X

+ (unsigned char)CSIDFromString:(NSString *)identifier {
	if ([identifier isEqualToString:@"cs1a"] || [identifier isEqualToString:@"1a"]) {
		return 0x1a;
	} else if ([identifier isEqualToString:@"cs2a"] || [identifier isEqualToString:@"2a"]) {
		return 0x2a;
	} else if ([identifier isEqualToString:@"cs3a"] || [identifier isEqualToString:@"3a"]) {
		return 0x3a;
	}
	
	return 0x0;
}

+ (NSString *)CSIDString:(unsigned char)CSID {
	if (CSID == 0x1a) {
		return @"1a";
	} else if (CSID == 0x2a) {
		return @"2a";
	} else if (CSID == 0x3a) {
		return @"3a";
	}
	
	return @"unknown";
}


@end
