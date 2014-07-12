//
//  EvoBodyPart.h
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoTissue.h"
@class EvoCreature;

@interface EvoBodyPart : NSObject

@property NSString *name;
@property NSUInteger ID;
@property NSString *type;
@property NSString *function;
@property (weak) EvoCreature *creature;
@property NSMutableArray *tissues;
@property NSHashTable *attachedParts;

@property Boolean isFunctional;
@property (nonatomic) CGFloat damage;
@property (nonatomic) CGFloat mass;
@property (nonatomic) CGFloat volume;


-(EvoBodyPart *) initWithID:(NSUInteger)ID;
-(void) addTissue:(EvoTissue *)tissue;
-(void) removeTissue:(EvoTissue *)tissue;
-(void) attachToPart:(EvoBodyPart *)part;
-(void) detachFromPart:(EvoBodyPart *)part;
-(void) updatePart;
-(CGFloat) getCumulativeDamage;

@end
