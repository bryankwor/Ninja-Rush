//
//  Shuriken.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 10/31/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Shuriken : CCSprite
{
    @public
        BOOL isDoneMoving;
        CCSprite *shuriken;
    
    @private
        float shurikenVelocity;
        CCAction *shurikenMove;
}

@property BOOL isDoneMoving;
@property (nonatomic, strong) CCSprite *shuriken;

-(CGRect) getBoundingBox;
-(void) moveToPosition:(CGPoint)location;

@end
