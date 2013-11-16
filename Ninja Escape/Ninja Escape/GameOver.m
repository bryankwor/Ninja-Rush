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
    CCScene *scene = [CCScene node];
    GameOver *layer = [GameOver node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        // Initialize
        self.touchEnabled = YES;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Set background image
        CCSprite *background = [CCSprite spriteWithFile:@"introScreen.png"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        background.rotation = 90;
        
        // Play game over theme
        
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
