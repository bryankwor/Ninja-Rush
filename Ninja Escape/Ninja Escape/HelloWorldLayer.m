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
}

@property (nonatomic, strong) CCSprite *ninja;
@property (nonatomic, strong) CCSprite *enemy;
@property (nonatomic, strong) CCAction *ninjaWalk;
@property (nonatomic, strong) CCAction *ninjaMove;

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
            // Cache sprite frames and texture
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninjaAnim.plist"];
            
            // Create sprite batch nodes
            CCSpriteBatchNode *ninjaSheet = [CCSpriteBatchNode batchNodeWithFile:@"ninjaAnim.png"];
            [self addChild:ninjaSheet];
            
            // Gather the list of frames
            NSMutableArray *ninjaWalkFrames = [NSMutableArray array];
            for (int i=1; i<=12; ++i)
            {
                if (i<=9)
                    [ninjaWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
                else
                    [ninjaWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja%d.png",i]]];
            }
            
            // Create animation objects
            CCAnimation *ninjaWalkAnim = [CCAnimation
                                          animationWithSpriteFrames:ninjaWalkFrames delay:0.1f];
            
            // Create sprites and run animation actions
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            self.ninja = [CCSprite spriteWithSpriteFrameName:@"ninja01.png"];
            self.ninja.position = ccp(winSize.width/2, winSize.height/2);
            self.ninjaWalk = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:ninjaWalkAnim]];
            [ninjaSheet addChild:self.ninja];
            
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
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Calculate move duration based on screen size
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float ninjaVelocity = screenSize.width / 10.0;
    CGPoint moveDifference = ccpSub(location, self.ninja.position);
    float distanceToMove = ccpLength(moveDifference);
    float moveDuration = distanceToMove / ninjaVelocity;
    
    if (moveDifference.x < 0)
        self.ninja.flipX = NO;
    else
        self.ninja.flipX = YES;
    
    [self.ninja stopAction:self.ninjaMove];
    
    if (!ninjaMoving)
        [self.ninja runAction:self.ninjaWalk];
    
    self.ninjaMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:location], [CCCallFunc actionWithTarget:self selector:@selector(ninjaMoveEnded)], nil];
    
    [self.ninja runAction:self.ninjaMove];
    ninjaMoving = YES;
    
    /*
    float distance = ccpDistance([ninja position], location);
    
    [ninja stopAllActions];
    [ninja runAction:[CCMoveTo actionWithDuration:distance/100 position:location]];
     */
    
}

-(void) ninjaMoveEnded
{
    [self.ninja stopAction:self.ninjaWalk];
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
