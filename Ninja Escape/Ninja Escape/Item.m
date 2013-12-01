//
//  Item.m
//  Ninja Rush
//
//  Created by Bryan Worrell on 11/17/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "item.h"


@implementation Item

@synthesize item;

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init]))
    {
        // Cache sprite frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", filename]];
        
        // Create sprite batch nodes
        CCSpriteBatchNode *itemSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", filename]];
        [self addChild:itemSheet];
        
        // Gather the list of frames for up, down and side walk animations
        NSMutableArray *itemFrames = [NSMutableArray array];
        
        if ([filename isEqual:@"smokeBomb"])
        {
            for (int i=1; i<=4; ++i)
                [itemFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"%@0%d.png",filename, i]]];
        }
        
        if ([filename isEqual: @"shurikenItem"])
        {
            for (int i=1; i<=2; ++i)
                [itemFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"%@0%d.png",filename, i]]];
        }
        
        // Create animation objects
        CCAnimation *itemAnim = [CCAnimation animationWithSpriteFrames:itemFrames delay:0.1f];
        
        // Create sprites and run animation actions
        self.item = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@01.png", filename]];
        
        CCAction *itemAnimation = [CCRepeatForever actionWithAction:
                                  [CCAnimate actionWithAnimation:itemAnim]];
        
        [itemSheet addChild:self.item];
        [self.item runAction:itemAnimation];
    }
    
    return self;
}

@end
