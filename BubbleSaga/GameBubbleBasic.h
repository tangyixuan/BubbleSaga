//
//  GameBubbleBasic.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameBubble.h"

@interface GameBubbleBasic : GameBubble

- (id)initWithColor: (NSUInteger) color andDelegate:(id<GameBubbleViewUpdateDelegate>)delegate;

- (id)initRandomWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate;

- (id)initRandomWithTransparentWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate;

@end
