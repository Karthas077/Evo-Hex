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
                NSLog(@"Does not exist");
            }
            if ([fileManager fileExistsAtPath:[appSupportPath stringByAppendingPathComponent:relativePath] isDirectory:NULL]) {
                NSLog(@"Already Installed");
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
    NSString *functionsPath = [modulePath stringByAppendingPathComponent:@"functions"];
    NSString *bodyPartsPath = [modulePath stringByAppendingPathComponent:@"bodyParts"];
    NSString *evolutionsPath = [modulePath stringByAppendingPathComponent:@"evolutions"];
    NSString *creaturesPath = [modulePath stringByAppendingPathComponent:@"creatures"];
    
    return [[NSArray alloc] initWithObjects:materialsPath, tissuesPath, functionsPath, bodyPartsPath, evolutionsPath, creaturesPath, nil];
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

- (NSArray *) loadFunctions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *functions = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:gameDataPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([@"functions" isEqualToString:[[file stringByDeletingLastPathComponent] lastPathComponent]] &&
            [activeMods containsObject:[[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [functions addObject:[self parseCreatureFunction: [[gameDataPath stringByAppendingPathComponent:@"functions"] stringByAppendingPathComponent:file]]];
        }
    }
    
    return [functions copy];
}

- (EvoCreatureFunction *) parseCreatureFunction:(NSString *) file
{
    return [[EvoCreatureFunction alloc] init];
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

@end
