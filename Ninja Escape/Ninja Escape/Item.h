//
//  Item.h
//  Ninja Rush
//
//  Created by Bryan Worrell on 11/17/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Item : CCSprite
{
    CCSprite *item;

}

@property (nonatomic, strong) CCSprite *item;

-(CGRect) getBoundingBox;

@end
