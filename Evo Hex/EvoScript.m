//
//  EvoScript.m
//  Evo Hex
//
//  Created by Steven Buell on 7/12/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoScript.h"

@implementation EvoScript

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.function = [decoder decodeIntegerForKey:@"function"];
    self.code = [decoder decodeObjectForKey:@"code"];
    self.numArgs = [decoder decodeIntegerForKey:@"numArgs"];
    self.returnType = [decoder decodeIntegerForKey:@"returnType"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.function forKey:@"function"];
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeInteger:self.numArgs forKey:@"numArgs"];
    [encoder encodeInteger:self.returnType forKey:@"returnType"];
}

- (NSString *) description
{
    NSString *result = @"";
    for (NSObject *obj in _code) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@", obj]];
    }
    return result;
}

@end
