//
//  HelloWorldLayer.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameUI.h"
#import "Ninja.h"
#import "Silverbat.h"
#import "Shuriken.h"

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize screenSize;
    BOOL ninjaMoving;
    GameUI *UI;
    CCAction *ninjaMove;
    Ninja *ninja;
    CCArray *bats;
    CCArray *shurikens;
}

+(CCScene *) scene;

@end
