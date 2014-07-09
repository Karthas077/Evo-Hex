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
@synthesize materialsPath;
@synthesize tissuesPath;
@synthesize bodyPartsPath;
@synthesize functionsPath;
@synthesize creaturesPath;
@synthesize evolutionsPath;

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
        materialsPath = [[NSString alloc] init];
        tissuesPath = [[NSString alloc] init];
        bodyPartsPath = [[NSString alloc] init];
        functionsPath = [[NSString alloc] init];
        creaturesPath = [[NSString alloc] init];
        evolutionsPath = [[NSString alloc] init];
        
        appSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        materialsPath = [appSupportPath stringByAppendingPathComponent:@"materials"];
        tissuesPath = [appSupportPath stringByAppendingPathComponent:@"tissues"];
        bodyPartsPath = [appSupportPath stringByAppendingPathComponent:@"bodyParts"];
        functionsPath = [appSupportPath stringByAppendingPathComponent:@"functions"];
        creaturesPath = [appSupportPath stringByAppendingPathComponent:@"creatures"];
        evolutionsPath = [appSupportPath stringByAppendingPathComponent:@"evolutions"];
    }
    return self;
}

- (BOOL) setupDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:appSupportPath isDirectory:NULL]) {
        if (![fileManager createDirectoryAtPath:appSupportPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"%@", error.localizedDescription);
            return NO;
        }
        else {
            NSURL *url = [NSURL fileURLWithPath:appSupportPath];
            if (![url setResourceValue:@YES
                                forKey:NSURLIsExcludedFromBackupKey
                                 error:&error]) {
                NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error.localizedDescription);
            }
        }
    }
    if (![fileManager fileExistsAtPath:materialsPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"materials"] toPath:materialsPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    if (![fileManager fileExistsAtPath:tissuesPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"tissues"] toPath:tissuesPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    if (![fileManager fileExistsAtPath:bodyPartsPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"bodyParts"] toPath:bodyPartsPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    if (![fileManager fileExistsAtPath:functionsPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"functions"] toPath:functionsPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    if (![fileManager fileExistsAtPath:creaturesPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"creatures"] toPath:creaturesPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    if (![fileManager fileExistsAtPath:evolutionsPath isDirectory:NULL] ||
        ![fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"evolutions"] toPath:evolutionsPath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    return YES;
}

- (void) setModList:(NSArray *)modList
{
    activeMods = modList;
}

- (NSArray *) loadMaterials
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *materials = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:materialsPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [materials addObject:[self parseMaterial: [materialsPath stringByAppendingPathComponent:file]]];
        }
    }
    
    return [materials copy];
}

- (EvoMaterial *) parseMaterial:(NSString *) file
{
    return [[EvoMaterial alloc] init];
}

- (NSArray *) loadTissues
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *tissues = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:tissuesPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [tissues addObject:[self parseTissue: [tissuesPath stringByAppendingPathComponent:file]]];
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
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:bodyPartsPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [bodyParts addObject:[self parseBodyPart: [bodyPartsPath stringByAppendingPathComponent:file]]];
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
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:functionsPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [functions addObject:[self parseCreatureFunction: [functionsPath stringByAppendingPathComponent:file]]];
        }
    }
    
    return [functions copy];
}

- (EvoCreatureFunction *) parseCreatureFunction:(NSString *) file
{
    return [[EvoCreatureFunction alloc] init];
}

- (NSArray *) loadCreatures
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *creatures = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:creaturesPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [creatures addObject:[self parseCreature: [creaturesPath stringByAppendingPathComponent:file]]];
        }
    }
    
    return [creatures copy];
}

- (EvoCreature *) parseCreature:(NSString *) file
{
    return [[EvoCreature alloc] init];
}

- (NSArray *) loadEvolutions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *evolutions = [[NSMutableArray alloc]init];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:evolutionsPath];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([activeMods containsObject:[file stringByDeletingLastPathComponent]] &&
            [[file pathExtension] isEqualToString: @"dat"]) {
            [evolutions addObject:[self parseEvolution: [evolutionsPath stringByAppendingPathComponent:file]]];
        }
    }
    
    return [evolutions copy];
}

- (EvoEvolution *) parseEvolution:(NSString *) file
{
    return [[EvoEvolution alloc] init];
}

@end
