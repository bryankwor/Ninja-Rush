//
//  GameUI.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "GameUI.h"

@implementation GameUI

@synthesize scoreLabel;
@synthesize timeLabel;
@synthesize livesLabel;

-(id) init
{
    if ((self = [super init]))
    {
        score = 0;
        time = 100;
        lives = 3;
        shurikens = 0;
        smokeBombs = 0;
        
        scoreLabel = [CCLabelTTF labelWithString:@"0"
                      fontName:@"Marker Felt"
                      fontSize:24];
        scoreLabel.position = ccp(538, 10);
        timeLabel = [CCLabelTTF labelWithString:@"100"
                     fontName:@"Marker Felt"
                     fontSize:24];
        timeLabel.position = ccp(538, 30);
        livesLabel = [CCLabelTTF labelWithString:@"3"
                      fontName:@"Marker Felt"
                      fontSize:24];
        livesLabel.position = ccp(538, 50);
        shurikensLabel = [CCLabelTTF labelWithString:@"0"
                          fontName:@"Marker Felt"
                          fontSize:24];
        shurikensLabel.position = ccp(538, 70);
        smokeBombsLabel = [CCLabelTTF labelWithString:@"0"
                           fontName:@"Marker Felt"
                           fontSize:24];
        smokeBombsLabel.position = ccp(538, 90);
        
        [self addChild:scoreLabel z:1];
        [self addChild:timeLabel z:1];
        [self addChild:livesLabel z:1];
        [self addChild:shurikensLabel z:1];
        [self addChild:smokeBombsLabel z:1];

        [self schedule:@selector(updateTime:) interval:.1];
    }
    
    return self;
}

-(void) updateTime:(ccTime)dt
{
    time -= dt;
    [timeLabel setString: [NSString stringWithFormat:@"%.0f", time]];
}

-(void) updateScore:(int)amount
{
    score += amount;
    [scoreLabel setString: [NSString stringWithFormat:@"%d", score]];
}

-(BOOL) updateLives:(int)amount
{
    lives += amount;
    [livesLabel setString:[NSString stringWithFormat:@"%d", lives]];
    
    if (lives <= 0)
        return FALSE;
    else
        return TRUE;
}

@end
