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
        effects = [[CCArray alloc] init];
        hearts = [[CCArray alloc] init];
        
        // Setup background image and UI
        CCSprite *background = [CCSprite spriteWithFile:@"field.jpeg"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
       
        CCSprite *interface = [CCSprite spriteWithFile:@"UI.png"];
        interface.position = ccp(screenSize.width/2, 290);
        [self addChild:interface];
        
        Item *shuriken = [[Item alloc] initWithFile:@"shurikenItem"];
        shuriken.position = ccp(500, 305);
        [self addChild:shuriken];
    
        Item *smokeBomb = [[Item alloc] initWithFile:@"smokeBomb"];
        smokeBomb.position = ccp(500, 272);
        [self addChild:smokeBomb];
        
        Item *hourglass = [[Item alloc] initWithFile:@"hourglass"];
        hourglass.position = ccp(25, 272);
        [self addChild:hourglass];
        
        int offset = 15;
        for (int i=0; i<3; ++i)
        {
            CCSprite *heart = [[CCSprite alloc] initWithFile:@"heart.png"];
            heart.position = ccp(90+(offset*i), 305);
            heart.scale *= 1.5;
            [hearts addObject:heart];
            [self addChild:heart];
        }
        
        // Obtain Game Data
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
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width, ninja.contentSize.height);
    bool moveNinja = true;
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    float distance = powf(powf(location.x-ninja.position.x, 2) + powf(location.y-ninja.position.y, 2), .5);
    
    // Shoot shuriken if available at any enemies touched and are in range
    if (UI.shurikens != 0 && distance < 120)
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
            Effects *smoke = [[Effects alloc] initWithFile:@"smoke"];
            smoke.position = ninja.position;
            smoke.tag = 3;
            smoke.scale *= 2;
            [effects addObject:smoke];
            [self addChild:smoke];
            
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
    CGRect ninjaBox = CGRectMake((ninja.position.x-ninja.contentSize.width/2), (ninja.position.y-ninja.contentSize.height/2), ninja.contentSize.width, ninja.contentSize.height);
    float gameTime = [UI getTime];

    // Check if level complete
    if ([enemies count] == 0)
        [self levelComplete];
    
    // Check if out of time
    if (gameTime < 0)
        [self timeOut];
    
    // Check for smoke bomb animation
    if (effects.count > 0)
    {
        for (CCSprite *effect in effects)
        {
            if (effect.tag == 3)
            {
                if ([effect timeTick:1])
                {
                    [effects removeObject:effect];
                    [self removeChild:effect cleanup:YES];
                }
                else
                    effect.position = ninja.position;
            }
        }
    }
    
    // Check if ninja picked up any items
    for (CCSprite *item in items)
    {
        CGRect itemBox = CGRectMake((item.position.x-item.contentSize.width/2), (item.position.y-item.contentSize.height/2), item.contentSize.width, item.contentSize.height);
        
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
            
            if (CGRectIntersectsRect(ninjaBox, enemyBox))
            {
                BOOL dead = [ninja changeHealth:-1];
                if (dead)
                {
                    // If lives > 0, reset ninja
                    if ([UI updateLives:-1])
                    {
                        ninja.health = 3;
                        ninja.position = ccp(screenSize.width/12, screenSize.height/2);
                        [ninja stopActions];
                    
                        for (CCSprite *heart in hearts)
                            [heart setTexture:[[CCSprite spriteWithFile:@"heart.png"]texture]];
                    }
                    // Otherwise game over
                    else
                    {
                        ninja.health = 3;
                        ninja.position = ccp(screenSize.width/12, screenSize.height/2);
                        [ninja stopActions];
                        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOver scene]]];
                    }
                }
                else
                {
                    // Set invincibility
                    timeInvincible = 2;
                    ninjaInvulnerable = TRUE;
                    ninja.position = ccp(screenSize.width/12, screenSize.height/2);
                    [ninja stopActions];
                    
                    // Change heart
                    CCSprite *heart = [hearts objectAtIndex:ninja.health];
                    [heart setTexture:[[CCSprite spriteWithFile:@"dmgHeart.png"]texture]];
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
            CGRect shurikenBox = CGRectMake((shuriken.position.x-shuriken.contentSize.width/2), (shuriken.position.y-shuriken.contentSize.height/2), shuriken.contentSize.width, shuriken.contentSize.height);

            if (CGRectIntersectsRect(shurikenBox, enemyBox))
            {
                [enemiesToDelete addObject:enemy];
                break;
            }
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