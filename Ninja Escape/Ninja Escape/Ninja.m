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
    if ((self = [super initWithSpriteFrameName:@"ninja01.png"]))
    {
        // Initalize
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        ninjaVelocity = screenSize.width / 6.0;
        ninjaMoving = NO;
        ninjaMove = nil;
        
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

-(void) moveToPosition:(CGPoint)location
{
    // Calculate move duration based on screen size
    CGPoint moveDiff = ccpSub(location, self.position);
    float distanceToMove = ccpLength(moveDiff);
    float moveDuration = distanceToMove / ninjaVelocity;
    
    float moveAngle = ((atan2f(moveDiff.y, moveDiff.x)) * 180) / M_PI;
    if (moveAngle < 0)
        moveAngle += 360;
    
    if (!ninjaMoving)
    {
        if (moveAngle > 45 && moveAngle < 135)
        {
            self.flipX = NO;
            [self runAction:ninjaUp];
        }
        else if (moveAngle > 135 && moveAngle < 225)
        {
            self.flipX = NO;
            [self runAction:ninjaSide];
        }
        else if (moveAngle > 225 && moveAngle < 315)
        {
            self.flipX = NO;
            [self runAction:ninjaDown];
        }
        else
        {
            self.flipX = YES;
            [self runAction:ninjaSide];
        }
    }
    
    ninjaMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:location], [CCCallFunc actionWithTarget:self selector:@selector(ninjaMoveEnded)], nil];
    
    [self runAction:ninjaMove];
    ninjaMoving = YES;
}
/*
-(CGRect) getBoundingBox
{
    CGRect boundingBox = CGRectMake((self.ninja.position.x-self.ninja.contentSize.width/2), (self.ninja.position.y-self.ninja.contentSize.height/2), self.ninja.contentSize.width, self.ninja.contentSize.height);
    
    return boundingBox;
}
*/

-(void) stopActions
{
    if (ninjaMoving)
    {
        [self stopAction:ninjaMove];
        [self stopAction:ninjaUp];
        [self stopAction:ninjaSide];
        [self stopAction:ninjaDown];
        ninjaMoving = NO;
    }
}

-(void) ninjaMoveEnded
{
    [self stopAction:ninjaUp];
    [self stopAction:ninjaSide];
    [self stopAction:ninjaDown];
    ninjaMoving = NO;
}

@end
