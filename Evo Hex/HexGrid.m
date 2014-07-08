#import "HexGrid.h"

@implementation HexGrid

#pragma mark - Initialization
- (HexGrid *)init
{
  self = [super init];
	if (self) {
    _hexes = [NSHashTable weakObjectsHashTable];
  }
  [self recursiveHexes:3 withParent:self withX:0 withY:0 withZ:0];

	return self;
}

- (void) recursiveHexes:(NSInteger)layer withParent:(SKNode<HexProtocol> *)parent withX:(NSInteger)x withY:(NSInteger)y withZ:(NSInteger)z
{
  Hex *template = [[Hex alloc]init];
  CGPoint (^offsetHex)(NSUInteger, NSUInteger) = ^(NSUInteger index, NSUInteger layer) {
    
    if ((layer&1)==1) {
      index+=7;
    }
    
    CGFloat w = template.size.width;
    CGFloat h = template.size.height;
    
    NSArray *offsetScale = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                            [NSValue valueWithCGPoint:CGPointMake(0, 1.0)],
                            [NSValue valueWithCGPoint:CGPointMake(-0.75, 0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(0.75, 0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(-0.75, -0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(0.75, -0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(0, -1.0)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                            [NSValue valueWithCGPoint:CGPointMake(-0.75, 2.5)],
                            [NSValue valueWithCGPoint:CGPointMake(1.5, 2.0)],
                            [NSValue valueWithCGPoint:CGPointMake(-2.25, 0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(2.25, -0.5)],
                            [NSValue valueWithCGPoint:CGPointMake(-1.5, -2.0)],
                            [NSValue valueWithCGPoint:CGPointMake(0.75, -2.5)],
                            nil];
    
    w = pow(7,layer/2)*w*[[offsetScale objectAtIndex:index] CGPointValue].x;
    h = pow(7,layer/2)*h*[[offsetScale objectAtIndex:index] CGPointValue].y;
    //NSLog(@"w = %f",w);
    //NSLog(@"h = %f",h);
    return CGPointMake(w,h);
  };
  
  NSInteger xcoordOffsets[14] = {0, 0,-1, 1,-1, 1, 0, 0,-1, 2,-3, 3,-2, 1};
  NSInteger ycoordOffsets[14] = {0, 1, 1, 0, 0,-1,-1, 0, 3, 1, 2,-2,-1,-3};
  NSInteger zcoordOffsets[14] = {0,-1, 0,-1, 1, 0, 1, 0,-2,-3, 1,-1, 3, 2};
  int r;
  
  for (int i=0; i<7; i++) {
    SKNode<HexProtocol> *newHex;
    if(layer==0) {
      newHex = [[Hex alloc]initWithX:x+xcoordOffsets[i] withY:y+ycoordOffsets[i] withZ:z+zcoordOffsets[i]];
      newHex.name = @"Hex";
      [newHex setAnchorPoint:CGPointMake(0.5,0.5)];
      [newHex setPosition:offsetHex(i, layer)];
      [newHex setGridLoc:[parent getGridLoc]];
      
      r = arc4random() % 4;
      [(Hex*)newHex setType:r];
      
      [_hexes addObject:newHex];
      [parent addChild:newHex];
    }
    else {
      newHex = [[SuperHex alloc]init];
      [newHex setPosition:offsetHex(i, layer)];
      [newHex setGridLoc:[parent getGridLoc]];
      
      if ((layer&1)==0) {
        [self recursiveHexes:layer-1 withParent:newHex
                       withX:x+pow(7,layer/2)*xcoordOffsets[i]
                       withY:y+pow(7,layer/2)*ycoordOffsets[i]
                       withZ:z+pow(7,layer/2)*zcoordOffsets[i]];
      }
      else {
        [self recursiveHexes:layer-1 withParent:newHex
                       withX:x+pow(7,layer/2)*xcoordOffsets[i+7]
                       withY:y+pow(7,layer/2)*ycoordOffsets[i+7]
                       withZ:z+pow(7,layer/2)*zcoordOffsets[i+7]];
      }
      
      [parent addChild:newHex];
    }
  }
}

- (Hex*) getHexWithX:(NSInteger)x withY:(NSInteger)y
{
  return [_hexes member:[[Hex alloc]initWithX:x withY:y withZ:0]];
}

/*- (void) spawnCharacter:(EvoCharacter *)character atHex:(Hex *)hex
{
  
}*/

-(void) setAnchorPoint:(CGPoint)anchorPoint
{
  return;
}

-(void) setPosition:(CGPoint)position
{
  [super setPosition:position];}

- (void)setGridLoc:(CGPoint)gridLoc
{
  self.position = gridLoc;
}

- (CGPoint)getGridLoc
{
  return self.position;
}

- (void)didSimulatePhysics
{
	//Procedurally generate Hexes
	//Hex *newHex = [[Hex alloc] init];
}

@end
