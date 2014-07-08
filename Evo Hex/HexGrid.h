#import <SpriteKit/SpriteKit.h>
#import "Hex.h"
#import "SuperHex.h"

@interface HexGrid : SKNode <HexProtocol>

@property NSHashTable *hexes;

- (Hex*) getHexWithX:(NSInteger)x withY:(NSInteger)y;

//- (void) spawnCreature:(EvoCreature*)creature atHex:(Hex*)hex;

@end
