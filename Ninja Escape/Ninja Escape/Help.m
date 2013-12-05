//
//  Help.m
//  Ninja Rush
//
//  Created by Bryan Worrell on 12/3/13.
//  Copyright 2013 Bryan Worrell. All rights reserved.
//

#import "Help.h"
#import "Intro.h"
#import "Shuriken.h"
#import "Effects.h"
#import "Item.h"

@implementation Help

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    Help *layer = [Help node];
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
        CCSprite *background = [CCSprite spriteWithFile:@"help.png"];
        background.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:background];
        
        // Add graphics
        Shuriken *cursor1 = [[Shuriken alloc] init];
        cursor1.position = ccp(12, 25);
        cursor1.scale *= 1.5;
        [self addChild:cursor1];
        
        Shuriken *cursor2 = [[Shuriken alloc] init];
        cursor2.position = ccp(12, 125);
        cursor2.scale *= 1.5;
        [self addChild:cursor2];
        
        Shuriken *cursor3 = [[Shuriken alloc] init];
        cursor3.position = ccp(12, 205);
        cursor3.scale *= 1.5;
        [self addChild:cursor3];
        
        Shuriken *cursor4 = [[Shuriken alloc] init];
        cursor4.position = ccp(12, 305);
        cursor4.scale *= 1.5;
        [self addChild:cursor4];
        
        Shuriken *cursor5 = [[Shuriken alloc] init];
        cursor5.position = ccp(240, 25);
        cursor5.scale *= 1.5;
        [self addChild:cursor5];
        
        Shuriken *cursor6 = [[Shuriken alloc] init];
        cursor6.position = ccp(12, 65);
        cursor6.scale *= 1.5;
        [self addChild:cursor6];
        
        Effects *smoke = [[Effects alloc] initWithFile:@"smoke"];
        smoke.position = ccp(345, 185);
        [self addChild:smoke];
        
        Item *hourglass = [[Item alloc] initWithFile:@"hourglass"];
        hourglass.position = ccp(174, 25);
        [self addChild:hourglass];
        
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
