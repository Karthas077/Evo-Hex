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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.label = [decoder decodeObjectForKey:@"label"];
    self.script = [decoder decodeObjectForKey:@"script"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.label forKey:@"label"];
    [encoder encodeObject:self.script forKey:@"script"];
}

@end
