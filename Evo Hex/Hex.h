#import <SpriteKit/SpriteKit.h>
#import "HexProtocol.h"
@class EvoObject;

typedef NS_ENUM(NSInteger, HexType)
{
  InvalidHex = -1,
  GrassHex = 0,
  MountainHex = 1,
  SandHex = 2,
  WaterHex = 3
};

static NSString * const hexTextures[] =
 {@"Assets/Tiles/Grass_Hex.png",
  @"Assets/Tiles/Mountain_Hex.png",
  @"Assets/Tiles/Sand_Hex.png",
  @"Assets/Tiles/Water_Hex.png"};

@interface Hex : SKSpriteNode <HexProtocol>

@property (nonatomic) CGPoint gridLoc;
@property (nonatomic) NSInteger type;
@property (weak) EvoObject *contents;
@property NSInteger x;
@property NSInteger y;
@property NSInteger z;

- (Hex*) initWithX:(NSInteger)x withY:(NSInteger)y withZ:(NSInteger)z;

- (void) setGridLoc:(CGPoint) pos;

@end
