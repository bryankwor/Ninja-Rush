//
//  Shuriken.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 10/31/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Shuriken.h"


@implementation Shuriken

@synthesize isDoneMoving;
@synthesize shuriken;

-(id) init
{
    if ((self=[super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        shurikenVelocity = screenSize.width / 4.0;
        shurikenMove = nil;
        self.isDoneMoving = FALSE;
        
        // Cache sprite frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shuriken.plist"];
        
        // Create sprite batch nodes
        CCSpriteBatchNode *shurikenSheet = [CCSpriteBatchNode batchNodeWithFile:@"shuriken.png"];
        [self addChild:shurikenSheet];
        
        // Gather the list of frames for up, down and side walk animations
        NSMutableArray *shurikenFrames = [NSMutableArray array];
       
        for (int i=1; i<=2; ++i)
            [shurikenFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"shuriken0%d.png",i]]];
        
        // Create animation objects
        CCAnimation *shurikenAnim = [CCAnimation animationWithSpriteFrames:shurikenFrames delay:0.1f];
        
        // Create sprites and run animation actions
        self.shuriken = [CCSprite spriteWithSpriteFrameName:@"shuriken01.png"];
       
        CCAction *shurikenSpin = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:shurikenAnim]];
        
        [shurikenSheet addChild:self.shuriken];
        [self.shuriken runAction:shurikenSpin];
    }
    
    return self;
    
}

-(CGRect) getBoundingBox
{
    CGRect boundingBox = CGRectMake(0, 0, self.shuriken.contentSize.width/6, self.shuriken.contentSize.height/6);
    
    return boundingBox;
}


-(void) moveToPosition:(CGPoint)location
{
    // Calculate move duration based on screen size
    CGPoint moveDiff = ccpSub(location, self.position);
    float distanceToMove = ccpLength(moveDiff);
    float moveDuration = distanceToMove / shurikenVelocity;
    
    shurikenMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:location], [CCCallFunc actionWithTarget:self selector:@selector(shurikenMoveEnded)], nil];
    
    [self runAction:shurikenMove];
}

-(void) shurikenMoveEnded
{
    self.isDoneMoving = TRUE;
}
    
@end
