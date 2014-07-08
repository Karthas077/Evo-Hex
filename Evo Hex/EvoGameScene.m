#import "EvoGameScene.h"

@interface EvoGameScene ()
@property BOOL gameOver;
@end

@implementation EvoGameScene

static void *deathWatch = &deathWatch;

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    self.backgroundColor =
        [SKColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.0];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    _world = [[SKNode alloc] init];
    [_world setName:@"World"];
    
    _map = [[HexGrid alloc] init];
    [_map setName:@"HexGrid"];
    [_map setPosition:CGPointMake(0, 0)];
    [_map setZPosition:0];

    //_player = [[EvoKnight alloc] init];
    //[_player setName:@"Player"];
    //[_player setPosition:CGPointMake(0, 0)];
    //[_player setZPosition:10];
    
    [_world addChild:_map];
    //[_world addChild:_player];
    
    _ui = [[EvoUI alloc] initWithSize:size];
    
    [_ui setName:@"UI"];
    [_ui setPosition:CGPointMake(0,0)];
    [_ui setZPosition:20];

    [self addChild:_world];
    [self addChild:_ui];

    _gameOver = NO;
    
    /*[_player
        addObserver:self
         forKeyPath:@"health"
            options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
            context:deathWatch];*/
  }
  return self;
}

- (void) didChangeSize:(CGSize)oldSize
{
    [_ui redraw:oldSize];
}

- (void)didMoveToView:(SKView *)view
{
  _panRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePan:)];
  _panRecognizer.delaysTouchesBegan = YES;
  [[self view] addGestureRecognizer:_panRecognizer];
  _pinchRecognizer =
      [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePinch:)];
  _pinchRecognizer.delaysTouchesBegan = YES;
  [[self view] addGestureRecognizer:_pinchRecognizer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (_gameOver) return;
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:location];

    CGFloat distanceFromPlayer = 0.0;
    CGFloat distance = 0.0;
    CGFloat minDistance = -1.0;
    SKNode *touchedNode;
    for (SKNode<HexProtocol> *node in nodes) {
      if (![node.name isEqualToString:@"Hex"]) {
        if ([node.name isEqualToString:@"Player"]) {
          //[(EvoCharacter *)node kill];
        }
        continue;
      }
      distance = pow([node getGridLoc].x - location.x, 2) +
                 pow([node getGridLoc].y - location.y, 2);
      if (minDistance == -1.0) {
        minDistance = distance;
        //distanceFromPlayer = pow(_player.position.x - [node getGridLoc].x, 2) +
        //                     pow(_player.position.y - [node getGridLoc].y, 2);
        touchedNode = node;
      } else if (distance < minDistance) {
        minDistance = distance;
        //distanceFromPlayer = pow(_player.position.x - [node getGridLoc].x, 2) +
        //                     pow(_player.position.y - [node getGridLoc].y, 2);
        touchedNode = node;
      }
    }
    if (distanceFromPlayer > 3000.0) {
      [[(HexGrid *)[_world childNodeWithName:@"HexGrid"]
          getHexWithX:[(Hex *)touchedNode x]
                withY:[(Hex *)touchedNode y]] setType:3];
    } else if (touchedNode) {
      // adjacent
      //_player.position = [(Hex *)touchedNode getGridLoc];
    }
  }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    [recognizer setTranslation:CGPointZero inView:recognizer.view];

  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    translation = CGPointMake(-translation.x, translation.y);

    _world.position = CGPointMake(_world.position.x - translation.x,
                                  _world.position.y - translation.y);

    [recognizer setTranslation:CGPointZero inView:recognizer.view];

  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    // No code needed for panning.
  }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
  CGPoint anchorPoint = [recognizer locationInView:recognizer.view];
  anchorPoint = [self convertPointFromView:anchorPoint];

  if (recognizer.state == UIGestureRecognizerStateBegan) {
    // No code needed for zooming...

  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint anchorPointInWorld =
        [_world convertPoint:anchorPoint fromNode:self];

    [_world setScale:(_world.xScale * recognizer.scale)];

    CGPoint worldAnchorPointInScene =
        [self convertPoint:anchorPointInWorld fromNode:_world];
    CGPoint translationOfAnchorInScene =
        CGPointMake(anchorPoint.x - worldAnchorPointInScene.x,
                    anchorPoint.y - worldAnchorPointInScene.y);

    _world.position =
        CGPointMake(_world.position.x + translationOfAnchorInScene.x,
                    _world.position.y + translationOfAnchorInScene.y);

    recognizer.scale = 1.0;

  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    // No code needed here for zooming...
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  
  if (context == deathWatch) {
    //Update Health Bar
    /*[_ui.healthBar setSize:CGSizeMake(_player.health/_player.healthMax * 170, _ui.healthBar.size.height)];
    if (_player.health <= 0.0) {
      SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Damascus"];
      gameOver.zPosition = 20;
      gameOver.text = @"Game Over";
      gameOver.fontSize = 30;
      [self addChild:gameOver];
      _gameOver = YES;
    }*/
  }

    if (NO) {//[object isKindOfClass:[EvoCharacter class]]) {
    // Pass off to character manager?
  } else {
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

- (void)update:(CFTimeInterval)currentTime
{
  if (_gameOver) return;
  //Most likely never needed
}

@end
