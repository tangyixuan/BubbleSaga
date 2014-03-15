//
//  GameEngine.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicalEngine.h"

@interface GameEngine : NSObject <RenderViewsInPhysicalEngineDelegate>

- (id)initWithBubbleCollection:(BubbleCollection *)bubbleCollection AndDelegate: (id<GameBubbleViewUpdateDelegate>) delegate;

- (void) bubbleLunch:(GameBubbleBasic *)bubble withPosition:(CGPoint)position andCannon:(UIImageView *)cannon;

@end
