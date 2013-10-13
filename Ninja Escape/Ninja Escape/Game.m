//
// HelloWorldLayer.m
// Ninja Escape
//
// Created by Bryan Worrell on 9/28/13.
// Copyright Bryan Worrell 2013. All rights reserved.
//

#import "Game.h"
#import "CCTouchDispatcher.h"
#import "AppDelegate.h"
#import "Silverbat.h"

@implementation Game

@synthesize ninja;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    Game *layer = [Game node];
    
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
        self.touchEnabled = YES;
        screenSize = [[CCDirector sharedDirector] winSize];
        ninjaMoving = NO;
        
        // Set background
        CCSprite *background = [CCSprite spriteWithFile:@"field.jpeg"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        
        // Create ninja
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
        CCSpriteBatchNode *ninjaSheet = [CCSpriteBatchNode batchNodeWithFile:@"ninja.png"];
        [self addChild:ninjaSheet];
        self.ninja = [[Ninja alloc] init];
        ninja.position = ccp(screenSize.width/8, screenSize.height/2);
        [ninjaSheet addChild:ninja];
        
        for (int i=0; i<20; ++i)
        {
            Silverbat *bat = [[Silverbat alloc] init];
            [self addChild:bat];
        }
        
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
        [self.ninja stopAction:ninjaMove];
        [self.ninja stopAction:self.ninja.ninjaUp];
        [self.ninja stopAction:self.ninja.ninjaSide];
        [self.ninja stopAction:self.ninja.ninjaDown];
        ninjaMoving = NO;
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Calculate move duration based on screen size
    CGPoint location = [self convertTouchToNodeSpace:touch];
    float ninjaVelocity = screenSize.width / 6.0;
    CGPoint moveDiff = ccpSub(location, self.ninja.position);
    float distanceToMove = ccpLength(moveDiff);
    float moveDuration = distanceToMove / ninjaVelocity;
    
    float moveAngle = ((atan2f(moveDiff.y, moveDiff.x)) * 180) / M_PI;
    if (moveAngle < 0)
        moveAngle += 360;
    
    if (!ninjaMoving)
    {
        if (moveAngle > 45 && moveAngle < 135)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninja.ninjaUp];
        }
        else if (moveAngle > 135 && moveAngle < 225)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninja.ninjaSide];
        }
        else if (moveAngle > 225 && moveAngle < 315)
        {
            self.ninja.flipX = NO;
            [self.ninja runAction:self.ninja.ninjaDown];
        }
        else
        {
            self.ninja.flipX = YES;
            [self.ninja runAction:self.ninja.ninjaSide];
        }
    }
    
    ninjaMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:location], [CCCallFunc actionWithTarget:self selector:@selector(ninjaMoveEnded)], nil];
    
    [ninja runAction:ninjaMove];
    ninjaMoving = YES;
}

-(void) ninjaMoveEnded
{
    [self.ninja stopAction:self.ninja.ninjaUp];
    [self.ninja stopAction:self.ninja.ninjaSide];
    [self.ninja stopAction:self.ninja.ninjaDown];
    ninjaMoving = NO;
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