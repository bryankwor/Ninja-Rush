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

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize screenSize;

    Ninja *ninja;
    CCAction *ninjaMove;
    BOOL ninjaMoving;

    CCArray *enemies;
    CCArray *shurikens;
    CCArray *items;
    
    GameData *UI;
}

+(CCScene *) scene;

@end
