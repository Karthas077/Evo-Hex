#import "Hex.h"

@implementation Hex

#pragma mark - Initialization
- (Hex *)init
{
    self = [super init];
	if (self) {
        self = [super initWithTexture:[SKTexture textureWithImageNamed:@"Tiles/Grass_Hex.png"]];
        self.size = CGSizeMake(50, 50);
	}
	return self;
}

- (Hex *)initWithX:(NSInteger)x withY:(NSInteger)y withZ:(NSInteger)z {
    self = [super init];
    if(self) {
        self =
        [super initWithTexture:[SKTexture textureWithImageNamed:@"Tiles/Grass_Hex.png"]];
        self.size = CGSizeMake(50, 50);
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
}

-(void)setType:(NSInteger)type
{
	_type = type;
    self.texture = [SKTexture textureWithImageNamed:hexTextures[type]];
}

-(void) setAnchorPoint:(CGPoint)anchorPoint
{
    [super setAnchorPoint:anchorPoint];
}

-(void) setPosition:(CGPoint)position
{
    [super setPosition:position];
}

-(void) setGridLoc:(CGPoint)gridLoc
{
    _gridLoc = CGPointMake(gridLoc.x + self.position.x, gridLoc.y + self.position.y);
}

-(CGPoint) getGridLoc
{
    return _gridLoc;
}

-(NSUInteger)hash
{
    return (_x << sizeof(NSUInteger)*4)+_y;
}

-(BOOL)isEqual:(id)object
{
    if ([self hash] == [object hash])
        return YES;
    else
        return NO;
}


@end
