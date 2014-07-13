#import "EvoMenuScene.h"

@interface EvoMenuScene ()
@property BOOL hasStarted;
@end

@implementation EvoMenuScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor =
        [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *nameBanner = [SKLabelNode labelNodeWithFontNamed:@"Damascus"];
        
        nameBanner.name = @"banner";
        nameBanner.text = @"Evolution Hex";
        nameBanner.fontSize = 30;
        nameBanner.position =
        CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 60);
        
        SKNode *startButton = [SKNode node];
        startButton.position =
        CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 30);
        startButton.name = @"startGame";
        
        SKSpriteNode *button =
        [[SKSpriteNode alloc] initWithColor:[SKColor grayColor]
                                       size:CGSizeMake(100, 20)];
        
        SKLabelNode *startText = [SKLabelNode labelNodeWithFontNamed:@"Damascus"];
        startText.name = @"label";
        startText.text = @"New Game!";
        startText.fontSize = 10;
        startText.position = CGPointMake(0, -5);
        
        [startButton addChild:button];
        [startButton addChild:startText];
        
        startButton.userData = [NSMutableDictionary dictionary];
        [startButton.userData setObject:[NSNumber numberWithInt:1] forKey:@"mode"];
        
        [self addChild:nameBanner];
        [self addChild:startButton];
        
        _hasStarted = false;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        // CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        
        for (SKNode *node in nodes) {
            if (!_hasStarted && [node.name isEqualToString:@"startGame"]) {
                NSNumber *mode = [node.userData objectForKey:@"mode"];
                [self enumerateChildNodesWithName:@"startGame"
                                       usingBlock:^(SKNode *node, BOOL *stop) {
                                           [node removeFromParent];
                                       }];
                [[self childNodeWithName:@"banner"] removeFromParent];
                [self startGame:mode];
            }
        }
    }
}

- (void)startGame:(NSNumber *)mode {
    EvoDataManager *dataManager = [EvoDataManager dataManager];
    [dataManager setModList:[[NSArray alloc] initWithObjects:@"Core", nil] ];
    if([dataManager setupModules]) {
        for (EvoScript *script in [dataManager loadScripts]) {
            [[EvoScriptManager scriptManager] addScript:script];
        }
        
        _hasStarted = true;
        
        SKTransition *reveal =
        [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
        EvoGameScene *newScene = [[EvoGameScene alloc] initWithSize:self.size];
        
        newScene.mode = mode;
        
        [self.scene.view presentScene:newScene transition:reveal];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
