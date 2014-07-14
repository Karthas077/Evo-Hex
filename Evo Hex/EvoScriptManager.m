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
@synthesize localData;

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
        localData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setTime:(NSNumber *)time
{
    currentTime = time;
}

- (void) runScripts
{
    //Currently ATOMIC time units (one per turn)
    for (NSArray *scriptContainer in [scriptQueue objectForKey:currentTime]) {
        [self startScript:[scriptContainer objectAtIndex:0] withSource:[scriptContainer objectAtIndex:1]];
    }
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

- (NSObject *) startScriptNamed:(NSString *)name withSource:(id)source
{
    EvoScript *script = [scripts objectForKey:name];
    return [self startScript:script withSource:source];
}

- (NSObject *) startScript:(EvoScript *)script withSource:(id)source
{
    NSObject *result = [NSNumber numberWithBool:NO];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //NSLog(@"label:%@",functions[[script function]]);
    
    switch ([script function]) {
        case EVO_Store:
        {
            NSObject *expResult = [self startScript:[[script code] objectAtIndex:0] withSource:source];
            [source setValue:expResult forKeyPath:[[script code] objectAtIndex:1]];
            result = [NSNumber numberWithBool:YES];
        }
            break;
        case EVO_StoreLocal:
        {
            NSObject *expResult = [self startScript:[[script code] objectAtIndex:0] withSource:source];
            [[self localData] setValue:expResult forKeyPath:[[script code] objectAtIndex:1]];
            result = [NSNumber numberWithBool:YES];
        }
            break;
        case EVO_Retrieve:
            result = [[source valueForKeyPath:[[script code] objectAtIndex:0]] objectForKey:[[script code] objectAtIndex:1]];
            break;
        case EVO_RetrieveLocal:
            result = [[self localData] objectForKey:[[script code] objectAtIndex:1]];
            break;
        case EVO_Evaluate:
        {
            NSMutableArray *arguments = [[NSMutableArray alloc] init];
            if ([[script code] count] > 1) {
                for (NSString *key in [[script code] subarrayWithRange:NSMakeRange(1, [[script code] count] - 1)]) {
                    [arguments addObject:[source valueForKeyPath:key]];
                }
            }
            NSExpression *exp = [NSExpression expressionWithFormat:[[script code] objectAtIndex:0] argumentArray:arguments];
            result = [exp expressionValueWithObject:nil context:nil];
        }
            break;
        case EVO_Run:
        {
            for (EvoScript *subscript in [script code]) {
                if (![self startScript:subscript withSource:source]) {
                    result = [NSNumber numberWithBool:NO];
                    NSLog(@"There was an error in a script.");
                    break;
                }
            }
            result = [NSNumber numberWithBool:YES];
        }
            break;
        case EVO_Delay:
        {
            NSNumber *newTime = [NSNumber numberWithFloat:[currentTime floatValue]+[[[script code] objectAtIndex:1] floatValue]];
            NSArray *pausedScript = [[NSArray alloc] initWithObjects:[[script code] objectAtIndex:0], source, nil];
            [scriptQueue setObject:[[scriptQueue objectForKey:newTime] arrayByAddingObject:pausedScript] forKey:newTime];
            result = [NSNumber numberWithBool:YES];
        }
            break;
        case EVO_Repeat:
        {
            //FIX
            NSNumber *newTime = [NSNumber numberWithFloat:[currentTime floatValue]+[[[script code] objectAtIndex:1] floatValue]];
            NSArray *pausedScript = [[NSArray alloc] initWithObjects:[[script code] objectAtIndex:0], source, nil];
            [scriptQueue setObject:[[scriptQueue objectForKey:newTime] arrayByAddingObject:pausedScript] forKey:newTime];
            [self startScript:[[script code] objectAtIndex:0] withSource:source];
            result = [NSNumber numberWithBool:YES];
        }
            break;
        case EVO_Call:
        {
            result = [self startScriptNamed:[[script code] objectAtIndex:0] withSource:source];
        }
            break;
        case EVO_Defer:
        {
            result = [self startScriptNamed:[[script code] objectAtIndex:0] withSource:[source valueForKeyPath:[[script code] objectAtIndex:1]]];
        }
            break;
        case EVO_If:
        {
            EvoScript *conditional = [[script code] objectAtIndex:0];
            NSNumber *result1 = (NSNumber *)[self startScript:conditional withSource:source];
            if ([conditional returnType]!=EVO_Boolean) {
                result = [NSNumber numberWithBool:NO];
                NSLog(@"non boolean value passed into conditional");
            }
            else if ([result1 boolValue]) {
                result = [self startScript:[[script code] objectAtIndex:1] withSource:source];
            }
        }
            break;
        case EVO_IfElse:
        {
            EvoScript *conditional = [[script code] objectAtIndex:0];
            if ([conditional returnType]!=EVO_Boolean) {
                result = [NSNumber numberWithBool:NO];
                NSLog(@"non boolean value passed into conditional");
            }
            else if ([(NSNumber *)[self startScript:conditional withSource:source] boolValue]) {
                result = [self startScript:[[script code] objectAtIndex:1] withSource:source];
            }
            else {
                result = [self startScript:[[script code] objectAtIndex:2] withSource:source];
            }
        }
            break;
        case EVO_GreaterThan:
        case EVO_LessThan:
        case EVO_EqualTo:
        {
            NSNumber *result1;
            NSNumber *result2;
            if ([[[script code] objectAtIndex:0] isKindOfClass:[EvoScript class]]) {
                result1 = (NSNumber *)[self startScript:[[script code] objectAtIndex:0] withSource:source];
            }
            else {
                result1 = [f numberFromString:[[script code] objectAtIndex:0]];
            }
            if ([[[script code] objectAtIndex:1] isKindOfClass:[EvoScript class]]) {
                result2 = (NSNumber *)[self startScript:[[script code] objectAtIndex:1] withSource:source];
            }
            else {
                result2 = [f numberFromString:[[script code] objectAtIndex:1]];
            }
            
            if ([script function] == EVO_GreaterThan) {
                result = [NSNumber numberWithBool:([result1 compare:result2] == NSOrderedDescending)];
            }
            else if ([script function] == EVO_LessThan) {
                result = [NSNumber numberWithBool:([result1 compare:result2] == NSOrderedAscending)];
            }
            else {
                result = [NSNumber numberWithBool:([result1 compare:result2] == NSOrderedSame)];
            }

        }
            break;
        case EVO_And:
        {
            EvoScript *conditional1 = [[script code] objectAtIndex:0];
            EvoScript *conditional2 = [[script code] objectAtIndex:1];
            
            result = [NSNumber numberWithBool:[(NSNumber *)[self startScript:conditional1 withSource:source] boolValue] &&
                      [(NSNumber *)[self startScript:conditional2 withSource:source] boolValue]];

        }
            break;
        case EVO_Or:
        {
            EvoScript *conditional1 = [[script code] objectAtIndex:0];
            EvoScript *conditional2 = [[script code] objectAtIndex:1];
            
            result = [NSNumber numberWithBool:[(NSNumber *)[self startScript:conditional1 withSource:source] boolValue] ||
                      [(NSNumber *)[self startScript:conditional2 withSource:source] boolValue]];
        }
            break;
        case EVO_Not:
        {
            EvoScript *conditional1 = [[script code] objectAtIndex:0];
            
            result = [NSNumber numberWithBool:![(NSNumber *)[self startScript:conditional1 withSource:source] boolValue]];
        }
            break;
        default:
            break;
    }
    
    //NSLog(@"%@",result);
    
    return result;
}

@end
