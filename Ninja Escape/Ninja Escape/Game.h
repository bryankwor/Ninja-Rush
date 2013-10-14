//
//  HelloWorldLayer.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Ninja.h"
#import "Silverbat.h"

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize screenSize;
    BOOL ninjaMoving;
    CCAction *ninjaMove;
    Ninja *ninja;
}

+(CCScene *) scene;

@end
