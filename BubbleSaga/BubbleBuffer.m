//
//  BubbleBuffer.m
//  BubbleSaga
//
//  Created by tangyixuan on 22/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "BubbleBuffer.h"

@interface BubbleBuffer()
@property (nonatomic) NSMutableArray *nextBubbles;
@property (nonatomic,weak) id <GameBubbleViewUpdateDelegate> delegate;
@end

@implementation BubbleBuffer

- (id) initWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.nextBubbles = [[NSMutableArray alloc]initWithCapacity:BUBBLE_BUFFER_CAPACITY];
        for (int index = 0; index < BUBBLE_BUFFER_CAPACITY; index ++) {
            [self.nextBubbles addObject:[[GameBubbleBasic alloc] initRandomWithDelegate:self.delegate]];
        }
    }
    return self;
}

- (GameBubbleBasic *)getNextBubble{
    GameBubbleBasic *nextBubble = [self.nextBubbles objectAtIndex:0];
    [self.nextBubbles removeObject:nextBubble];
    [self.nextBubbles addObject:[[GameBubbleBasic alloc]initRandomWithDelegate:self.delegate]];
    
    self.secondBubble = [self.nextBubbles objectAtIndex:0];
    self.thirdBubble = [self.nextBubbles objectAtIndex:1];
    return nextBubble;
}

@end
