//
//  Effects.m
//  Ninja Rush
//
//  Created by Bryan Worrell on 11/17/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Effects.h"


@implementation Effects

@synthesize effect;
@synthesize timer;

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init]))
    {
        // Initialize
        timer = 130;
        
        // Cache sprite frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", filename]];
        
        // Create sprite batch nodes
        CCSpriteBatchNode *effectSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", filename]];
        [self addChild:effectSheet];
        
        // Gather the list of frames for up, down and side walk animations
        NSMutableArray *effectFrames = [NSMutableArray array];
        
        if ([filename isEqual:@"smoke"])
        {
            for (int i=1; i<=6; ++i)
                [effectFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"%@0%d.png",filename, i]]];
        }
        
        // Create animation objects
        CCAnimation *effectAnim = [CCAnimation animationWithSpriteFrames:effectFrames delay:0.1f];
        
        // Create sprites and run animation actions
        self.effect = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@01.png", filename]];
        
        CCAction *effectAnimation = [CCRepeatForever actionWithAction:
                                   [CCAnimate actionWithAnimation:effectAnim]];
        
        [effectSheet addChild:self.effect];
        [self.effect runAction:effectAnimation];
    }
    
    return self;
}

-(BOOL) timeTick:(int)amount
{
    --timer;
    
    if (timer == 0)
        return TRUE;
    else
        return FALSE;
}



@end
