//
//  ConstantVariables.h
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger BLUE = 0;
static const NSUInteger RED = 1;
static const NSUInteger GREEN = 2;
static const NSUInteger ORANGE = 3;
static const NSUInteger NUM_COLOR = 4;

static const NSUInteger TRANSPARENT = 4;
static const NSUInteger INVALID_COLOR = 100;

static const NSUInteger BUBBLE_BASIC = 0;
static const NSUInteger BUBBLE_INDESTRUCTIBLE = 4;
static const NSUInteger BUBBLE_LIGHTENING = 5;
static const NSUInteger BUBBLE_BOMB = 6;
static const NSUInteger BUBBLE_STAR = 7;
static const NSUInteger ERASER = 8;

static const NSUInteger BUBBLE_BUFFER_CAPACITY = 5;
static const NSUInteger MIN_NUM_SPECIAL_BUBBLE = 3;
static const NSUInteger SHOT_LIMIT = 50;

static const unsigned int NUM_BUBBLE_TYPE = 5;
static const unsigned int NUM_TOOL = 8;
static const unsigned int MAX_ROW = 13;
static const unsigned int NUM_EMPTY_ROW = 3;
static const unsigned int NUM_SPECIAL_BUBBLE_INCREMENT = 5;
static const unsigned int MAX_COLUMN = 12;

static const CGFloat BUBBLEDIAMETER = 64.0;
static const CGFloat BUBBLERADIUS = 32.0;
static const CGFloat DISTANCE_RATIO_OF_DIAMETER = 0.866;
static const CGFloat SCREENWIDTH = 768.0;
static const CGFloat SCREENLENGTH = 960.0;
static const CGFloat BOTTOM_BOUNDARY = DISTANCE_RATIO_OF_DIAMETER*BUBBLEDIAMETER*(MAX_ROW-1);
static const CGFloat DESIGN_BOTTOM_BOUNDARY = DISTANCE_RATIO_OF_DIAMETER*BUBBLEDIAMETER*(MAX_ROW-NUM_EMPTY_ROW);
static const CGFloat DESIGN_SCREEN_TOP = 64.0;
static const CGFloat DESIGN_SCREEN_LENGTH = 860.0;

static const CGFloat POP_VIEW_START_WIDTH = 20;
static const CGFloat POP_VIEW_START_HEIGHT = 900;
static const CGFloat POP_VIEW_WIDTH = 250;
static const CGFloat POP_VIEW_HEIGHT = 400;

static const CGFloat CANNON_BASE_WIDTH = 2*BUBBLEDIAMETER;
static const CGFloat CANNON_BASE_HEIGHT = 1.2* BUBBLEDIAMETER;
static const NSUInteger CANNON_ROW_NUM = 2;
static const NSUInteger CANNON_COLUMN_NUM = 6;
static const CGFloat CANNON_WIDTH = 1.5*BUBBLEDIAMETER;
static const CGFloat CANNON_HEIGHT = 2* BUBBLEDIAMETER;

static const CGFloat SPEED = 15.0;
static const CGFloat GAME_LOOP_TIME_INTERVAL = 1.0/60.0;
static const CGFloat ANIMATION_TIME_INTERVAL = 0.5;
static const CGFloat CANNON_ANIMATION_TIME_INTERVAL = 1.0/30.0;
static const CGFloat ROTATE_TIME_INTERVAL = 0.4;
static const CGFloat ALPHA_DECREMENT = 0.05;
static const CGFloat SIZE_INCREMENT = 0.5;

static const NSUInteger DEFAULT_FILE_INDEX = 0;
static const NSUInteger DEFAULT_FILE_NUM = 3;
static const CGFloat LEVEL_VIEW_WIDTH = 200.0;
static const CGFloat LEVEL_VIEW_LENGTH = 240.0;

@interface ConstantVariables : NSObject

@end
