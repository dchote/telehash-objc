//
//  THLog.m
//  telehash
//
//  Created by Daniel Chote on 8/14/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THLog.h"

NSString* const THLAllEvents = @"THLAllEvents";
NSString* const THLErrorEvent = @"THLErrorEvent";
NSString* const THLWarningEvent = @"THLWarningEvent";
NSString* const THLNoticeEvent = @"THLNoticeEvent";
NSString* const THLInfoEvent = @"THLInfoEvent";
NSString* const THLDebugEvent = @"THLDebugEvent";

NSString* const THLMethodCallEvent = @"THLMethodCallEvent";

NSString* const THLEventLoggedMethodName = @"THLEventLoggedMethodName";
NSString* const THLEventLoggedMessage = @"THLEventLoggedMessage";

NSString* const THLAllClasses = @"THLAllClasses";


@implementation THLog

- (id)init {
	self = [super init];
	
	logClient = asl_open(NULL, [@"com.apple.console" UTF8String], ASL_LEVEL_DEBUG);
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		asl_add_log_file(NULL, STDERR_FILENO);
	});
	
	self.eventTypes = [NSArray arrayWithObject:THLErrorEvent];
	self.classNames = [NSArray arrayWithObject:THLAllClasses];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLErrorEvent object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLWarningEvent object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLNoticeEvent object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLInfoEvent object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLDebugEvent object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:THLMethodCallEvent object:nil];
	
	return self;
}

- (id)initWithLoggedEventTypes:(NSArray *)eventTypes {
	self = [self init];
	
	self.eventTypes = eventTypes;
	
	return self;
}

- (id)initWithLoggedEventTypes:(NSArray *)eventTypes classNames:(NSArray *)classNames {
	self = [self initWithLoggedEventTypes:eventTypes];
	
	self.classNames = classNames;
	
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	asl_close(logClient);
}

- (BOOL)shouldLogClassName:(NSString *)className {
	return ([self.classNames containsObject:THLAllClasses] || [self.classNames containsObject:className]);
}

- (BOOL)shouldLogEventType:(NSString *)eventType {
	return ([self.eventTypes containsObject:THLAllEvents] || [self.eventTypes containsObject:eventType]);
}


- (void)handleNotification:(NSNotification *)aNotification {
	NSString *name = [aNotification name];
	NSString *className = [[aNotification object] className];
	
	BOOL shouldLog = NO;
	
	// we only want to log method calls if explicitly asked to
	if (name == THLMethodCallEvent) {
		shouldLog = ([self shouldLogEventType:THLMethodCallEvent] && [self shouldLogClassName:className]);
	} else {
		shouldLog = ([self shouldLogEventType:name] && [self shouldLogClassName:className]);
	}
	
	if (shouldLog) {
		int logLevel = ASL_LEVEL_DEBUG;
		
		if ([name isEqualToString:THLErrorEvent]) {
			logLevel = ASL_LEVEL_ERR;
		} else if ([name isEqualToString:THLWarningEvent]) {
			logLevel = ASL_LEVEL_WARNING;
		} else if ([name isEqualToString:THLNoticeEvent]) {
			logLevel = ASL_LEVEL_NOTICE;
		} else if ([name isEqualToString:THLInfoEvent]) {
			logLevel = ASL_LEVEL_INFO;
		}
		
		NSDictionary *eventInfo = [aNotification userInfo];
		NSMutableString *message = [[NSMutableString alloc] init];
		
		if (eventInfo) {
			[message appendString:[[aNotification object] className]];
			
			if ([eventInfo objectForKey:THLEventLoggedMethodName]) {
				[message appendString:[NSString stringWithFormat:@" %@", [eventInfo objectForKey:THLEventLoggedMethodName]]];
			}
			
			if ([eventInfo objectForKey:THLEventLoggedMessage]) {
				[message appendString:[NSString stringWithFormat:@" %@", [eventInfo objectForKey:THLEventLoggedMessage]]];
			}
		}
		
		asl_log(logClient, NULL, logLevel, "%s", [message UTF8String]);
	}
}

@end
