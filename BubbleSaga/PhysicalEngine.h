//
//  PhysicalEngine.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleCollection.h"
#import "BubbleBuffer.h"
#import "Stack.h"
#import "RenderViewsInPhysicalEngineDelegate.h"

@interface PhysicalEngine : NSObject

@property (nonatomic) CGFloat angle;

- (id)initWithBubbleCollection:(BubbleCollection *)bubbleCollection andDelegate:(id<RenderViewsInPhysicalEngineDelegate>)delegate;

- (BOOL)isValidToInitLunch:(GameBubbleBasic *)bubble withPosition:(CGPoint)position;

- (NSArray *)removeBubbleDisconnected;

- (void)lunchBubble;
//REQUIRES: self.bubble !=nil
//MODIFIES: self.bubble
//EFFECTS: update bubble's status in 1/60 seconds

- (BOOL)collisionWithBubble;
//REQUIRES: self.bubble !=nil
//EFFECTS: detect bubbule collision wite other bubbles

- (BOOL)hasConnectedBubbleOfSameColor;

- (NSArray *)getRemoveBubbleViews;

- (BOOL)touchCeil;
//REQUIRES: self.bubble !=nil
//EFFECTS: detect whether the bubble touches the ceil

- (BOOL)touchBoundary;
//REQUIRES: self.bubble !=nil
//EFFECTS: detect whether the bubble touches the boundary

- (void)changeLunchDirection;
//REQUIRES: self.bubble !=nil
//MODIFIES: self.xIncrement

- (void)triggleSpecialBubbles;
@end
