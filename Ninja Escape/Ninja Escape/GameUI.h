//
//  GameUI.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameUI : CCNode
{
    @private
        int score;
        float time;
        int lives;
        int shurikens;
        int smokeBombs;
        CCLabelTTF *scoreLabel;
        CCLabelTTF *timeLabel;
        CCLabelTTF *livesLabel;
        CCLabelTTF *shurikensLabel;
        CCLabelTTF *smokeBombsLabel;
}

@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic, strong) CCLabelTTF *timeLabel;
@property (nonatomic, strong) CCLabelTTF *livesLabel;

-(void) updateScore:(int)amount;
-(BOOL) updateLives:(int)amount;

@end
