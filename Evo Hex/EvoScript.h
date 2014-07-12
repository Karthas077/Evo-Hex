//
//  EvoScript.h
//  Evo Hex
//
//  Created by Steven Buell on 7/12/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvoScript : NSObject

@property NSString *label;
@property NSArray *script;
@property id source;

- (EvoScript *) initScript:(NSArray *)script;
- (void) execute;

@end
