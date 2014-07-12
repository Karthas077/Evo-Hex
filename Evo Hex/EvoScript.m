//
//  EvoScript.m
//  Evo Hex
//
//  Created by Steven Buell on 7/12/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoScript.h"

@implementation EvoScript

- (EvoScript *) initScript:(NSArray *)script
{
    self = [super init];
    if (self) {
        _script = script;
    }
    return self;
}

- (void) execute
{
    //[targetName, targetKey, expression, parameters, ...]
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    for (NSString *key in [_script subarrayWithRange:NSMakeRange(3, [_script count] - 3)]) {
        [arguments addObject:[_source valueForKey:key]];
    }
    
    NSExpression *exp = [NSExpression expressionWithFormat:[_script objectAtIndex:2] argumentArray:arguments];
    NSNumber *expResult = [exp expressionValueWithObject:nil context:nil];
    [[_source valueForKey:[_script objectAtIndex:0]] setValue:expResult forKey:[_script objectAtIndex:1]];
}

@end
