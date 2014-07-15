#import "EvoGameScene.h"

@interface EvoGameScene ()
@property BOOL gameOver;
@property BOOL gamePaused;
@end

@implementation EvoGameScene

static void *deathWatch = &deathWatch;

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor =
        [SKColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.0];
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blurFilter setDefaults];
        [blurFilter setValue:[NSNumber numberWithFloat:10] forKey: @"inputRadius"];
        [self setFilter:blurFilter];
        
        _world = [[SKNode alloc] init];
        [_world setName:@"World"];
        
        _map = [[HexGrid alloc] init];
        [_map setName:@"HexGrid"];
        [_map setPosition:CGPointMake(0, 0)];
        [_map setZPosition:0];
        
        _player = [[EvoCreatureManager creatureManager] spawnCreatureWithType:@"primate"];
        
        
        Hex *playerSpawn = [_map getHexWithX:0 withY:0];
        
        [_player setName:@"Player"];
        [_player setHex: playerSpawn];
        [_player setScale:0.4];
        [playerSpawn setContents: _player];
        [_player setPosition:[playerSpawn getGridLoc]]; //
        [_player setZPosition:10];
        
        [_world addChild:_map];
        [_world addChild:_player];
        
        _ui = [[EvoUI alloc] initWithSize:size];
        
        [_ui setName:@"UI"];
        [_ui setPosition:CGPointMake(0,0)];
        [_ui setZPosition:20];
        
        [self addChild:_world];
        [self addChild:_ui];
        
        _gameOver = NO;
        _gamePaused = NO;
        
        [_player
         addObserver:self
         forKeyPath:@"health"
         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
         context:deathWatch];
        [_player
         addObserver:self
         forKeyPath:@"stamina"
         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
         context:deathWatch];
        [_player
         addObserver:self
         forKeyPath:@"biomass"
         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
         context:deathWatch];
        
        [_player setValue:[_player valueForKey:@"biomass"] forKeyPath:@"biomass"];
        [_player setValue:[NSNumber numberWithFloat:0] forKeyPath:@"points"];
        do {
            [self spawnEnemy];
        } while ([[[EvoAIManager AIManager] creatures] count] < 10);
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
    if (_gameOver || _gamePaused) return;
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:location];
        
        CGFloat distanceFromPlayer = 0.0;
        CGFloat distance = 0.0;
        CGFloat minDistance = -1.0;
        SKNode *touchedNode;
        for (SKNode<HexProtocol> *node in nodes) {
            if (![node.name isEqualToString:@"Hex"]) {
                continue;
            }
            distance = pow([node getGridLoc].x - location.x, 2) +
            pow([node getGridLoc].y - location.y, 2);
            if (minDistance == -1.0) {
                minDistance = distance;
                distanceFromPlayer = pow(_player.position.x - [node getGridLoc].x, 2) +
                pow(_player.position.y - [node getGridLoc].y, 2);
                touchedNode = node;
            } else if (distance < minDistance) {
                minDistance = distance;
                distanceFromPlayer = pow(_player.position.x - [node getGridLoc].x, 2) +
                pow(_player.position.y - [node getGridLoc].y, 2);
                touchedNode = node;
            }
        }
        if (distanceFromPlayer > 3000.0) {
            //Not Adjacent
        } else if (touchedNode) {
            //Adjacent
            if ([(Hex *)touchedNode type] != WaterHex) {
                [[EvoScriptManager scriptManager] startScriptNamed:@"heal" withSource:_player];
                if ([(Hex *)touchedNode contents] != nil && ![[(Hex *)touchedNode contents].name isEqualToString:@"Player"]) {
                    //NSLog(@"Attacking!");
                    [_player setValue:[(Hex *)touchedNode contents] forKeyPath:@"target"];
                    [(EvoCreature *)[(Hex *)touchedNode contents] setValue:_player forKeyPath:@"target"];
                    [[EvoScriptManager scriptManager] startScriptNamed:@"attack" withSource:_player];
                    if ([[[(Hex *)touchedNode contents] valueForKeyPath:@"health"] floatValue] <= 0) {
                        //NSLog(@"Feeding!");
                        [[EvoScriptManager scriptManager] startScriptNamed:@"feed" withSource:_player];
                        [[(Hex *)touchedNode contents] removeFromParent];
                        [_player setValue:nil forKeyPath:@"target"];
                        [[_player hex] setContents:nil];
                        [_player setHex:(Hex *)touchedNode];
                        [(Hex *)touchedNode setContents:_player];
                        [_player setPosition:[(Hex *)touchedNode getGridLoc]];
                    }
                }
                else {
                    if (arc4random()%([[EvoCreatureManager creatureManager] numCreatures]*4) <= 10) {
                        [self spawnEnemy];
                    }
                    [[_player hex] setContents:nil];
                    [_player setHex:(Hex *)touchedNode];
                    [(Hex *)touchedNode setContents:_player];
                    [_player setPosition:[(Hex *)touchedNode getGridLoc]];
                }
            }
            [[EvoAIManager AIManager] update];
        }
    }
}

- (void) spawnEnemy
{
    //NSLog(@"Spawning new enemy");
    int randomX;
    int randomY;
    Hex *randomHex;
    
    do {
        randomX = (((arc4random()%2)*2)-1) * (5 - (arc4random() % 4));
        randomY = (((arc4random()%2)*2)-1) * (5 - (arc4random() % 4));
        randomHex = [_map getHexWithX:[[_player hex] x]+randomX withY:[[_player hex] x]+randomY];
    } while ([randomHex type] == WaterHex || [randomHex contents] != nil ||
             MAX(abs(_player.hex.x - randomHex.x), MAX(abs(_player.hex.y - randomHex.y), abs(_player.hex.z - randomHex.z))) <= 3);
    
    EvoCreature *newCreature = [[EvoCreatureManager creatureManager] spawnCreatureWithType:@"ursine" challenge:((arc4random()%4)+2)*0.2];
    
    [newCreature setHex:randomHex];
    [randomHex setContents:newCreature];
    [newCreature setPosition:[randomHex getGridLoc]];
    [_world addChild:newCreature];
    EvoAIManager *AIManager = [EvoAIManager AIManager];
    [AIManager addCreature:newCreature];
}

- (void) presentUpgradeMenu {
    if (!_upgradeView) {
        _upgradeView = [[EvoUpgradeView alloc] initWithFrame:CGRectInset(self.frame, 4, 4)];
        [_upgradeView setCenter:self.view.center];
        
        [[_upgradeView accept] addTarget:self action:@selector(menuTap:) forControlEvents:UIControlEventTouchUpInside];
        [[_upgradeView cancel] addTarget:self action:@selector(menuTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view insertSubview:_upgradeView atIndex:0];
    }
    else {
        NSLog(@"Unhiding menu");
        [_upgradeView setHidden:NO];
    }
    
    [[_upgradeView creatureInfo] setNumberOfLines:[[_player data] count]];
    NSString *newInfo = @"";
    //CONSTRUCT ARRAY OF UPGRADEABLE STRINGS!!!
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"health: %@\n",[[_player data] valueForKey:@"health"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"maxHealth: %@\n",[[_player data] valueForKey:@"maxHealth"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"healRate: %@\n",[[_player data] valueForKey:@"healRate"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"stamina: %@\n",[[_player data] valueForKey:@"stamina"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"maxStamina: %@\n",[[_player data] valueForKey:@"maxStamina"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"staminaRate: %@\n",[[_player data] valueForKey:@"staminaRate"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"attackPower: %@\n",[[_player data] valueForKey:@"attackPower"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"attackCost: %@\n",[[_player data] valueForKey:@"attackCost"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"accuracy: %@\n",[[_player data] valueForKey:@"accuracy"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"dodge: %@\n",[[_player data] valueForKey:@"dodge"]]];
    newInfo = [newInfo stringByAppendingString:[NSString stringWithFormat:@"points: %@\n",[[_player data] valueForKey:@"points"]]];
    [[_upgradeView creatureInfo] setText:[NSString stringWithFormat:@"%@",newInfo]];
    
}

- (IBAction)menuTap:(id)sender {
    if ([[sender title] isEqualToString:@"Accept"]) {
        [sender setEnabled:YES];
        [sender setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    }
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Cancel"]) {
        NSLog(@"Removing menu");
        [_upgradeView setHidden:YES];
        _gamePaused = NO;
    }
    //[(UIButton *)sender setSelected:YES];
    
    /*self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
    self.layer.borderWidth = 1.0f;
    
    self.layer.shadowColor = [UIColor greenColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 12;
    self.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);*/
    //NSLog(@"%@ Tapped:%@\nState:%u", [sender title], sender, [sender state]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if (context == deathWatch) {
        if (!_gameOver && !_gamePaused) {
            //Update Health Bar
            if ([keyPath isEqualToString:@"health"]) {
                if ([[_player valueForKey:@"health"] floatValue] <= 0.0) {
                    [[_ui healthBar] setSize:CGSizeMake(0, [_ui healthBar].size.height)];
                    _gameOver = YES;
                }
                else {
                    [[_ui healthBar] setSize:CGSizeMake([[_player valueForKey:@"health"] floatValue]/[[_player valueForKey:@"maxHealth"] floatValue] * (self.size.width/3 - 20), [_ui healthBar].size.height)];
                }
            }
            else if ([keyPath isEqualToString:@"stamina"]) {
                if ([[_player valueForKey:@"stamina"] floatValue] <= 0.0) {
                    [[_ui staminaBar] setSize:CGSizeMake(0, [_ui staminaBar].size.height)];
                    _gameOver = YES;
                }
                else {
                    [[_ui staminaBar] setSize:CGSizeMake([[_player valueForKey:@"stamina"] floatValue]/[[_player valueForKey:@"maxStamina"] floatValue] * (self.size.width/3 - 20), [_ui staminaBar].size.height)];
                }
            }
            else {
                if ([[_player valueForKey:@"biomass"] floatValue] <= 0.0) {
                    [[_ui biomassBar] setSize:CGSizeMake(0, [_ui biomassBar].size.height)];
                }
                else  if ([[_player valueForKey:@"biomass"] floatValue] < [[_player valueForKey:@"biomassLimit"] floatValue]){
                    [[_ui biomassBar] setSize:CGSizeMake([[_player valueForKey:@"biomass"] floatValue]/[[_player valueForKey:@"biomassLimit"] floatValue] * (self.size.width/3 - 20), [_ui biomassBar].size.height)];
                }
                else {
                    [[_ui biomassBar] setSize:CGSizeMake((self.size.width/3 - 20), [_ui biomassBar].size.height)];
                    _gamePaused = YES;
                }
            }
            if (_gameOver) {
                SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Damascus"];
                [gameOver setZPosition:20];
                [gameOver setText:@"You have died."];
                [gameOver setFontSize:30];
                [self addChild:gameOver];
            }
        }
        return;
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
    if (_gamePaused) {
        if ([self shouldEnableEffects] == NO) {
            [self setShouldEnableEffects:YES];
            [self presentUpgradeMenu];
        }
    }
    else if ([self shouldEnableEffects] == YES) {
        [self setShouldEnableEffects:NO];
    }
    //Most likely never needed
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (_gamePaused || _gameOver)
        return;
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
    if (_gamePaused || _gameOver)
        return;
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


@end
