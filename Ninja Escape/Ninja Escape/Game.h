//
//  Game.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameData.h"
#import "Ninja.h"
#import "Silverbat.h"
#import "Shuriken.h"
#import "Item.h"
#import "Effects.h"

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize screenSize;
    int timeInvincible;

    Ninja *ninja;
    CCAction *ninjaMove;
    BOOL ninjaMoving;
    BOOL ninjaInvulnerable;

    CCArray *enemies;
    CCArray *shurikens;
    CCArray *items;
    CCArray *effects;
    CCArray *hearts;
    
    GameData *UI;
}

+(CCScene *) scene;

@end
