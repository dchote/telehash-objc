//
//  THLog.h
//  telehash
//
//  Created by Daniel Chote on 8/14/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#include <asl.h>

#pragma mark THEventLogger Macros

#define THLogMethodCall [[NSNotificationCenter defaultCenter] postNotificationName:THLMethodCallEvent object:self userInfo:[NSDictionary dictionaryWithObject:NSStringFromSelector(_cmd) forKey:THLEventLoggedMethodName]];
#define THLogErrorTHessage(...) [[NSNotificationCenter defaultCenter] postNotificationName:THLErrorEvent object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([NSString stringWithFormat:__VA_ARGS__]), THLEventLoggedMessage, NSStringFromSelector(_cmd), THLEventLoggedMethodName, nil]];
#define THLogWarningMessage(...) [[NSNotificationCenter defaultCenter] postNotificationName:THLWarningEvent object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([NSString stringWithFormat:__VA_ARGS__]), THLEventLoggedMessage, NSStringFromSelector(_cmd), THLEventLoggedMethodName, nil]];
#define THLogNoticeMessage(...) [[NSNotificationCenter defaultCenter] postNotificationName:THLNoticeEvent object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([NSString stringWithFormat:__VA_ARGS__]), THLEventLoggedMessage, NSStringFromSelector(_cmd), THLEventLoggedMethodName, nil]];
#define THLogInfoMessage(...) [[NSNotificationCenter defaultCenter] postNotificationName:THLInfoEvent object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([NSString stringWithFormat:__VA_ARGS__]), THLEventLoggedMessage, NSStringFromSelector(_cmd), THLEventLoggedMethodName, nil]];
#define THLogDebugMessage(...) [[NSNotificationCenter defaultCenter] postNotificationName:THLDebugEvent object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([NSString stringWithFormat:__VA_ARGS__]), THLEventLoggedMessage, NSStringFromSelector(_cmd), THLEventLoggedMethodName, nil]];


#pragma mark THEventLogger Constants

extern NSString* const THLAllEvents;
extern NSString* const THLErrorEvent;
extern NSString* const THLWarningEvent;
extern NSString* const THLNoticeEvent;
extern NSString* const THLInfoEvent;
extern NSString* const THLDebugEvent;

extern NSString* const THLMethodCallEvent;

extern NSString* const THLEventLoggedMethodName;
extern NSString* const THLEventLoggedMessage;

extern NSString* const THLAllClasses;


#pragma mark THEventLogger Object

@interface THLog : NSObject {
	aslclient logClient;
}

@property NSArray* eventTypes;
@property NSArray* classNames;

#pragma mark -
#pragma mark THEventLogger Methods

- (id)initWithLoggedEventTypes:(NSArray*)eventTypes;
- (id)initWithLoggedEventTypes:(NSArray*)eventTypes classNames:(NSArray*)classNames;

- (BOOL)shouldLogClassName:(NSString*)className;
- (BOOL)shouldLogEventType:(NSString*)eventType;

- (void)handleNotification:(NSNotification*)notification;

@end
