//
//  Ninja.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 10/12/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Ninja.h"


@implementation Ninja

@synthesize ninjaDown;
@synthesize ninjaSide;
@synthesize ninjaUp;

-(id) init
{
    if ((self=[super initWithSpriteFrameName:@"ninja01.png"]))
    {
        // Gather animation frames
        NSMutableArray *ninjaDownFrames = [NSMutableArray array];
        NSMutableArray *ninjaSideFrames = [NSMutableArray array];
        NSMutableArray *ninjaUpFrames = [NSMutableArray array];
    
        for (int i=1; i<=4; ++i)
            [ninjaDownFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
    
        for (int i=5; i<=8; ++i)
            [ninjaSideFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
    
        for (int i=9; i<=12; ++i)
        {
            if (i<=9)
                [ninjaUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja0%d.png",i]]];
            else
                [ninjaUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"ninja%d.png",i]]];
        }
    
        // Create animation objects
        CCAnimation *ninjaDownAnim = [CCAnimation
                                  animationWithSpriteFrames:ninjaDownFrames delay:0.1f];
        CCAnimation *ninjaSideAnim = [CCAnimation
                                  animationWithSpriteFrames:ninjaSideFrames delay:0.1f];
        CCAnimation *ninjaUpAnim = [CCAnimation
                                animationWithSpriteFrames:ninjaUpFrames delay:0.1f];
    
        self.ninjaDown = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:ninjaDownAnim]];
        self.ninjaSide = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:ninjaSideAnim]];
        self.ninjaUp = [CCRepeatForever actionWithAction:
                    [CCAnimate actionWithAnimation:ninjaUpAnim]];
    }
    
    return self;
}

@end
