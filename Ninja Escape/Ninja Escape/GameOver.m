//
//  GameOver.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/12/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Intro.h"
#import "GameOver.h"
#import "CCTouchDispatcher.h"

@implementation GameOver

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameOver *layer = [GameOver node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        self.touchEnabled = YES;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"introScreen.png"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        background.rotation = 90;
        
    }
    
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Intro scene]]];
}

@end
