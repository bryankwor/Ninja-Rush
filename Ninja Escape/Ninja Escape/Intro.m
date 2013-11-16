//
//  Intro.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//


#import "Intro.h"
#import "Game.h"
#import "CCTouchDispatcher.h"

@implementation Intro

@synthesize playGame;
@synthesize viewHelp;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    Intro *layer = [Intro node];
    
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

        playGame = [[CCSprite alloc] initWithFile:@"playGame.png"];
        playGame.position = ccp(screenSize.width/2, screenSize.height/2);
        viewHelp = [[CCSprite alloc] initWithFile:@"playGame.png"];
        viewHelp.position = ccp(screenSize.width/2, screenSize.height/2-20);
        
        [self addChild:playGame];
        [self addChild:viewHelp];
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
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGRect boundingBox = [playGame boundingBox];
    
    if (CGRectContainsPoint(boundingBox, location))
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene]]];
    
    boundingBox = [viewHelp boundingBox];
    /*
    if (CGRectContainsPoint(boundingBox, location))
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Help scene]]];
    */
    
}

@end
