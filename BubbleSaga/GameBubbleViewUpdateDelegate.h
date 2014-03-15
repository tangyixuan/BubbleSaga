//
//  GameBubbleViewUpdateDelegate.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameBubbleViewUpdateDelegate <NSObject>

- (void)updateView:(UIView *)view;

- (void)removeView:(UIView *)view;

- (void)addView:(UIView *)view;

- (void)setLunchingBubbleView;

- (void)showGameFailedView;

- (void)showGameWonView;

- (id)createBubbleOfType:(NSUInteger)toolIndex;

- (void)setCannonImageOfIndex:(NSUInteger)index;

- (void)setScoreValue;

@end
