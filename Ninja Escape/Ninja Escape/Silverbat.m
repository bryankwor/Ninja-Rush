//
// MyCocos2DClass.m
// Ninja Escape
//
// Created by Bryan Worrell on 10/9/13.
// Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Silverbat.h"

@implementation Silverbat

@synthesize silverbat;
@synthesize silverbatDown;
@synthesize silverbatSide;
@synthesize silverbatUp;

-(id) init
{
    if ((self=[super init]))
    {
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint spawnZone;
        spawnZone.y = arc4random() % (int)screenSize.height;
        spawnZone.x = arc4random() % (int)(screenSize.width - screenSize.width/7);
        if (spawnZone.x < (screenSize.width/7))
            spawnZone.x += screenSize.width/7;
        if (spawnZone.x > (screenSize.width-screenSize.width/7))
            spawnZone.x -= screenSize.width/7;
        
        // Cache sprite frames
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"silverbat.plist"];
        
        // Create sprite batch nodes
        CCSpriteBatchNode *silverbatSheet = [CCSpriteBatchNode batchNodeWithFile:@"silverbat.png"];
        [self addChild:silverbatSheet];
        
        // Gather the list of frames for up, down and side walk animations
        NSMutableArray *silverbatDownFrames = [NSMutableArray array];
        NSMutableArray *silverbatSideFrames = [NSMutableArray array];
        NSMutableArray *silverbatUpFrames = [NSMutableArray array];
        
        for (int i=1; i<=4; ++i)
            [silverbatDownFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
        
        for (int i=5; i<=8; ++i)
            [silverbatSideFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
        
        for (int i=9; i<=12; ++i)
        {
            if (i<=9)
                [silverbatUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat0%d.png",i]]];
            else
                [silverbatUpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"silverbat%d.png",i]]];
        }
        
        // Create animation objects
        CCAnimation *silverbatDownAnim = [CCAnimation
                                          animationWithSpriteFrames:silverbatDownFrames delay:0.1f];
        CCAnimation *silverbatSideAnim = [CCAnimation
                                          animationWithSpriteFrames:silverbatSideFrames delay:0.1f];
        CCAnimation *silverbatUpAnim = [CCAnimation
                                        animationWithSpriteFrames:silverbatUpFrames delay:0.1f];
        
        // Create sprites and run animation actions
        self.silverbat = [CCSprite spriteWithSpriteFrameName:@"silverbat01.png"];
        self.silverbat.position = ccp(spawnZone.x, spawnZone.y);
        
        self.silverbatDown = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:silverbatDownAnim]];
        self.silverbatSide = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:silverbatSideAnim]];
        self.silverbatUp = [CCRepeatForever actionWithAction:
                            [CCAnimate actionWithAnimation:silverbatUpAnim]];
        
        [silverbatSheet addChild:self.silverbat];
        
        self.silverbat.flipX = YES;
        [self.silverbat runAction:self.silverbatSide];
        [self schedule:@selector(moveSilverbat:) interval:5];
    }
    
    return self;
}

-(CGRect) getBoundingBox
{
    CGRect boundingBox = CGRectMake((self.silverbat.position.x-self.silverbat.contentSize.width/2), (self.silverbat.position.y-self.silverbat.contentSize.height/2), self.silverbat.contentSize.width, self.silverbat.contentSize.height);
    
    return boundingBox;
}

-(void) moveSilverbat:(ccTime)dt
{
    // Initialize variables
    CGPoint positionChange;
    int negate;
    
    // Calculate new position to move to
    positionChange.x = arc4random()%20;
    positionChange.x += 10;
    negate = arc4random()%2;
    if (negate == 1)
        positionChange.x *= -1;
    
    positionChange.y = arc4random()%20;
    positionChange.y += 10;
    negate = arc4random()%2;
    if (negate == 1)
        positionChange.y *= -1;
    
    // Calculate move duration based on screen size
    CGPoint newLocation;
    newLocation.x = positionChange.x + self.silverbat.position.x;
    newLocation.y = positionChange.y + self.silverbat.position.y;
    
    // Return if new location is out of bounds
    if (newLocation.x >= (screenSize.width-screenSize.width/7)-1 ||
        newLocation.x <= (screenSize.width/7+1) ||
        newLocation.y >= screenSize.height-1 || newLocation.y <= 1)
        return;
    
    float batVelocity = screenSize.width / 12.0;
    CGPoint moveDiff = ccpSub(newLocation, self.silverbat.position);
    float distanceToMove = ccpLength(moveDiff);
    float moveDuration = distanceToMove / batVelocity;
    
    float moveAngle = ((atan2f(moveDiff.y, moveDiff.x)) * 180) / M_PI;
    if (moveAngle < 0)
        moveAngle += 360;
    
    [self.silverbat stopAction:self.silverbatUp];
    [self.silverbat stopAction:self.silverbatSide];
    [self.silverbat stopAction:self.silverbatDown];
    
    if (moveAngle > 45 && moveAngle < 135)
    {
        self.silverbat.flipX = NO;
        [self.silverbat runAction:self.silverbatUp];
    }
    else if (moveAngle > 135 && moveAngle < 225)
    {
        self.silverbat.flipX = NO;
        [self.silverbat runAction:self.silverbatSide];
    }
    else if (moveAngle > 225 && moveAngle < 315)
    {
        self.silverbat.flipX = NO;
        [self.silverbat runAction:self.silverbatDown];
    }
    else
    {
        self.silverbat.flipX = YES;
        [self.silverbat runAction:self.silverbatSide];
    }
    
    silverbatMove = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:newLocation], nil];
    
    [self.silverbat runAction:self->silverbatMove];
}

@end