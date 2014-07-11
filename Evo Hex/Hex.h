#import <SpriteKit/SpriteKit.h>
#import "HexProtocol.h"

typedef NS_ENUM(NSInteger, HexType)
{
  InvalidHex = -1,
  GrassHex = 0,
  MountainHex = 1,
  SandHex = 2,
  WaterHex = 3
};

static NSString * const hexTextures[] =
 {@"Grass_Hex",
  @"Mountain_Hex",
  @"Sand_Hex",
  @"Water_Hex"};

@interface Hex : SKSpriteNode <HexProtocol>

@property (nonatomic) CGPoint gridLoc;
@property (nonatomic) NSInteger type;
@property SKSpriteNode *contents;
@property NSInteger x;
@property NSInteger y;
@property NSInteger z;

- (Hex*) initWithX:(NSInteger)x withY:(NSInteger)y withZ:(NSInteger)z;

- (void) setGridLoc:(CGPoint) pos;

@end
