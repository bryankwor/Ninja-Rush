//
//  Intro.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Intro : CCLayer
{
    @private
        CCSprite *playGame;
        CCSprite *viewHelp;
}

@property (nonatomic, strong) CCSprite *playGame;
@property (nonatomic, strong) CCSprite *viewHelp;

+(CCScene *) scene;

@end
