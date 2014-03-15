//
//  BubbleCollection.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBubbleBasic.h"
#import "GameBubbleIndestructible.h"
#import "GameBubbleLightening.h"
#import "GameBubbleBomb.h"
#import "GameBubbleStar.h"

@interface BubbleCollection : NSObject

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate;

- (void)fillBubbleCollectionWithRandomBubbles;

- (void)fillBubbleCollectionWithTransparentBubbles;

- (void)fillBubbleCollectionLevel:(NSUInteger)index;

- (void)drawGrid;

- (GameBubble *)getBubbleAtRow:(NSUInteger)row andColumn:(NSUInteger)column;

- (void)addBubble: (GameBubble *)newBubble;

- (void)addBubble: (GameBubble *)newBubble atPosition:(CGPoint)position;

- (void)switchBubbleColorAtPosition:(CGPoint)position;

- (void)replaceBubble:(GameBubble *)oldBubble withBubble:(GameBubble *)newBubble;

- (NSArray *)removeBubbleNotIn:(NSSet *)connectedBubbles withSpecialBubbles:(NSMutableArray *)specialBubbles;

- (BOOL)isValidRow:(int)row AndColumn:(int)column;

- (BOOL)isEmpty;

- (void)clear;

- (NSData *)encodeWithImage:(UIImage *)image;

- (void)resetWithData:(NSData *)data;

- (void)removeBubblesAtRow:(NSUInteger)row;

- (void)removeBubblesOfColor:(NSUInteger)color;

-(NSUInteger) getBubbleNumber;

@end