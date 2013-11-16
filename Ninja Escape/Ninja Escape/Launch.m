//
//  Launch.m
//  Ninja Escape
//
//  Created by Bryan Worrell on 9/28/13.
//  Copyright Bryan Worrell 2013. All rights reserved.
//

#import "Launch.h"
#import "Intro.h"

@implementation Launch

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    Launch *layer = [Launch node];
    [scene addChild: layer];
	
	return scene;
}
 
-(id) init
{
	if ((self = [super init]))
    {
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *background;
		
        // iPhone
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
			background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
			background.rotation = 90;
		}
        // iPad
        else
        {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
        
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
    // Start up game
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Intro scene]]];
}

@end
