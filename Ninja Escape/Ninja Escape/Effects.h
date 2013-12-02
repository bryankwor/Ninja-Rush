//
//  Effects.h
//  Ninja Rush
//
//  Created by Bryan Worrell on 12/1/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Effects : CCSprite
{
    @public
        int timer;
    
    @private
        CCSprite *effect;
}

@property int timer;
@property (nonatomic, strong) CCSprite *effect;

-(BOOL) timeTick:(int)amount;

@end
