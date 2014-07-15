#import <SpriteKit/SpriteKit.h>

#import "HexGrid.h"
#import "EvoAIManager.h"
#import "EvoDataManager.h"
#import "EvoUI.h"
#import "EvoUpgradeView.h"

@interface EvoGameScene : SKScene

@property NSNumber *mode;
//@property (nonatomic, readonly) NSMutableArray *layers;
@property SKNode *world;
@property EvoCreature *player;
@property HexGrid *map;
@property EvoUI *ui;

@property UIPanGestureRecognizer *panRecognizer;
@property UIPinchGestureRecognizer *pinchRecognizer;
@property EvoUpgradeView *upgradeView;

- (void) spawnEnemy;
- (void) presentUpgradeMenu;

@end
