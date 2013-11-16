//
// Game.m
// Ninja Escape
//
// Created by Bryan Worrell on 9/28/13.
// Copyright Bryan Worrell 2013. All rights reserved.
//

#import "Game.h"
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"
#import "GameOver.h"
#import "AppDelegate.h"
#import "GameData.h"

@implementation Game

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    Game *layer = [Game node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        // Initialize
        screenSize = [[CCDirector sharedDirector] winSize];
        self.touchEnabled = YES;
        ninjaMoving = NO;
        bats = [[CCArray alloc] init];
        shurikens = [[CCArray alloc] init];
        items  = [[CCArray alloc] init];
        
        // Set background image and UI
        CCSprite *background = [CCSprite spriteWithFile:@"field.jpeg"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        UI = [[GameData alloc] init];
        [self loadUI];
        [self addChild:UI];
        
        // Set background theme
        if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"fieldTheme.mp4"];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:.50f];
        }
        
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
        
        // Set up callbacks
        [self schedule:@selector(update:) interval:.016];
        [self schedule:@selector(spawnItem:) interval:5];
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
    // Initialize local variables
    bool moveNinja = true;
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Shoot shuriken if available at any bats touched
    if (UI.shurikens != 0)
    {
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
                    [UI updateShurikens:-1];
                    moveNinja = false;
                }
            }
        }

    }
    
    // Otherwise just move ninja
    if (moveNinja)
        [ninja moveToPosition:location];
}

-(void) update:(ccTime)dt
{
    // Initialize local variables
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width/2, ninja.contentSize.height/2);
    float gameTime = [UI getTime];

    // Check if out of time
    if (gameTime < 0)
    {
        [self timeOut];
    }
    
    // Check if ninja picked up any items
    for (CCSprite *item in items)
    {
        CGRect itemBox = [item boundingBox];
        itemBox.size.height /= 4;
        itemBox.size.width /= 4;
        
        if (CGRectIntersectsRect(ninjaBox, itemBox))
        {
            // Shurikens tagged as 3
            if (item.tag == 3)
            {
                [UI updateShurikens:5];
                [items removeObject:item];
                [self removeChild:item cleanup:YES];
            }

            else
                [UI updateSmokeBombs:1];
        }

    }
    
    // Check if ninja is hit by any enemies
    for (Silverbat *bat in bats)
    {
        CGRect batBox = [bat getBoundingBox];
        batBox.size.height /= 4;
        batBox.size.width /= 4;
        
        if (CGRectIntersectsRect(ninjaBox, batBox))
        {
            // If lives > 0, reset ninja
            if ([UI updateLives:-1])
            {
                ninja.position = ccp(screenSize.width/12, screenSize.height/2);
                [ninja stopActions];
            }
            // Otherwise game over
            else
            {
                [ninja stopActions];
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOver scene]]];
            }
        }
    }
    
    // Check collisions between all shurikens on screen with any enemies
    NSMutableArray *shurikensToDelete = [[NSMutableArray alloc] init];
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

-(void) timeOut
{
    // Reset if still have lives
    if ([UI updateLives:-1])
    {
        [self saveUI];
        [[CCDirector sharedDirector] replaceScene:[Game scene]];
    }
    // Otherwise Game Over
    else
    {
        [ninja stopActions];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[GameOver scene]];
    }
}

-(void) loadUI
{
    GameData *data = [GameData sharedData];
    
    [UI updateScore:data.score];
    [UI loadShurikens:data.shurikens];
    [UI updateSmokeBombs:data.smokeBombs];
    [UI loadLives:data.lives];

}

-(void) saveUI
{
    GameData *data = [GameData sharedData];
    
    data.score = UI.score;
    data.lives = UI.lives;
    data.shurikens = UI.shurikens;
    data.smokeBombs = UI.smokeBombs;
}

-(void) spawnItem:(ccTime)dt
{
    CGPoint randSpawnPoint;
    randSpawnPoint.y = arc4random() % (int)screenSize.height;
    randSpawnPoint.x = arc4random() % (int)screenSize.width;
    
    if ([items count] < 2)
    {
        int select = arc4random() % 3;
        
        if (select == 1)
        {
            Shuriken *shuriken = [[Shuriken alloc] init];
            [shuriken setTag:3];
            shuriken.position = randSpawnPoint;
            [items addObject:shuriken];
            [self addChild:shuriken];
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    
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