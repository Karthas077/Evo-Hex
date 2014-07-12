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

- (void) executeScriptNamed:(NSString *)name withSource:(id)source withTarget:(id)target
{
    NSArray *script = [scripts objectForKey:name];
    
    if (![[script objectAtIndex:0] isEqualToString:@"0"]) {
        for (NSArray *subScript in [script subarrayWithRange:NSMakeRange(1, [script count])]) {
            id newSource = [source valueForKey:[subScript objectAtIndex:1]];
            id newTarget = [source valueForKey:[subScript objectAtIndex:2]];
            [self executeScriptNamed:[subScript objectAtIndex:0] withSource:newSource withTarget:newTarget];
        }
    }
    else {
        //Construct argumentArray
        NSMutableArray *arguments = [[NSMutableArray alloc] init];
        for (NSString *key in [script subarrayWithRange:NSMakeRange(3, [script count])]) {
            [arguments addObject:[source valueForKey:key]];
        }
        
        NSExpression *exp = [NSExpression expressionWithFormat:[script objectAtIndex:2] argumentArray:arguments];
        NSNumber *expResult = [exp expressionValueWithObject:nil context:nil];
        [target setValue:expResult forKey:[script objectAtIndex:1]];
    }
}

@end
