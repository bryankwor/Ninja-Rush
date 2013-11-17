//
// Game.m
// Ninja Escape
//
// Created by Bryan Worrell on 9/28/13.
// Copyright Bryan Worrell 2013. All rights reserved.
//

#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "Game.h"
#import "GameOver.h"

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
        timeInvincible = 0;
        screenSize = [[CCDirector sharedDirector] winSize];
        self.touchEnabled = YES;
        ninjaMoving = NO;
        ninjaInvulnerable = FALSE;
        enemies = [[CCArray alloc] init];
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
            [enemies addObject:bat];
            [self addChild:bat];
        }
        
        // Create ninja
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
        ninja = [[Ninja alloc] init];
        ninja.position = ccp(screenSize.width/12, screenSize.height/2);
        [self addChild:ninja];
        
        // Set up callbacks
        [self schedule:@selector(update:) interval:.016];
        [self schedule:@selector(spawnItem:) interval:5];
        [self schedule:@selector(invincibility:) interval:1];
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
    // Initialize
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width/2, ninja.contentSize.height/2);
    bool moveNinja = true;
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Shoot shuriken if available at any enemies touched
    if (UI.shurikens != 0)
    {
        for (CCSprite *enemy in enemies)
        {
            CGRect boundingBox = [enemy getBoundingBox];
            
            if (CGRectContainsPoint(boundingBox, location))
            {
                // Ninja shouldn't move if shooting
                moveNinja = false;
                [[SimpleAudioEngine sharedEngine] playEffect:@"shurikenThrow.wav"];
                
                // Create shuriken starting at player and shoot towards enemy
                Shuriken *shuriken = [[Shuriken alloc] init];
                shuriken.position = ninja.position;
                [shuriken moveToPosition:location];
                
                // Add to scene
                [shurikens addObject:shuriken];
                [self addChild:shuriken];
                
                // Update number of available shurikens
                [UI updateShurikens:-1];
            }
        }
    }
    
    // Use defensive item if ninja is touched
    if (UI.smokeBombs != 0)
    {
        if (CGRectContainsPoint(ninjaBox, location))
        {
            // Ninja shouldn't move if using item
            moveNinja = false;
            [[SimpleAudioEngine sharedEngine] playEffect:@"Cloak.wav"];
            
            // Execute smoke bomb animation
            
            // Set invincibility
            timeInvincible = 5;
            ninjaInvulnerable = TRUE;
            
            // Update number of available smoke bombs
            [UI updateSmokeBombs:-1];
        }
    }
    
    // Otherwise just move ninja
    if (moveNinja)
        [ninja moveToPosition:location];
}

-(void) update:(ccTime)dt
{
    // Initialize
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width/2, ninja.contentSize.height/2);
    float gameTime = [UI getTime];

    // Check if level complete
    if ([enemies count] == 0)
        [self levelComplete];
    
    // Check if out of time
    if (gameTime < 0)
        [self timeOut];
    
    // Check if ninja picked up any items
    for (CCSprite *item in items)
    {
        CGRect itemBox = [item boundingBox];
        itemBox.size.height /= 4;
        itemBox.size.width /= 4;
        
        if (CGRectIntersectsRect(ninjaBox, itemBox))
        {
            // Shurikens tagged as 1
            if (item.tag == 1)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"itemGet.mp3"];
                [UI updateShurikens:5];
                [items removeObject:item];
                [self removeChild:item cleanup:YES];
            }

            // Smoke bombs tagged as 2
            if (item.tag == 2)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"itemGet.mp3"];
                [UI updateSmokeBombs:1];
                [items removeObject:item];
                [self removeChild:item cleanup:YES];

            }
        }

    }
    
    // Check if ninja is hit by any enemies
    if (!ninjaInvulnerable)
    {
        for (CCSprite *enemy in enemies)
        {
            CGRect enemyBox = [enemy getBoundingBox];
            enemyBox.size.height /= 4;
            enemyBox.size.width /= 4;
            
            if (CGRectIntersectsRect(ninjaBox, enemyBox))
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

    }
    
    // Check collisions between all shurikens on screen with any enemies
    NSMutableArray *shurikensToDelete = [[NSMutableArray alloc] init];
    for (Shuriken *shuriken in shurikens)
    {
        NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
    
        for (CCSprite *enemy in enemies)
        {
            CGRect enemyBox = [enemy getBoundingBox];
            CGRect shurikenBox = [shuriken getBoundingBox];
            shurikenBox.origin.x = shuriken.position.x-shurikenBox.size.width/2;
            shurikenBox.origin.y = shuriken.position.y-shurikenBox.size.height/2;
            if (CGRectIntersectsRect(shurikenBox, enemyBox))
                [enemiesToDelete addObject:enemy];
        }
        
        for (CCSprite *enemy in enemiesToDelete)
        {
            [enemies removeObject:enemy];
            [self removeChild:enemy cleanup:YES];
            [UI updateScore:100];
        }
        
        if (enemiesToDelete.count > 0)
            [shurikensToDelete addObject:shuriken];
        
        if (shuriken.isDoneMoving)
            [shurikensToDelete addObject:shuriken];
    
        [enemiesToDelete release];
    }
    
    for (Shuriken *shuriken in shurikensToDelete)
    {
        [shurikens removeObject:shuriken];
        [self removeChild:shuriken cleanup:YES];
    }
    
    [shurikensToDelete release];
}

-(void) spawnItem:(ccTime)dt
{
    CGPoint randSpawnPoint;
    randSpawnPoint.y = arc4random() % (int)screenSize.height;
    randSpawnPoint.x = arc4random() % (int)screenSize.width;
    randSpawnPoint.y /= 2;
    randSpawnPoint.x /= 2;
    
    if ([items count] < 2)
    {
        int select = arc4random() % 3;
        
        if (select == 1)
        {
            Item *shuriken = [[Item alloc] initWithFile:@"shurikenItem"];
            [shuriken setTag:1];
            shuriken.position = randSpawnPoint;
            [items addObject:shuriken];
            [self addChild:shuriken];
        }
        
        if (select == 2)
        {
            Item *smokeBomb = [[Item alloc] initWithFile:@"smokeBomb"];
            [smokeBomb setTag:2];
            smokeBomb.position = randSpawnPoint;
            [items addObject:smokeBomb];
            [self addChild:smokeBomb];
        }
    }
}

-(void) invincibility:(ccTime)dt
{
    if (ninjaInvulnerable)
    {
        --timeInvincible;

        if (timeInvincible == 0)
            ninjaInvulnerable = FALSE;
    }
}

-(void) levelComplete
{
    
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