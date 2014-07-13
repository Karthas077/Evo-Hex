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
    if ([scripts objectForKey:[script name]]==nil) {
        NSLog(@"Adding %@", [script name]);
        //NSLog(@"No Script with that name.");
        [scripts setObject:script forKey:[script name]];
        //NSLog(@"successfully added");
        return YES;
    }
    NSLog(@"Unable to add %@: Duplicate name.", [script name]);
    return NO;
}

- (NSString *) executeScriptNamed:(NSString *)name withSource:(id)source
{
    EvoScript *script = [scripts objectForKey:name];
    return [self executeScript:script withSource:source];
}

- (NSString *) executeScript:(EvoScript *)script withSource:(id)source
{
    
    id source1 = source;
    id source2 = source;
    id source3 = source;
    NSString *result = [[NSNumber numberWithBool:NO] stringValue];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSLog(@"label:%@",[script label]);
    
    if ([[script label] isEqualToString:@"store"]) { //[label:script:targetName:targetKey:source]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        
        if ([[script script] count] > 4) {
            source1 = [source valueForKey:[[script script] objectAtIndex:4]];
        }
        
        NSNumber *expResult = [f numberFromString:[self executeScript:newScript withSource:source]];
        [[source valueForKey:[[script script] objectAtIndex:2]] setValue:expResult forKey:[[script script] objectAtIndex:3]];
        result = [[NSNumber numberWithBool:YES] stringValue];
    }
    else if ([[script label] isEqualToString:@"evaluate"]) { //[expression:parameters]
        NSMutableArray *arguments = [[NSMutableArray alloc] init];
        if ([[script script] count] > 1) {
            for (NSString *key in [[script script] subarrayWithRange:NSMakeRange(1, [[script script] count] - 1)]) {
                [arguments addObject:[source valueForKey:key]];
            }
        }
        NSExpression *exp = [NSExpression expressionWithFormat:[[script script] objectAtIndex:0] argumentArray:arguments];
        result = [[exp expressionValueWithObject:nil context:nil] stringValue];
    }
    else if ([[script label] isEqualToString:@"split"]) { //[count:label1:script1:label2:script2:...:source1:source2:...]
        NSLog(@"\n%@", [script script]);
        
        
        NSUInteger branches = [[[script script] objectAtIndex:0] integerValue];
        NSMutableArray *sources;
        
        if (branches != [[script script] count]/3) {
            sources = [[NSMutableArray alloc] initWithCapacity:branches];
            for (NSUInteger x = 0; x < branches; x++) {
                [sources setObject:source atIndexedSubscript:x];
            }
        }
        else {
            sources = [[[script script] subarrayWithRange:NSMakeRange((branches*2)+1, branches)] mutableCopy];
        }
        for (NSUInteger i=0; i<branches; i++) {
            //NSLog(@"script %d: %@", i, [[script script] objectAtIndex:(i*2)+1]);
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:(i+1)*2]];
            [newScript setLabel:[[script script] objectAtIndex:(i*2)+1]];
            [self executeScript:newScript withSource:[sources objectAtIndex:i]];
        }
        result = [[NSNumber numberWithBool:YES] stringValue];
    }
    else if ([[script label] isEqualToString:@"delay"]) { //[label:script:time:source1]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        
        if ([[script script] count] > 3) {
            source1 = [source valueForKey:[[script script] objectAtIndex:3]];
        }
        
        [newScript setSource:source1];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:2] floatValue];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
        result = [[NSNumber numberWithBool:YES] stringValue];
    }
    else if ([[script label] isEqualToString:@"repeat"]) { //[label:script:time:source1]
        EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [newScript setLabel:[[script script] objectAtIndex:0]];
        
        if ([[script script] count] > 3) {
            source1 = [source valueForKey:[[script script] objectAtIndex:3]];
        }
        
        [newScript setSource:source1];
        CGFloat newTime = [currentTime floatValue]+[[[script script] objectAtIndex:2] floatValue];
        [self executeScript:newScript withSource:source];
        [scriptQueue setObject:newScript forKey:[NSNumber numberWithFloat:newTime]];
        result = [[NSNumber numberWithBool:YES] stringValue];
    }
    else if ([[script label] isEqualToString:@"call"]) { //[scriptName:source]
        
        if ([[script script] count] > 1) {
            source1 = [source valueForKey:[[script script] objectAtIndex:1]];
        }
        result = [self executeScriptNamed:[[script script] objectAtIndex:0] withSource:source1];
    }
    else if ([[script label] isEqualToString:@"if"]) { //[label:conditional:label:true:label:false:source1:source2:source3]
        
        EvoScript *conditional = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional setLabel:[[script script] objectAtIndex:0]];
        
        if ([[script script] count] > 6) {
            source1 = [source valueForKey:[[script script] objectAtIndex:6]];
            source2 = [source valueForKey:[[script script] objectAtIndex:7]];
            source2 = [source valueForKey:[[script script] objectAtIndex:8]];
        }
        
        if ([[self executeScript:conditional withSource:source1] boolValue]) {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:3]];
            [newScript setLabel:[[script script] objectAtIndex:2]];
            result = [self executeScript:newScript withSource:source2];
        }
        else if ([[script script] count] > 6) {
            EvoScript *newScript = [[EvoScript alloc] initScript:[[script script] objectAtIndex:5]];
            [newScript setLabel:[[script script] objectAtIndex:4]];
            result = [self executeScript:newScript withSource:source3];
        }
    }
    else if ([[script label] isEqualToString:@"greaterthan"] || [[script label] isEqualToString:@"lessthan"] || [[script label] isEqualToString:@"equalto"]) { //[object1:object2:source1:source2]
        
        NSNumber *result1;
        NSNumber *result2;
        BOOL evaluate1 = NO;
        BOOL evaluate2 = NO;
        
        if ([[script script] count] > 2) {
            if (evaluate1) {
                source1 = [source valueForKey:[[script script] objectAtIndex:2]];
            }
            if (evaluate2) {
                if (evaluate1) {
                    source2 = [source valueForKey:[[script script] objectAtIndex:3]];
                }
                else {
                    source2 = [source valueForKey:[[script script] objectAtIndex:2]];
                }
            }
        }
        
        if ([[[script script] objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            EvoScript *script1 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:0]];
            [script1 setLabel:@"evaluate"];
            result1 = [f numberFromString:[self executeScript:script1 withSource:source1]];
            evaluate1 = YES;
        }
        else {
            result1 = [f numberFromString:[[script script] objectAtIndex:0]];
        }
        if ([[[script script] objectAtIndex:1] isKindOfClass:[NSArray class]]) {
            EvoScript *script2 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
            [script2 setLabel:@"evaluate"];
            result2 = [f numberFromString:[self executeScript:script2 withSource:source2]];
            evaluate2 = YES;
        }
        else {
            result2 = [f numberFromString:[[script script] objectAtIndex:1]];
        }
        
        if ([[script label] isEqualToString:@"greaterthan"]) {
            result = [[NSNumber numberWithBool:([result1 compare:result2] == NSOrderedDescending)] stringValue];
        }
        else if ([[script label] isEqualToString:@"lessthan"]) {
            result = [[NSNumber numberWithBool:([result1 compare:result2] == NSOrderedAscending)] stringValue];
        }
        else {
            result = [[NSNumber numberWithBool:([result1 compare:result2] == NSOrderedSame)] stringValue];
        }
    }
    else if ([[script label] isEqualToString:@"and"]) { //[label:conditional:label:conditional:source1:source2]
        EvoScript *conditional1 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional1 setLabel:[[script script]objectAtIndex:0]];
        EvoScript *conditional2 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:3]];
        [conditional2 setLabel:[[script script]objectAtIndex:2]];
        
        if ([[script script] count] > 4) {
            source1 = [source valueForKey:[[script script] objectAtIndex:4]];
            source2 = [source valueForKey:[[script script] objectAtIndex:5]];
        }
        else {
            source1 = source;
            source2 = source;
        }
        
        result = [[NSNumber numberWithBool:[[self executeScript:conditional1 withSource:source1] boolValue] && [[self executeScript:conditional2 withSource:source2] boolValue]] stringValue];
    }
    else if ([[script label] isEqualToString:@"or"]) { //[label:conditional:label:conditional:source1:source2]
        EvoScript *conditional1 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional1 setLabel:[[script script]objectAtIndex:0]];
        EvoScript *conditional2 = [[EvoScript alloc] initScript:[[script script] objectAtIndex:3]];
        [conditional2 setLabel:[[script script]objectAtIndex:2]];
        
        if ([[script script] count] > 4) {
            source1 = [source valueForKey:[[script script] objectAtIndex:4]];
            source2 = [source valueForKey:[[script script] objectAtIndex:5]];
        }
        else {
            source1 = source;
            source2 = source;
        }
        
        result = [[NSNumber numberWithBool:[[self executeScript:conditional1 withSource:source1] boolValue] || [[self executeScript:conditional2 withSource:source2] boolValue]] stringValue];
    }
    else if ([[script label] isEqualToString:@"not"]) { //[label:conditional:source]
        EvoScript *conditional = [[EvoScript alloc] initScript:[[script script] objectAtIndex:1]];
        [conditional setLabel:[[script script]objectAtIndex:0]];
        
        if ([[script script] count] > 2) {
            source1 = [source valueForKey:[[script script] objectAtIndex:2]];
        }
        else {
            source1 = source;
        }
        result = [[NSNumber numberWithBool:![[self executeScript:conditional withSource:source1] boolValue]] stringValue];
    }
    NSLog(@"%@",result);
    
    return result;
}

@end
