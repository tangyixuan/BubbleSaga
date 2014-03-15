//
//  BubbleBuffer.h
//  BubbleSaga
//
//  Created by tangyixuan on 22/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBubbleBasic.h"

@interface BubbleBuffer : NSObject

@property (nonatomic) GameBubbleBasic *secondBubble;
@property (nonatomic) GameBubbleBasic *thirdBubble;

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate;

- (GameBubbleBasic *)getNextBubble;

@end
