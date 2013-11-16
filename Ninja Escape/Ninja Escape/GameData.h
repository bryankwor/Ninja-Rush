//
//  GameData.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameData : CCLayer
{
    @public
        int score;
        float time;
        int lives;
        int shurikens;
        int smokeBombs;
    
    @private
        CCLabelTTF *scoreLabel;
        CCLabelTTF *timeLabel;
        CCLabelTTF *livesLabel;
        CCLabelTTF *shurikensLabel;
        CCLabelTTF *smokeBombsLabel;
}

@property int score;
@property float time;
@property int lives;
@property int shurikens;
@property int smokeBombs;

-(void) updateScore:(int)amount;
-(void) updateShurikens:(int)amount;
-(void) updateSmokeBombs:(int)amount;
-(BOOL) updateLives:(int)amount;
-(void) loadLives:(int)amount;
-(void) loadShurikens:(int)amount;
-(float) getTime;

+(GameData *) sharedData;

@end
