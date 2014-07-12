//
//  EvoFunctionManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/11/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoObjectManager.h"

@interface EvoScriptManager : NSObject {
    NSMutableDictionary *scripts;
}

@property (nonatomic, retain) NSMutableDictionary *scripts;


+ (id) scriptManager;

- (BOOL) addScript:(NSArray *)script withName:(NSString *)name;
- (void) executeScriptNamed:(NSString *)name withSource:(id)source withTarget:(id)target;

@end
