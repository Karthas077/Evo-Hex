//
//  EvoUpgradeView.m
//  Evo Hex
//
//  Created by Steven Buell on 7/14/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoUpgradeView.h"

@implementation EvoUpgradeView

SKSpriteNode *container;

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        [[self layer] setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
        [[self layer] setCornerRadius:12];
        [[self layer] setOpacity:0.8];
        //[[self layer] setBackgroundFilter:blurFilter];
        /*CAShapeLayer *background = [CAShapeLayer layer];
        [background setName:@"upgradeMenu"];
        [background setStrokeColor:[UIColor darkGrayColor].CGColor];
        [background setFillColor:[UIColor darkGrayColor].CGColor];
        [background setOpacity:0.8];
        
        CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(self.frame.size.width/20, self.frame.size.height/20, self.frame.size.width*9/10, self.frame.size.height*9/10), 16, 16, NULL);
        [background setPath:path];
        CGPathRelease(path);*/
        
        _creatureInfo = [[UILabel alloc] init];
        [_creatureInfo setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height*2/5)];
        [_creatureInfo setBounds:CGRectInset(self.frame, 10, 10)];
        [_creatureInfo setTextAlignment:NSTextAlignmentLeft];
        [_creatureInfo setTextColor:[UIColor whiteColor]];
        [_creatureInfo setFont:[UIFont systemFontOfSize:28]];
        
        _accept = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accept setTitle:@"Accept" forState:UIControlStateNormal];
        [_accept setEnabled:NO];
        [_accept setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [_accept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_accept setContentScaleFactor:2];
        [_accept setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
        [_accept sizeToFit];
        [_accept setCenter:CGPointMake(self.frame.size.width/4, self.frame.size.height*9/10)];
        [_accept setBackgroundImage:[[UIImage imageNamed:@"Assets/UI/whiteBar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]
                          forState:UIControlStateNormal];
        [_accept setBackgroundImage:[[UIImage imageNamed:@"Assets/UI/whiteBar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]
                          forState:UIControlStateDisabled];
        [_accept setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancel setTitle:@"Cancel" forState:UIControlStateHighlighted];
        [_cancel setContentScaleFactor:2];
        [_cancel setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
        [_cancel sizeToFit];
        [_cancel setCenter:CGPointMake(self.frame.size.width*3/4, self.frame.size.height*9/10)];
        [_cancel setBackgroundImage:[[UIImage imageNamed:@"Assets/UI/whiteBar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]
                          forState:UIControlStateNormal];
        [_cancel setShowsTouchWhenHighlighted:NO];

        
        /*[[button layer] setCornerRadius:6];
         [[button layer] setBorderWidth:2.0f];
         [[button layer] setBorderColor:[[UIColor greenColor] CGColor]];*/
        
        /*[[button layer] setMasksToBounds:NO];
         [[button layer] setShadowColor:[[UIColor greenColor] CGColor]];//[[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0] CGColor]];
         [[button layer] setShadowOpacity:1];
         [[button layer] setShadowRadius:64];
         [[button layer] setShadowOffset:CGSizeMake(32, 32)];*/
        
        //[self.layer addSublayer:background];
        [self addSubview:_creatureInfo];
        [self addSubview:_accept];
        [self addSubview:_cancel];
    }
    return self;
}

- (void) redraw
{
    
}

@end
