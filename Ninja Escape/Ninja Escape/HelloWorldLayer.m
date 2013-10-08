//
//  HelloWorldLayer.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"
#import "AppDelegate.h"


@interface HelloWorldLayer ()
{
    BOOL ninjaMoving;
    CGSize screenSize;
}

@property (nonatomic, strong) CCSprite *ninja;
@property (nonatomic, strong) CCSprite *silverbat;
@property (nonatomic, strong) CCAction *ninjaDown;
@property (nonatomic, strong) CCAction *ninjaSide;
@property (nonatomic, strong) CCAction *ninjaUp;
@property (nonatomic, strong) CCAction *ninjaMove;
@property (nonatomic, strong) CCAction *silverbatDown;
@property (nonatomic, strong) CCAction *silverbatSide;
@property (nonatomic, strong) CCAction *silverbatUp;
@property (nonatomic, strong) CCAction *silverbatMove;

@end


#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
		if ((self=[super init]))
        {
            // Initialize
            screenSize = [[CCDirector sharedDirector] winSize];
            CGPoint spawnZone;
            spawnZone.x = arc4random() % 340;
            spawnZone.y = arc4random() % (int)(screenSize.height - screenSize.height/6);
            if (spawnZone.x < (screenSize.height/6))
                spawnZone.x += screenSize.height/6;
            
            // Set background
            
            CCSprite *background = [CCSprite spriteWithFile:@"field.jpeg"];
            background.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:background];
            
            // Cache sprite frames and texture
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"silverbat.plist"];
            
            // Create sprite batch nodes
            CCSpriteBatchNode *ninjaSheet = [CCSpriteBatchNode batchNodeWithFile:@"ninja.png"];
            CCSpriteBatchNode *silverbatSheet = [CCSpriteBatchNode batchNodeWithFile:@"silverbat.png"];
            [self addChild:ninjaSheet];
            [self addChild:silverbatSheet];
            
            // Gather the list of frames for up, down and side walk animations
            
            // Ninja
            NSMutableArray *ninjaDownFrames = [NSMutableArray array];
            NSMutableArray *ninjaSideFrames = [NSMutableArray array];
            NSMutableArray *ninjaUpFrames = [NSMutableArray array];
            
            // Silverbat
            NSMutableArray *silverbatDownFrames = [NSMutableArray array];
            NSMutableArray *silverbatSideFrames = [NSMutableArray array];
            NSMutableArray *silverbatUpFrames = [NSMutableArray array];
            
            for (int i=1; i<=4; ++i)
            {
                // Ninja
                [ninjaDownFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
                
                // Silverbat
                [silverbatDownFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
            }
            for (int i=5; i<=8; ++i)
            {
                // Ninja
                [ninjaSideFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
                
                // Silverbat
                [silverbatSideFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
            }
            for (int i=9; i<=12; ++i)
            {
                if (i<=9)
                {
                    // Ninja
                    [ninjaUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
                    
                    // Silverbat
                    [silverbatUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
                }
                else
                {
                    // Ninja
                    [ninjaUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja%d.png",i]]];
                    
                    // Silverbat
                    [silverbatUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat%d.png",i]]];
                }
            }

            // Create animation objects
            
            // Ninja
            CCAnimation *ninjaDownAnim = [CCAnimation
                                          animationWithSpriteFrames:ninjaDownFrames delay:0.1f];
            CCAnimation *ninjaSideAnim = [CCAnimation
                                          animationWithSpriteFrames:ninjaSideFrames delay:0.1f];
            CCAnimation *ninjaUpAnim = [CCAnimation
                                          animationWithSpriteFrames:ninjaUpFrames delay:0.1f];
 
            // Silverbat
            CCAnimation *silverbatDownAnim = [CCAnimation
                                          animationWithSpriteFrames:silverbatDownFrames delay:0.1f];
            CCAnimation *silverbatSideAnim = [CCAnimation
                                          animationWithSpriteFrames:silverbatSideFrames delay:0.1f];
            CCAnimation *silverbatUpAnim = [CCAnimation
                                        animationWithSpriteFrames:silverbatUpFrames delay:0.1f];

            
            // Create sprites and run animation actions
            
            // Ninja
            self.ninja = [CCSprite spriteWithSpriteFrameName:@"ninja01.png"];
            self.ninja.position = ccp(screenSize.width/2, screenSize.height/7);
            self.ninjaDown = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:ninjaDownAnim]];
            self.ninjaSide = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:ninjaSideAnim]];
            self.ninjaUp = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:ninjaUpAnim]];
            [ninjaSheet addChild:self.ninja];
            

            // Silverbat
            self.silverbat = [CCSprite spriteWithSpriteFrameName:@"silverbat01.png"];
            self.silverbat.position = ccp(spawnZone.x, spawnZone.y);
            self.silverbatDown = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:silverbatDownAnim]];
            self.silverbatSide = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:silverbatSideAnim]];
            self.silverbatUp = [CCRepeatForever actionWithAction:
                            [CCAnimate actionWithAnimation:silverbatUpAnim]];
            [silverbatSheet addChild:self.silverbat];
            
            self.silverbat.flipX = YES;
            [self.silverbat runAction:self.silverbatSide];
            [self schedule:@selector(nextFrame:)];
            
            
            self.touchEnabled = YES;
        }
    
	return self;
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (ninjaMoving)
    {
        [self.ninja stopAction:self.ninjaUp];
        [self.ninja stopAction:self.ninjaSide];
        [self.ninja stopAction:self.ninjaDown];
        ninjaMoving = NO;
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Calculate move duration based on screen size
    CGPoint location = [self convertTouchToNodeSpace:touch];
    float ninjaVelocity = screenSize.width / 8.0;
    CGPoint moveDiff = ccpSub(location, self.ninja.position);
    float distanceToMove = ccpLength(moveDiff);
    float moveDuration = distanceToMove / ninjaVelocity;
    
    float moveAngle = ((atan2f(moveDiff.y, moveDiff.x)) * 180) / M_PI;
    if (moveAngle < 0)
        moveAngle += 360;
    
    [self.ninja stopAction:self.ninjaMove];
    
    if (!ninjaMoving || ninjaMoving)
    {
        if (moveAngle > 45 && moveAngle < 135)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninjaUp];
        }
        else if (moveAngle > 135 && moveAngle < 225)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninjaSide];
        }
        else if (moveAngle > 225 && moveAngle < 315)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninjaDown];
        }
        else
        {
            self.ninja.flipX = YES;
            [self.ninja runAction:self.ninjaSide];
        }
    }
    
    self.ninjaMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:location], [CCCallFunc actionWithTarget:self selector:@selector(ninjaMoveEnded)], nil];
    
    [self.ninja runAction:self.ninjaMove];
    ninjaMoving = YES;
}

-(void) ninjaMoveEnded
{
    [self.ninja stopAction:self.ninjaUp];
    [self.ninja stopAction:self.ninjaSide];
    [self.ninja stopAction:self.ninjaDown];
    ninjaMoving = NO;
}

-(void) nextFrame:(ccTime)dt
{
    if (self.silverbat.position.x <= screenSize.width + 1)
    {
        
    }
    self.silverbat.position = ccp(self.silverbat.position.x + arc4random()%5, self.silverbat.position.y + arc4random()%5);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
