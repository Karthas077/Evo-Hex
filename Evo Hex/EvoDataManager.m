//
//  EvoDataManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoDataManager.h"


@implementation EvoDataManager

@synthesize activeMods;
@synthesize appSupportPath;
@synthesize gameDataPath;

#pragma mark Singleton Methods

+ (id) dataManager
{
    static EvoDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        appSupportPath = [[NSString alloc] init];
        
        appSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        
        gameDataPath = [appSupportPath stringByAppendingPathComponent:@"Data"];
    }
    return self;
}

- (BOOL) setupDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:appSupportPath isDirectory:NULL]) {
        if (![fileManager createDirectoryAtPath:appSupportPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"1 %@", error.localizedDescription);
            return NO;
        }
        else {
            NSURL *url = [NSURL fileURLWithPath:appSupportPath];
            if (![url setResourceValue:@YES
                                forKey:NSURLIsExcludedFromBackupKey
                                 error:&error]) {
                NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error.localizedDescription);
                return NO;
            }
        }
    }
    if (![fileManager fileExistsAtPath:gameDataPath isDirectory:NULL]) {
        if (![fileManager createDirectoryAtPath:gameDataPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error creating Data directory");
            return NO;
        }
    }
    return YES;
}

- (void) setModList:(NSArray *)modList
{
    activeMods = modList;
}

- (BOOL) setupModules
{
    NSLog(@"Installing Modules:");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *relativePath = [[NSString alloc] init];
    
    for (NSString *module in activeMods) {
        NSLog(@"%@", module);
        
        relativePath = [@"Data" stringByAppendingPathComponent:module];
        
        if (![fileManager fileExistsAtPath:[appSupportPath stringByAppendingPathComponent:relativePath] isDirectory:NULL]) {
            if (![fileManager createDirectoryAtPath:[appSupportPath stringByAppendingPathComponent:relativePath] withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"Error creating Data directory");
                return NO;
            }
        }
        
        for (NSString *file in [self getModuleData:module]) {
            relativePath = [@"Data" stringByAppendingPathComponent:file];
            if (![fileManager fileExistsAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:relativePath] isDirectory:NULL]) {
                NSLog(@"%@ Does not exist", [file lastPathComponent]);
            }
            if ([fileManager fileExistsAtPath:[appSupportPath stringByAppendingPathComponent:relativePath] isDirectory:NULL]) {
                NSLog(@"%@ Already Installed", [file lastPathComponent]);
            }
            else if(![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:relativePath] toPath:[appSupportPath stringByAppendingPathComponent:relativePath] error:&error]) {
                
                NSLog(@"%@: %@", [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:relativePath], error.localizedDescription);
                return NO;
            }
        }
    }
    return YES;
}

- (NSArray *) getModuleData:(NSString *)moduleName
{
    NSString *modulePath = moduleName;
    NSString *materialsPath = [modulePath stringByAppendingPathComponent:@"materials"];
    NSString *tissuesPath = [modulePath stringByAppendingPathComponent:@"tissues"];
    NSString *bodyPartsPath = [modulePath stringByAppendingPathComponent:@"bodyParts"];
    NSString *evolutionsPath = [modulePath stringByAppendingPathComponent:@"evolutions"];
    NSString *creaturesPath = [modulePath stringByAppendingPathComponent:@"creatures"];
    NSString *scriptsPath = [modulePath stringByAppendingPathComponent:@"scripts"];
    
    return [[NSArray alloc] initWithObjects:materialsPath, tissuesPath, bodyPartsPath, evolutionsPath, creaturesPath, scriptsPath, nil];
}

- (NSArray *) loadMaterials
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *materials = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"materials" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [materials addObject:[self parseMaterial: [[gameDataPath stringByAppendingPathComponent:@"materials"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [materials copy];
}

- (EvoMaterial *) parseMaterial:(NSString *) file
{
    //
    return [[EvoMaterial alloc] init];
}

- (NSArray *) loadTissues
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *tissues = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"tissues" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [tissues addObject:[self parseTissue: [[gameDataPath stringByAppendingPathComponent:@"tissues"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [tissues copy];
}

- (EvoTissue *) parseTissue:(NSString *) file
{
    return [[EvoTissue alloc] init];
}

- (NSArray *) loadBodyParts
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *bodyParts = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"bodyParts" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [bodyParts addObject:[self parseBodyPart: [[gameDataPath stringByAppendingPathComponent:@"bodyParts"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [bodyParts copy];
}

- (EvoBodyPart *) parseBodyPart:(NSString *) file
{
    return [[EvoBodyPart alloc] init];
}

- (NSArray *) loadEvolutions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *evolutions = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"evolutions" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [evolutions addObject:[self parseEvolution: [[gameDataPath stringByAppendingPathComponent:@"evolutions"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [evolutions copy];
}

- (EvoEvolution *) parseEvolution:(NSString *) file
{
    return [[EvoEvolution alloc] init];
}

- (NSArray *) loadCreatures
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *creatures = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"creatures" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [creatures addObject:[self parseCreature: [[gameDataPath stringByAppendingPathComponent:@"creatures"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [creatures copy];
}

- (EvoCreature *) parseCreature:(NSString *) file
{
    return [[EvoCreature alloc] init];
}

- (NSArray *) loadScripts
{
    NSLog(@"LoadingScripts");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *scripts = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"scripts" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [scripts addObject:[self parseScript: [gameDataPath stringByAppendingPathComponent:file]]];
        }
    }
    
    return [scripts copy];
}

- (EvoScript *) parseScript:(NSString *) file
{
    NSLog(@"Parsing Script:\n%@", file);
    //leaf:[targetName:targetKey:expression:parameters:...]
    //node:[label1:script1:source1:label2:script2:source2:...]
    //delay:[label:script:source:time]
    //repeat:[label:script:source:time]
    //call:[scriptName:source]
    //branchif:[label:conditional:source:label:true:source:label:false:source]
    //lessthan:[object1:object2]
    //greaterthan:[object1:object2]
    //equalto:[object1:object2]
    //not:[label:conditional:source]
    
    NSError *error = nil;
    NSString *contents = [[NSString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    NSString *label = [contents substringToIndex:[contents rangeOfString:@":"].location];
    //NSLog(@"Label:\n%@", label);
    contents = [contents substringFromIndex:[contents rangeOfString:@":"].location+1];
    //NSLog(@"Contents:\n%@", contents);
    
    NSMutableDictionary *reverseLookup = [[NSMutableDictionary alloc] init];
    
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[([a-zA-Z0-9%+-]+:?)+\\]"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    NSMutableString* mutableString = [contents mutableCopy];
    
    //NSLog(@"Beginning regex");
    
    while ([contents rangeOfString:@"qrrbrblll"].location != 0) {
        //NSLog(@"Contents:\n%@", contents);
        NSInteger offset = 0; // keeps track of range changes in the string
        // due to replacements.
        for (NSTextCheckingResult* result in [regex matchesInString:contents
                                                            options:0
                                                              range:NSMakeRange(0, [contents length])]) {
            
            NSRange resultRange = [result range];
            resultRange.location += offset; // resultRange.location is updated
            // based on the offset updated below
            
            // implement your own replace functionality using
            // replacementStringForResult:inString:offset:template:
            // note that in the template $0 is replaced by the match
            NSString* match = [regex replacementStringForResult:result
                                                       inString:mutableString
                                                         offset:offset
                                                       template:@"$0"];
            
            NSString* replacement = [NSString stringWithFormat:@"qrrbrblll%d", [reverseLookup count]];
            
            //NSLog(@"replacing:%@ with:%@", match, replacement);
            
            [reverseLookup setObject:[[match substringWithRange:NSMakeRange(1, [match length]-2)]componentsSeparatedByString:@":"] forKey:replacement];
            
            // make the replacement
            [mutableString replaceCharactersInRange:resultRange withString:replacement];
            
            // update the offset based on the replacement
            offset += ([replacement length] - resultRange.length);
        }
        
        contents = [mutableString copy];
    }
    
    NSMutableArray *scriptData = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSUInteger numReplacements = [reverseLookup count];
    NSString *testString = @"qrrbrblll0";
    
    for (NSUInteger i=1; i<numReplacements; i++) {
        testString = [NSString stringWithFormat:@"qrrbrblll%d", i];
        tempArray = [[reverseLookup objectForKey:testString] mutableCopy];
        for (NSUInteger j=1; j<[tempArray count]; j++) {
            NSRange tempRange = [[tempArray objectAtIndex:j] rangeOfString:@"qrrbrblll"];
            if (tempRange.location == NSNotFound) {
                continue;
            }
            else {
                NSUInteger toReplace = [[[tempArray objectAtIndex:j] substringFromIndex:(tempRange.location + tempRange.length)] integerValue];
                [tempArray setObject:[reverseLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%d", toReplace]] atIndexedSubscript:j];
            }
        }
        [reverseLookup setObject:tempArray forKey:testString];
    }
    
    scriptData = [[reverseLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%d", [reverseLookup count]-1]] mutableCopy];
    
    EvoScript *newScript = [[EvoScript alloc] initScript:[scriptData copy]];
    [newScript setLabel:label];
    [newScript setName:[[file lastPathComponent] stringByDeletingPathExtension]];
    NSLog(@"Created script named %@ with label %@", [[file lastPathComponent] stringByDeletingPathExtension], label);
    
    
    return newScript;
}

@end
