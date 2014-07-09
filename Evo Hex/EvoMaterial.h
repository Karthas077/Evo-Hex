//
//  EvoMaterial.h
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvoMaterial : NSObject

@property NSString *name;
@property NSUInteger ID;
@property CGFloat density;

- (EvoMaterial *) initFromFile:(NSString *) file;

@end
