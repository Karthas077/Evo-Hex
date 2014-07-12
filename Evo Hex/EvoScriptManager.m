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
    }
    return self;
}

- (BOOL) addScript:(NSArray *)script withName:(NSString *)name
{
    if ([scripts objectForKey:name]==nil) {
        [scripts setObject:[script copy] forKey:name];
        return YES;
    }
    else
        return NO;
}

- (BOOL) executeScriptNamed:(NSString *)name withSource:(id)source
{
    NSArray *script = [scripts objectForKey:name];
    return [self executeScript:script withSource:source];
}

- (BOOL) executeScript:(NSArray *)script withSource:(id)source
{
    if ([[script objectAtIndex:0] isEqualToString:@"leaf"]) { //[leaf, targetName, targetKey, expression, parameters, ...]
        NSMutableArray *arguments = [[NSMutableArray alloc] init];
        for (NSString *key in [script subarrayWithRange:NSMakeRange(4, [script count] - 3)]) {
            [arguments addObject:[source valueForKey:key]];
        }
        
        NSExpression *exp = [NSExpression expressionWithFormat:[script objectAtIndex:3] argumentArray:arguments];
        NSNumber *expResult = [exp expressionValueWithObject:nil context:nil];
        [[source valueForKey:[script objectAtIndex:1]] setValue:expResult forKey:[script objectAtIndex:2]];
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"node"]) { //[node, scriptArray1, scriptArray2, ...]
        for (NSArray *subScript in [script subarrayWithRange:NSMakeRange(1, [script count] - 1)]) {
            [self executeScript:[subScript objectAtIndex:0] withSource:[source valueForKey:[subScript objectAtIndex:1]]];
        }
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"call"]) { //[call, scriptName, source]
        [self executeScriptNamed:[script objectAtIndex:1] withSource:[source valueForKey:[script objectAtIndex:2]]];
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"branchif"] && [script count] == 4) { //[branchif, conditional, true, false]
        if ([self executeScriptNamed:[[script objectAtIndex:1] objectAtIndex:0] withSource:[[script objectAtIndex:1] objectAtIndex:1]]) {
            [self executeScriptNamed:[[script objectAtIndex:2] objectAtIndex:0] withSource:[[script objectAtIndex:2] objectAtIndex:1]];
        }
        else {
            [self executeScriptNamed:[[script objectAtIndex:3] objectAtIndex:0] withSource:[[script objectAtIndex:3] objectAtIndex:1]];
        }
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"lessthan"]) { //[lessthan, object1, object2]
        return [[source valueForKey:[script objectAtIndex:1]] compare:[source valueForKey:[script objectAtIndex:2]]] == NSOrderedAscending;
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"greaterthan"]) { //[greaterthan, object1, object2]
        return [[source valueForKey:[script objectAtIndex:1]] compare:[source valueForKey:[script objectAtIndex:2]]] == NSOrderedDescending;
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"equalto"]) { //[equalto, object1, object2]
        return [[source valueForKey:[script objectAtIndex:1]] compare:[source valueForKey:[script objectAtIndex:2]]] == NSOrderedSame;
    }
    else if ([[script objectAtIndex:0] isEqualToString:@"not"]) { // [not, conditional]
        return ![self executeScriptNamed:[[script objectAtIndex:1] objectAtIndex:0] withSource:[[script objectAtIndex:1] objectAtIndex:1]];
    }
    return YES;
}

@end
