//
//  Hourglass.m
//  Ninja Rush
//
//  Created by Bryan Worrell on 12/1/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Hourglass.h"


@implementation Hourglass

@synthesize hourglass;

-(id) init
{
    if ((self = [super init]))
    {
        // Cache sprite frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hourglass.plist"];
        
        // Create sprite batch nodes
        CCSpriteBatchNode *hourglassSheet = [CCSpriteBatchNode batchNodeWithFile:@"hourglass.png"];
        [self addChild:hourglassSheet];
        
        // Gather the list of frames for up, down and side walk animations
        NSMutableArray *hourglassFrames = [NSMutableArray array];
        
        for (int i=1; i<=2; ++i)
            [hourglassFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"hourglass0%d.png",i]]];
        
        // Create animation objects
        CCAnimation *hourglassAnim = [CCAnimation animationWithSpriteFrames:hourglassFrames delay:0.1f];
        
        // Create sprites and run animation actions
        self.hourglass = [CCSprite spriteWithSpriteFrameName:@"hourglass01.png"];
        
        CCAction *hourglassSpin = [CCRepeatForever actionWithAction:
                                  [CCAnimate actionWithAnimation:hourglassAnim]];
        
        [hourglass addChild:self.hourglass];
        [self.hourglass runAction:shurikenSpin];
    }
    
    return self;
    
}

@end
