//
//  EvoFunctionManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/11/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoObjectManager.h"
#import "EvoScript.h"

@interface EvoScriptManager : NSObject {
    NSMutableDictionary *scripts;
    NSMutableDictionary *scriptQueue;
    NSMutableDictionary *localData;
    NSNumber *currentTime;
}

@property (nonatomic, retain) NSMutableDictionary *scripts;
@property (nonatomic, retain) NSMutableDictionary *scriptQueue;
@property (nonatomic, retain) NSMutableDictionary *localData;
@property (nonatomic, retain) NSNumber *currentTime;

+ (id) scriptManager;

- (void) setTime:(NSNumber *) time;

- (BOOL) addScript:(EvoScript *)script;
- (NSObject *) startScriptNamed:(NSString *)name withSource:(id)source;
- (NSObject *) startScript:(EvoScript *)script withSource:(id)source;

@end
