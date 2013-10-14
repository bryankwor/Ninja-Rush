//
//  MyCocos2DClass.h
//  Ninja Escape
//
//  Created by Bryan Worrell on 10/9/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Silverbat : CCSprite
{
    CGSize screenSize;
}

@property (nonatomic, strong) CCSprite *silverbat;
@property (nonatomic, strong) CCAction *silverbatDown;
@property (nonatomic, strong) CCAction *silverbatSide;
@property (nonatomic, strong) CCAction *silverbatUp;
@property (nonatomic, strong) CCAction *silverbatMove;

@end
