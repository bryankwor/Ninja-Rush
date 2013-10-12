//
//  HelloWorldLayer.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{

}

+(CCScene *) scene;

@end
