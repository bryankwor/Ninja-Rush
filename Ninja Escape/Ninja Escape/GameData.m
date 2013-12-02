//
//  GameData.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "GameData.h"
#import "GameOver.h"

@implementation GameData

@synthesize score;
@synthesize time;
@synthesize lives;
@synthesize shurikens;
@synthesize smokeBombs;

static GameData *data;

-(id) init
{
    if ((self = [super init]))
    {
        // Initialize UI variable display values
        score = 0;
        time = 100;
        lives = 3;
        shurikens = 5;
        smokeBombs = 1;
        
        // Create UI labels
        highScoreLabel = [CCLabelTTF labelWithString:@"0"
                          fontName:@"Marker Felt"
                          fontSize:16];
        highScoreLabel.position = ccp(460, 308);
        highScoreLabel.color = ccc3(0, 0, 0);
        scoreLabel = [CCLabelTTF labelWithString:@"0"
                      fontName:@"Marker Felt"
                      fontSize:16];
        scoreLabel.position = ccp(460, 288);
        scoreLabel.color = ccc3(0, 0, 0);
        timeLabel = [CCLabelTTF labelWithString:@"100"
                     fontName:@"Marker Felt"
                     fontSize:20];
        timeLabel.position = ccp(55, 272);
        timeLabel.color = ccc3(0, 0, 0);
        livesLabel = [CCLabelTTF labelWithString:@"x 3"
                      fontName:@"Marker Felt"
                      fontSize:24];
        livesLabel.position = ccp(55, 305);
        livesLabel.color = ccc3(0, 0, 0);
        shurikensLabel = [CCLabelTTF labelWithString:@"x 0"
                          fontName:@"Marker Felt"
                          fontSize:20];
        shurikensLabel.position = ccp(530, 305);
        shurikensLabel.color = ccc3(0, 0, 0);
        smokeBombsLabel = [CCLabelTTF labelWithString:@"x 0"
                           fontName:@"Marker Felt"
                           fontSize:20];
        smokeBombsLabel.position = ccp(530, 272);
        smokeBombsLabel.color = ccc3(0, 0, 0);
        
        // Add labels to scene
        [self addChild:highScoreLabel z:1];
        [self addChild:scoreLabel z:1];
        [self addChild:timeLabel z:1];
        [self addChild:livesLabel z:1];
        [self addChild:shurikensLabel z:1];
        [self addChild:smokeBombsLabel z:1];

        // Set up game timer callback
        [self schedule:@selector(updateTime:) interval:.1];
    }
    
    return self;
}

-(void) updateTime:(ccTime)dt
{
    time -= dt;
    [timeLabel setString:[NSString stringWithFormat:@"%.0f", time]];
}

-(void) updateScore:(int)amount
{
    score += amount;
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
    
    if (score > highScore)
    {
        highScore = score;
        [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
    }
}

-(void) updateShurikens:(int)amount
{
    shurikens += amount;
    [shurikensLabel setString:[NSString stringWithFormat:@"x %d", shurikens]];
}

-(void) updateSmokeBombs:(int)amount
{
    smokeBombs += amount;
    [smokeBombsLabel setString:[NSString stringWithFormat:@"x %d", smokeBombs]];
}

-(BOOL) updateLives:(int)amount
{
    lives += amount;
    [livesLabel setString:[NSString stringWithFormat:@"x %d", lives]];
    
    // False if out of lives
    if (lives < 0)
        return FALSE;
    else
        return TRUE;
}

-(void) loadLives:(int)amount
{
    lives = amount;
    [livesLabel setString:[NSString stringWithFormat:@"x %d", lives]];
}

-(void) loadShurikens:(int)amount
{
    shurikens = amount;
    [shurikensLabel setString:[NSString stringWithFormat:@"x %d", shurikens]];
}

-(float) getTime
{
    return time;
}

+(GameData *) sharedData
{
    @synchronized (self)
    {
        if (!data)
            data = [[GameData alloc] init];
    }
    
    return data;
}

@end
