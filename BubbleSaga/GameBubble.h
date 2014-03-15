//
//  GameBubble.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantVariables.h"
#import "UIImage+Resize.h"
#import "GameBubbleViewUpdateDelegate.h"

@interface GameBubble : UIViewController

@property (nonatomic) NSUInteger bubbleType;
@property (nonatomic) NSUInteger row;
@property (nonatomic) NSUInteger column;
@property (nonatomic) NSUInteger color;

@property (nonatomic, weak) id <GameBubbleViewUpdateDelegate> delegate;

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>) delegate;

- (id)initGeneral;

- (void)setRow:(NSUInteger)row andColumn:(NSUInteger)column;

- (BOOL)isSpecialBubble;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

@end
