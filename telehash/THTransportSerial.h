//
//  THTransportSerial.h
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSSerialPort.h"

#import "THLog.h"
#import "THTransport.h"


@interface THTransportSerial : THTransport <ORSSerialPortDelegate>

@property NSArray* availableBaudRates;

- (void)setSerialPort:(ORSSerialPort*)port;
- (void)setBaudRate:(NSNumber*)baudRate;
- (void)openSerialPort;
- (void)closeSerialPort;
@end
