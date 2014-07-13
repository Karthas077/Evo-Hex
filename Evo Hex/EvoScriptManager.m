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

- (BOOL) addScript:(EvoScript *)script
{
    NSLog(@"Adding Script named %@", [script name]);
    if ([scripts objectForKey:[script name]]==nil) {
        NSLog(@"No Script with that name.");
        [scripts setObject:script forKey:[script name]];
        NSLog(@"successfully added");
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
    if ([[script label] isEqualToString:@"leaf"]) { //[targetName:targetKey:expression:parameters:...]
        NSLog(@"leaf");
        [script setSource:source];
        [script execute];
    }
    else if ([[script label] isEqualToString:@"node"]) { //[label1:script1:source1:label2:script2:source2:...]
        NSLog(@"node");
        for (NSUInteger i=0; i<[[script script] count]; i+=3) {
            //NSLog(@"entry %d: %@", i/3, [[script script] objectAtIndex:i]);
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:i+1]];
            [newScript setLabel:[[script script] objectAtIndex:i]];
            [self executeScript:newScript withSource:[source valueForKey:[[script script] objectAtIndex:i+2]]];
        }
    }
    else if ([[script label] isEqualToString:@"delay"]) { //[label:script:source:time]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:3] floatValue];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
    }
    else if ([[script label] isEqualToString:@"repeat"]) { //[label:script:source:time]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:3] floatValue];
        [self executeScript:newScript withSource:[source valueForKey:[[script script] objectAtIndex:2]]];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
    }
    else if ([[script label] isEqualToString:@"call"]) { //[scriptName:source]
        [self executeScriptNamed:[[script script] objectAtIndex:1] withSource:[source valueForKey:[[script script] objectAtIndex:2]]];
    }
    else if ([[script label] isEqualToString:@"branchif"] && [[script script] count] == 3) { //[label:conditional:source:label:true:source:label:false:source]
        
        EvoScript *conditional = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional setLabel:[[script script] objectAtIndex:0]];
        
        if ([self executeScript:conditional withSource:[source valueForKey:[[script script] objectAtIndex:2]]]) {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:4]];
            [newScript setLabel:[[script script] objectAtIndex:3]];
            [self executeScript:newScript withSource:[source valueForKey:[[script script] objectAtIndex:5]]];
        }
        else {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:7]];
            [newScript setLabel:[[script script] objectAtIndex:6]];
            [self executeScript:newScript withSource:[source valueForKey:[[script script] objectAtIndex:8]]];
        }
    }
    else if ([[script label] isEqualToString:@"lessthan"]) { //[object1:object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedAscending;
    }
    else if ([[script label] isEqualToString:@"greaterthan"]) { //[object1:object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedDescending;
    }
    else if ([[script label] isEqualToString:@"equalto"]) { //[object1:object2]
        return [[[script source] valueForKey:[[script script] objectAtIndex:0]] compare:[source valueForKey:[[script script] objectAtIndex:1]]] == NSOrderedSame;
    }
    else if ([[script label] isEqualToString:@"not"]) { //[label:conditional:source]
        EvoScript *conditional = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional setLabel:[[script script]objectAtIndex:0]];
        return ![self executeScript:conditional withSource:[source valueForKey:[[script script] objectAtIndex:2]]];
    }
    return YES;
}

@end
