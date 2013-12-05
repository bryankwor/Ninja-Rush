//
//  Intro.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 11/11/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Intro.h"
#import "Game.h"
#import "Help.h"
#import "CCTouchDispatcher.h"

@implementation Intro

@synthesize playGame;
@synthesize viewHelp;

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    Intro *layer = [Intro node];
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

        // Set background
        CCSprite *background = [CCSprite spriteWithFile:@"IntroScreen.png"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        background.rotation = 90;
        
        // Start opening theme

        // Create and set button positions
        playGame = [[CCSprite alloc] initWithFile:@"play.png"];
        playGame.position = ccp(510, 190);
        viewHelp = [[CCSprite alloc] initWithFile:@"controls.png"];
        viewHelp.position = ccp(450, 150);
        
        // Add buttons to scene
        [self addChild:playGame];
        [self addChild:viewHelp];
        
        // Add graphics
        Shuriken *playShuriken = [[Shuriken alloc] init];
        playShuriken.position = ccp(440, 190);
        playShuriken.scale *= 2;
        [self addChild:playShuriken];
        
        Shuriken *controlsShuriken = [[Shuriken alloc] init];
        controlsShuriken.position = ccp(320, 150);
        controlsShuriken.scale *= 2;
        [self addChild:controlsShuriken];
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
    // Get touch location and button bounding box
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect boundingBox = [playGame boundingBox];
    
    // Start the game if play is touched
    if (CGRectContainsPoint(boundingBox, location))
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene]]];
    
    // Display help if help is touched
    boundingBox = [viewHelp boundingBox];
    
    if (CGRectContainsPoint(boundingBox, location))
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Help scene]]];
}

@end
