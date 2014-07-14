//
//  EvoScript.h
//  Evo Hex
//
//  Created by Steven Buell on 7/12/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, scriptFunction)
{
    EVO_Store = 0,
    EVO_StoreLocal,
    EVO_Retrieve,
    EVO_RetrieveLocal,
    EVO_Evaluate,
    EVO_Run,
    EVO_Delay,
    EVO_Repeat,
    EVO_Call,
    EVO_Defer,
    EVO_If,
    EVO_IfElse,
    EVO_LessThan,
    EVO_GreaterThan,
    EVO_EqualTo,
    EVO_And,
    EVO_Or,
    EVO_Not,
    EVO_NumFunctions
};

static NSString * const functions[] ={
    @"store",
    @"storelocal",
    @"retrieve",
    @"retrievelocal",
    @"evaluate",
    @"run",
    @"delay",
    @"repeat",
    @"call",
    @"defer",
    @"if",
    @"ifelse",
    @"lessthan",
    @"greaterthan",
    @"equalto",
    @"and",
    @"or",
    @"not"};

typedef NS_ENUM(NSInteger, returnType)
{
    EVO_Boolean = 0,
    EVO_String,
    EVO_Number,
    EVO_Integer,
    EVO_Float,
    EVO_Object
};

static NSInteger const returnValues[] ={
    EVO_Boolean, //store
    EVO_Boolean, //storelocal
    EVO_Object, //retrieve
    EVO_Object, //retrievelocal
    EVO_Object, //evaluate
    EVO_Boolean, //run
    EVO_Boolean, //delay
    EVO_Boolean, //repeat
    EVO_Object, //call
    EVO_Boolean, //defer
    EVO_Boolean, //if
    EVO_Boolean, //ifelse
    EVO_Boolean, //lessthan
    EVO_Boolean, //greaterthan
    EVO_Boolean, //equalto
    EVO_Boolean, //and
    EVO_Boolean, //or
    EVO_Boolean
}; //not

@interface EvoScript : NSObject <NSCoding>

@property NSString *name;
@property NSInteger function;
@property NSArray *code;
@property NSInteger numArgs;
@property NSInteger returnType;

@end
