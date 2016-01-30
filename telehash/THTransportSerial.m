//
//  THTransportSerial.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransportSerial.h"

@implementation THTransportSerial {
	ORSSerialPort* serialPort;
}

- (id)init {
	self = [super init];
	
	if (self) {
		self.availableBaudRates = @[@300, @1200, @2400, @4800, @9600, @14400, @19200, @28800, @38400, @57600, @115200, @230400];
	}
	
	return self;
}

- (void)setSerialPort:(ORSSerialPort *)port {
	THLogMethodCall
	
	serialPort = port;
	serialPort.delegate = self;
	serialPort.baudRate = @9600; // default
}

- (void)setBaudRate:(NSNumber *)baudRate {
	THLogMethodCall
	
	if ([self.availableBaudRates containsObject:baudRate]) {
		serialPort.baudRate = baudRate;
	} else {
		THLogErrorTHessage(@"attempting to set an invalid baud rate %@", baudRate);
	}
}

- (void)shutdown {
	THLogMethodCall
	
	[self closeSerialPort];
}


- (void)openSerialPort {
	THLogMethodCall
	
	[serialPort open];
	
}

- (void)closeSerialPort {
	THLogMethodCall
	
	if (serialPort.isOpen) {
		[serialPort close];
	}
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort {
	if ([self.delegate respondsToSelector:@selector(THTransportReady:)]) {
		[self.delegate performSelector:@selector(THTransportReady:) withObject:self afterDelay:THTransportInitDelay];
	}
}

- (void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
	if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
		[self.delegate THTransportError:self error:error];
	}
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort {
	
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
	
}

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
	
}


@end
