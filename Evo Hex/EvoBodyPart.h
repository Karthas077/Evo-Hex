//
//  EvoBodyPart.h
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EvoCreature;

@interface EvoBodyPart : NSObject

@property NSUInteger ID;
@property (weak) EvoCreature *creature;
@property NSHashTable *bodyParts;
@property (weak) EvoBodyPart *parent;

@property Boolean isFunctional;
@property (nonatomic) CGFloat damage;
@property (nonatomic) CGFloat mass;
@property (nonatomic) CGFloat volume;


-(EvoBodyPart *) initFromFile:(NSString *)file;
-(void) attachToCreature:(EvoCreature *)creature;
-(void) remove;
-(void) attachPart:(EvoBodyPart *)part;
-(void) removePart:(EvoBodyPart *)part;
-(void) updatePart;
-(CGFloat) getCumulativeDamage;

@end
