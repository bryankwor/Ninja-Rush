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
#import "SimpleAudioEngine.h"

@implementation Game

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
    if ((self = [super init]))
    {
        // Initialize
        self.touchEnabled = YES;
        screenSize = [[CCDirector sharedDirector] winSize];
        ninjaMoving = NO;
        bats = [[CCArray alloc] init];
        shurikens = [[CCArray alloc] init];
        
        // Set background and UI
        CCSprite *background = [CCSprite spriteWithFile:@"field.jpeg"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        UI = [[GameUI alloc] init];
        [self addChild:UI];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"fieldTheme.mp3"];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:.50f];
        
        // Create enemies
        for (int i=0; i<20; ++i)
        {
            Silverbat *bat = [[Silverbat alloc] init];
            [bat setTag:2];
            [bats addObject:bat];
            [self setContentSize:bat.contentSize];
            [self addChild:bat];
        }
        
        // Create ninja
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
        ninja = [[Ninja alloc] init];
        [ninja setTag:1];
        ninja.position = ccp(screenSize.width/12, screenSize.height/2);
        [self addChild:ninja];
        
        [self schedule:@selector(update:) interval:.016];
    }
    
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [ninja stopActions];
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    bool moveNinja = true;
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (Silverbat *bat in bats)
    {
        CGRect boundingBox = [bat getBoundingBox];
        
        if (CGRectContainsPoint(boundingBox, location))
        {
            if (bat.tag == 2)
            {
                Shuriken *shuriken = [[Shuriken alloc] init];
                [shuriken setTag:3];
                shuriken.position = ninja.position;
                [shurikens addObject:shuriken];
                [self addChild:shuriken];
                [shuriken moveToPosition:location];
                [[SimpleAudioEngine sharedEngine] playEffect:@"shurikenThrow.wav"];
                moveNinja = false;
            }
        }
    }
    
    if (moveNinja)
        [ninja moveToPosition:location];
}

-(void) update:(ccTime)dt
{
    NSMutableArray *shurikensToDelete = [[NSMutableArray alloc] init];
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width/2, ninja.contentSize.height/2);
    
    for (Silverbat *bat in bats)
    {
        CGRect batBox = [bat getBoundingBox];
        batBox.size.height /= 4;
        batBox.size.width /= 4;
        
        if (CGRectIntersectsRect(ninjaBox, batBox))
        {
            if ([UI updateLives:-1])
            {
                ninja.position = ccp(screenSize.width/12, screenSize.height/2);
                [ninja stopActions];
            }
            else
                continue;
        }
    }
    
    for (Shuriken *shuriken in shurikens)
    {
        NSMutableArray *batsToDelete = [[NSMutableArray alloc] init];
    
        for (Silverbat *bat in bats)
        {
            CGRect batBox = [bat getBoundingBox];
            CGRect shurikenBox = [shuriken getBoundingBox];
            shurikenBox.origin.x = shuriken.position.x-shurikenBox.size.width/2;
            shurikenBox.origin.y = shuriken.position.y-shurikenBox.size.height/2;
            if (CGRectIntersectsRect(shurikenBox, batBox))
                [batsToDelete addObject:bat];
        }
        
        for (Silverbat *bat in batsToDelete)
        {
            [bats removeObject:bat];
            [self removeChild:bat cleanup:YES];
            [UI updateScore:100];
        }
        
        if (batsToDelete.count > 0)
            [shurikensToDelete addObject:shuriken];
        
        if (shuriken.isDoneMoving)
            [shurikensToDelete addObject:shuriken];
    
        [batsToDelete release];
    }
    
    for (Shuriken *shuriken in shurikensToDelete)
    {
        [shurikens removeObject:shuriken];
        [self removeChild:shuriken cleanup:YES];
    }
    
    [shurikensToDelete release];
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