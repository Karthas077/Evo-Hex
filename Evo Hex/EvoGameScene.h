#import <SpriteKit/SpriteKit.h>

#import "HexGrid.h"
#import "EvoCreatureManager.h"
#import "EvoUI.h"

@interface EvoGameScene : SKScene

@property NSNumber *mode;
//@property (nonatomic, readonly) NSMutableArray *layers;
@property SKNode *world;
@property EvoCreature *player;
@property HexGrid *map;
@property EvoUI *ui;

@property UIPanGestureRecognizer *panRecognizer;
@property UIPinchGestureRecognizer *pinchRecognizer;

@end
