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
    NSString *relativePath;
    
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
                //Updating .dat files
                NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:relativePath]];
                NSString *file;
                while ((file = [dirEnum nextObject])) {
                    NSString *libraryPath = [[appSupportPath stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:[file lastPathComponent]];
                    NSString *bundlePath = [[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:file];
                    if ([fileManager fileExistsAtPath:libraryPath isDirectory:NO]) {
                        [fileManager removeItemAtPath:libraryPath error:nil];
                    }
                    if(![fileManager copyItemAtPath:bundlePath toPath:libraryPath error:&error]) {
                        NSLog(@"%@: %@", file, error.localizedDescription);
                        return NO;
                    }
                }
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
    //Archiving Disabled until properly Profiled
    /*NSString *archivePath = [[file stringByDeletingPathExtension] stringByAppendingPathExtension:@"arc"];
    if ([[[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil] objectForKey:NSFileModificationDate] compare:
         [[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] objectForKey:NSFileModificationDate]] == NSOrderedAscending) {
        
        NSLog(@"Loading %@", [archivePath lastPathComponent]);
        //Load From Archive!
        
        EvoScript *newScript = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return newScript;
    }*/
    
    NSLog(@"Compiling %@", [file lastPathComponent]);
    //store[script:targetName:targetKey]
    //storelocal[script:key]
    //retrieve[targetName:targetKey]
    //retrievelocal[key]
    //evaluate[expression:parameters:...]
    //random[min:max]
    //run[script1:script2:...]
    //delay[script:time]
    //repeat[script:time]
    //call[scriptName]
    //defer[script:newsource]
    //if[conditional:true]
    //ifelse[conditional:true:false]
    //lessthan[object1:object2]
    //greaterthan[object1:object2]
    //equalto[object1:object2]
    //and[conditional]
    //not[conditional]
    
    EvoScript *newScript;
    
    NSError *error = nil;
    NSMutableString *contents = [[NSMutableString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
    NSInteger returnType = [[contents substringToIndex:[contents rangeOfString:@"\n"].location] integerValue];
    contents = [[contents substringFromIndex:[contents rangeOfString:@"\n"].location+1] mutableCopy];
    NSInteger numArgs = [[contents substringToIndex:[contents rangeOfString:@"\n"].location] integerValue];
    contents = [[contents substringFromIndex:[contents rangeOfString:@"\n"].location+1] mutableCopy];
    
    NSArray *whitelessArray = [contents componentsSeparatedByCharactersInSet :[NSCharacterSet characterSetWithCharactersInString:@" \t\n"]];
    contents = [[whitelessArray componentsJoinedByString:@""] mutableCopy];
    
    //NSLog(@"Contents:\n%@", contents);
    
    NSString *label;
    
    NSMutableDictionary *codeLookup = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *labelLookup = [[NSMutableDictionary alloc] init];
    NSInteger function = EVO_NumFunctions;
    for (int i = 0; i < EVO_NumFunctions; i++) {
        if ([functions[i] isEqualToString:label]) {
            function = i;
            break;
        }
    }
    
    newScript = [[EvoScript alloc] init];
    
    [newScript setName:[[file lastPathComponent] stringByDeletingPathExtension]];
    [newScript setReturnType:returnType];
    [newScript setNumArgs:numArgs];
    
    
    while ([contents rangeOfString:@"qrrbrblll"].location != 0) {
        //NSLog(@"Contents:\n%@", contents);
        NSRange labelStart = [contents rangeOfString:@"^" options:NSBackwardsSearch range:NSMakeRange(0, [contents length])];
        NSRange subscriptStart = [contents rangeOfString:@"[" options:NSBackwardsSearch range:NSMakeRange(0, [contents length])];
        NSRange subscriptEnd = [contents rangeOfString:@"]" options:0 range:NSMakeRange(subscriptStart.location, [contents length] - subscriptStart.location)];
        NSRange subscript = NSMakeRange(subscriptStart.location, subscriptEnd.location - subscriptStart.location + 1);
        NSRange labelRange = NSMakeRange(labelStart.location, subscriptStart.location - labelStart.location);
        NSString *match = [contents substringWithRange:subscript];
        NSString *replacement = [NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)[codeLookup count]];
        label = [contents substringWithRange:NSMakeRange(labelRange.location + 1,labelRange.length - 1)];
        if ([label isEqualToString:@""]) {
            label = @"evaluate";
        }
        for (int i = 0; i < EVO_NumFunctions; i++) {
            if ([functions[i] isEqualToString:label]) {
                function = i;
                break;
            }
        }
        
        //NSLog(@"for label:%@ replacing:%@ with:%@", label, match, replacement);
        
        [codeLookup setObject:[[match substringWithRange:NSMakeRange(1, [match length]-2)]componentsSeparatedByString:@":"] forKey:replacement];
        [labelLookup setObject:[NSNumber numberWithInt:function] forKey:replacement];
        
        // make the replacement
        [contents replaceCharactersInRange:subscript withString:replacement];
        [contents replaceCharactersInRange:labelRange withString:@""];
    }
    
    NSMutableArray *scriptData;
    NSMutableArray *tempArray;
    NSUInteger numReplacements = [codeLookup count];
    NSString *testString = @"qrrbrblll0";
    EvoScript *subScript;
    
    for (NSUInteger i=1; i<numReplacements; i++) {
        testString = [NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)i];
        tempArray = [[codeLookup objectForKey:testString] mutableCopy];
        for (NSUInteger j=0; j<[tempArray count]; j++) {
            NSRange tempRange = [[tempArray objectAtIndex:j] rangeOfString:@"qrrbrblll"];
            if (tempRange.location != NSNotFound) {
                NSUInteger toReplace = [[[tempArray objectAtIndex:j] substringFromIndex:(tempRange.location + tempRange.length)] integerValue];
                function = [[labelLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)toReplace]] integerValue];
                subScript = [[EvoScript alloc] init];
                [subScript setFunction:function];
                [subScript setCode:[codeLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)toReplace]]];
                [subScript setReturnType:returnValues[function]];
                [tempArray setObject:subScript atIndexedSubscript:j];
            }
        }
        [codeLookup setObject:tempArray forKey:testString];
    }
    
    scriptData = [[codeLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)[codeLookup count]-1]] mutableCopy];
    
    //NSLog(@"%@", scriptData);
    
    [newScript setCode:scriptData];
    [newScript setFunction:[[labelLookup objectForKey:[NSString stringWithFormat:@"qrrbrblll%lu", (unsigned long)[codeLookup count]-1]] integerValue]];
    //NSLog(@"Created script named %@ with label %@", [[file lastPathComponent] stringByDeletingPathExtension], label);
    
    
    //[NSKeyedArchiver archiveRootObject:newScript toFile:archivePath];
    
    return newScript;
}

@end
