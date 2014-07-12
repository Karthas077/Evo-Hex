//
//  EvoFunctionManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/11/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoScriptManager.h"

@implementation EvoScriptManager

@synthesize scripts;
@synthesize scriptQueue;
@synthesize currentTime;

#pragma mark Singleton Methods

+ (id) scriptManager
{
    static EvoScriptManager *scriptManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scriptManager = [[self alloc] init];
    });
    return scriptManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        scripts = [[NSMutableDictionary alloc] init];
        scriptQueue = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setTime:(NSNumber *)time
{
    currentTime = time;
}

- (BOOL) addScript:(NSArray *)script withName:(NSString *)name
{
    EvoScript *newScript = [[EvoScript alloc] initScript:[script subarrayWithRange:NSMakeRange(1, [script count] - 1)]];
    [newScript setLabel:[script objectAtIndex:0]];
    if ([scripts objectForKey:name]==nil) {
        [scripts setObject:[script copy] forKey:name];
        return YES;
    }
    NSLog(@"Unable to add script: Duplicate name.");
    return NO;
}

- (BOOL) executeScriptNamed:(NSString *)name withSource:(id)source
{
    EvoScript *script = [scripts objectForKey:name];
    return [self executeScript:script withSource:source];
}

- (BOOL) executeScript:(EvoScript *)script withSource:(id)source
{
    if ([[script label] isEqualToString:@"leaf"]) { //[targetName, targetKey, expression, parameters, ...]
        [script setSource:source];
        [script execute];
    }
    else if ([[script label] isEqualToString:@"node"]) { //[[label1, script1, source1], [label2, script2, source2], ...]
        for (NSArray *subScript in [[script script] subarrayWithRange:NSMakeRange(1, [[script script]count] - 1)]) {
            EvoScript *newScript = [[EvoScript alloc] initScript:[subScript objectAtIndex:1]];
            [newScript setLabel:[subScript objectAtIndex:0]];
            [self executeScript:newScript withSource:[source valueForKey:[subScript objectAtIndex:2]]];
        }
    }
    else if ([[script label] isEqualToString:@"delay"]) { //[label, script, source, time]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:3] floatValue];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
    }
    else if ([[script label] isEqualToString:@"repeat"]) { //[label, script, source, time]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:3] floatValue];
        [self executeScript:newScript withSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
    }
    else if ([[script label] isEqualToString:@"call"]) { //[scriptName, source]
        [self executeScriptNamed:[[script script] objectAtIndex:1] withSource:[source valueForKey:[[script script] objectAtIndex:2]]];
    }
    else if ([[script label] isEqualToString:@"branchif"] && [[script script] count] == 3) { //[[label, conditional, source], [label, true, source], [label, false, source]]
        
        EvoScript *conditional = [[EvoScript alloc] initScript:[[[script script] objectAtIndex:0] objectAtIndex:1]];
        [conditional setLabel:[[[script script] objectAtIndex:0] objectAtIndex:0]];
        
        if ([self executeScript:conditional withSource:[source valueForKey:[[[script script] objectAtIndex:0] objectAtIndex:2]]]) {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[[script script] objectAtIndex:1] objectAtIndex:1]];
            [newScript setLabel:[[[script script] objectAtIndex:1] objectAtIndex:0]];
            [self executeScript:newScript withSource:[source valueForKey:[[[script script] objectAtIndex:1] objectAtIndex:2]]];
        }
        else {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[[script script] objectAtIndex:2] objectAtIndex:1]];
            [newScript setLabel:[[[script script] objectAtIndex:2] objectAtIndex:0]];
            [self executeScript:newScript withSource:[source valueForKey:[[[script script] objectAtIndex:2] objectAtIndex:2]]];
        }
    }
    else if ([[script label] isEqualToString:@"lessthan"]) { //[object1, object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedAscending;
    }
    else if ([[script label] isEqualToString:@"greaterthan"]) { //[object1, object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedDescending;
    }
    else if ([[script label] isEqualToString:@"equalto"]) { //[object1, object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedSame;
    }
    else if ([[script label] isEqualToString:@"not"]) { // [[label, conditional, source]]
        EvoScript *conditional = [[EvoScript alloc] initScript:[[[script script] objectAtIndex:0] objectAtIndex:1]];
        [conditional setLabel:[[[script script] objectAtIndex:0] objectAtIndex:0]];
        return ![self executeScript:conditional withSource:[source valueForKey:[[[script script] objectAtIndex:0] objectAtIndex:2]]];
    }
    return YES;
}

@end
