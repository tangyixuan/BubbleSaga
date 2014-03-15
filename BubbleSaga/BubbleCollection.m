//
//  BubbleCollection.m
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "BubbleCollection.h"

@interface BubbleCollection()

@property (nonatomic) NSMutableArray *bubbleCollection;
@property (nonatomic,weak) id<GameBubbleViewUpdateDelegate> delegate;

@end

@implementation BubbleCollection

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)fillBubbleCollectionWithTransparentBubbles
{
    self.bubbleCollection = [NSMutableArray arrayWithCapacity:MAX_ROW];
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        [self.bubbleCollection addObject:[NSMutableArray arrayWithCapacity: maxColumnNumber]];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate];
            [newBubble setRow:row andColumn:column];
            self.bubbleCollection[row][column] = newBubble;
        }
    }
}

- (void)fillBubbleCollectionLevel:(NSUInteger)index
{
    self.bubbleCollection = [NSMutableArray arrayWithCapacity:MAX_ROW];
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        [self.bubbleCollection addObject:[NSMutableArray arrayWithCapacity: maxColumnNumber]];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *newBubble;
            if (row < MAX_ROW - NUM_EMPTY_ROW) {
                switch (index) {
                    case 0:
                        newBubble = [[GameBubbleBasic alloc] initWithColor:row%NUM_COLOR andDelegate:self.delegate];
                        break;
                    case 1:
                        newBubble = [[GameBubbleBasic alloc] initWithColor:column%NUM_COLOR andDelegate:self.delegate];
                        break;
                    case 2:
                        if (column == row) {
                            switch (column%4 + 4) {
                                case BUBBLE_INDESTRUCTIBLE:
                                    newBubble = [[GameBubbleLightening alloc]initWithDelegate:self.delegate];
                                    break;
                                case BUBBLE_LIGHTENING:
                                    newBubble = [[GameBubbleBomb alloc]initWithDelegate:self.delegate];
                                    break;
                                case BUBBLE_BOMB:
                                    newBubble = [[GameBubbleStar alloc]initWithDelegate:self.delegate];
                                    break;
                                case BUBBLE_STAR:
                                    newBubble = [[GameBubbleIndestructible alloc]initWithDelegate:self.delegate];
                                    break;
                                default:
                                    break;
                            }
                        }else if(column>row - 3){
                            newBubble = [[GameBubbleBasic alloc] initWithColor:row%NUM_COLOR andDelegate:self.delegate];
                        }else{
                            newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate];
                        }
                        break;
                    default:
                        break;
                }
            }else{
                newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate];
            }
            [newBubble setRow:row andColumn:column];
            self.bubbleCollection[row][column] = newBubble;
        }
    }
}

- (void)fillBubbleCollectionWithRandomBubbles
{
    self.bubbleCollection = [NSMutableArray arrayWithCapacity:MAX_ROW];
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        [self.bubbleCollection addObject:[NSMutableArray arrayWithCapacity: maxColumnNumber]];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *newBubble;
            if (row < MAX_ROW - NUM_EMPTY_ROW) {
                newBubble  = [[GameBubbleBasic alloc]initRandomWithTransparentWithDelegate:self.delegate];
            }else{
                newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate];
            }
            [newBubble setRow:row andColumn:column];
            self.bubbleCollection[row][column] = newBubble;
        }
    }
    
    [self addSpecialBubbles];
}

- (void)drawGrid
{
    for (int row = 0; row < MAX_ROW - NUM_EMPTY_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            CGPoint center = [self getPositionFromRow:row andCol:column];
            CGRect frame = CGRectMake(center.x - BUBBLERADIUS, center.y - BUBBLERADIUS, BUBBLEDIAMETER,BUBBLEDIAMETER);
            UIView *bubbleCircle = [[UIView alloc] init];
            bubbleCircle.frame = frame;
            [bubbleCircle.layer setBorderColor:[UIColor blackColor].CGColor];
            [bubbleCircle.layer setBorderWidth: 2.0f];
            [bubbleCircle.layer setCornerRadius:BUBBLERADIUS];
            [self.delegate addView:bubbleCircle];
            bubbleCircle.layer.zPosition = 1;
        }
    }
}

- (GameBubble *)getBubbleAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    return [[self.bubbleCollection objectAtIndex:row] objectAtIndex:column];
}

- (void)addBubble: (GameBubble *)newBubble
{
    [self addBubble:newBubble atPosition:newBubble.view.center];
}

- (void)addBubble: (GameBubble *)newBubble atPosition: (CGPoint) position
{
    GameBubble *oldBubble = [self getBubbleAtPosition:position];
    if (oldBubble) {
        [self replaceBubble:oldBubble withBubble:newBubble];
    }
}

- (void)replaceBubble:(GameBubble *)oldBubble withBubble:(GameBubble *)newBubble
{
    [newBubble setRow:oldBubble.row andColumn:oldBubble.column];
    [oldBubble.delegate removeView:oldBubble.view];
    
    [[self.bubbleCollection objectAtIndex:oldBubble.row] replaceObjectAtIndex:oldBubble.column withObject:newBubble];
}

- (NSArray *)removeBubbleNotIn:(NSSet *)connectedBubbles withSpecialBubbles:(NSMutableArray *)specialBubbles
{
    GameBubble *oldBubble;
    NSMutableArray *disconnectedViews = [[NSMutableArray alloc]init];
    
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            oldBubble = [self getBubbleAtRow:row andColumn:column];
            if(![connectedBubbles containsObject:oldBubble] && (oldBubble.color!=TRANSPARENT)){
                if ([specialBubbles containsObject:oldBubble]) {
                    [specialBubbles removeObject:oldBubble];
                }
                
                id copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:oldBubble.view]];
                UIView *newView = (UIView *)copyOfView;
                [disconnectedViews addObject:newView];
                [self replaceBubble:oldBubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate: oldBubble.delegate]];
            }
        }
    }
    
    return disconnectedViews;
}

- (BOOL) isValidRow:(int)row AndColumn:(int)column
{
    if (row >= 0 && row < MAX_ROW) {
        if (column >= 0 && column < [self getMaxNumberOfColumnForRow:row]) {
            return YES;
        }
    }
    return NO;
}

- (void)switchBubbleColorAtPosition:(CGPoint)position
{
    GameBubble *oldBubble = [self getBubbleAtPosition:position];
    
    if(oldBubble && oldBubble.color !=TRANSPARENT){
        NSUInteger oldTool = oldBubble.bubbleType;
        NSUInteger newTool;
        
        if (oldTool == BUBBLE_BASIC) {
            oldTool = oldBubble.color;
        }
        
        newTool = (oldTool +1) % NUM_TOOL;
        GameBubble *newBubble = [self.delegate createBubbleOfType:newTool];
        [self replaceBubble:oldBubble withBubble:newBubble];
    }
}

- (BOOL)isEmpty
{
    NSArray *row;
    for (row in self.bubbleCollection) {
        GameBubble *bubble;
        for (bubble in row) {
            if (bubble.color != TRANSPARENT) {
                return NO;
            }
        }
    }
    return YES;
}

- (void) clear
{
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *bubble = self.bubbleCollection[row][column];
            [self replaceBubble:bubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate]];
        }
    }
}

- (NSData *)encodeWithImage:(UIImage*)image
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSData *imageData = UIImagePNGRepresentation(image);
    [archiver encodeObject:imageData forKey:@"image"];
    
    int index = 0;
    NSArray *row;
    for (row in self.bubbleCollection) {
        GameBubble *bubble;
        for (bubble in row) {
            [archiver encodeInteger:bubble.bubbleType forKey:[NSString stringWithFormat:@"bubbleType %d",index]];
            [archiver encodeObject:bubble forKey:[NSString stringWithFormat:@"bubble %d",index]];
            index++;
        }
    }
    
    [archiver finishEncoding];
    return data;
}

- (void) resetWithData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    int index = 0;
    
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *oldbubble = self.bubbleCollection[row][column];
            NSUInteger bubbleType = [unarchiver decodeIntegerForKey:[NSString stringWithFormat:@"bubbleType %d",index]];
            
            if (bubbleType == BUBBLE_BASIC){
                GameBubbleBasic *newBubble = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"bubble %d",index]];
                newBubble.delegate = oldbubble.delegate;
                [self replaceBubble:oldbubble withBubble:newBubble];
            }else if(bubbleType == BUBBLE_INDESTRUCTIBLE){
                GameBubbleIndestructible *newBubble = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"bubble %d",index]];
                newBubble.delegate = oldbubble.delegate;
                [self replaceBubble:oldbubble withBubble:newBubble];
            }
            else if(bubbleType ==  BUBBLE_LIGHTENING){
                GameBubbleLightening *newBubble = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"bubble %d",index]];
                newBubble.delegate = oldbubble.delegate;
                [self replaceBubble:oldbubble withBubble:newBubble];
            }else if(bubbleType == BUBBLE_BOMB){
                GameBubbleBomb *newBubble = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"bubble %d",index]];
                newBubble.delegate = oldbubble.delegate;
                [self replaceBubble:oldbubble withBubble:newBubble];
            }else if(bubbleType ==  BUBBLE_STAR){
                GameBubbleStar *newBubble = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"bubble %d",index]];
                newBubble.delegate = oldbubble.delegate;
                [self replaceBubble:oldbubble withBubble:newBubble];
            } else {
                NSLog(@"Invalid bubble type in decoding");
            }
            index++;
        }
    }
}

- (void)removeBubblesAtRow:(NSUInteger)row
{
    NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
    for (int column = 0; column < maxColumnNumber; column++) {
        GameBubble *oldBubble = [self getBubbleAtRow:row andColumn:column];
        [self replaceBubble:oldBubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self.delegate]];
    }
}

- (void)removeBubblesOfColor:(NSUInteger)color
{
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *bubble = [self getBubbleAtRow:row andColumn:column];
            if (bubble.color == color) {
                [self replaceBubble:bubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate: bubble.delegate]];
            }
        }
    }
}


- (GameBubble *)getBubbleAtPosition:(CGPoint) position
{
    CGFloat y = position.y;
    CGFloat originPositionDifference = BUBBLEDIAMETER * DISTANCE_RATIO_OF_DIAMETER;
    CGFloat difference = BUBBLEDIAMETER - originPositionDifference;
    int row1 = y / originPositionDifference;
    int row2 = row1 - 1;
    CGFloat rowRest = y - originPositionDifference * row1;
    
    int column1 = [self checkColumn:position.x ForRow:row1];
    NSUInteger distance1 = [self  distanceBetweenPosition:(CGPoint)position andRow:row1 andCol:column1];
    int column2 = [self checkColumn:position.x ForRow:row2];
    NSUInteger distance2 = [self distanceBetweenPosition:(CGPoint)position andRow:row2 andCol:column2];
    
    if((rowRest < difference) && (distance2 < distance1)){
        if([self isValidRow:row2 AndColumn:column2]){
            return [self getBubbleAtRow:row2 andColumn:column2];
        }else{
            NSLog(@"INVALID ROW AND COLUMN IN bubbleCollection addBubble case 1");
            return nil;
        }
    }else{
        if([self isValidRow:row1 AndColumn:column1]){
            return [self getBubbleAtRow:row1 andColumn:column1];
        }else{
            NSLog(@"INVALID ROW AND COLUMN IN bubbleCollection addBubble case 2");
            return nil;
        }
    }
}

- (void)replaceBubbleAtRow:(NSUInteger)row andColumn:(NSUInteger)column withBubble: (GameBubble *)newBubble
{
    GameBubble *oldBubble = [self getBubbleAtRow:row andColumn:column];
    [self replaceBubble:oldBubble withBubble:newBubble];
}

- (NSUInteger)getMaxNumberOfColumnForRow:(NSUInteger)row
{
    return (row % 2) == 0 ? MAX_COLUMN : (MAX_COLUMN - 1);
}

-(int) checkColumn:(CGFloat) x ForRow:(int)row
{
    int column;
    if(row % 2 == 0){
        column = x / BUBBLEDIAMETER;
    }else{
        column = (x - BUBBLERADIUS) / BUBBLEDIAMETER;
        if(column > MAX_COLUMN -2) {
            column = MAX_COLUMN -2;
        }
    }
    return column;
}

-(CGFloat)distanceBetweenPosition:(CGPoint)positionA andRow:(int)row andCol:(int)col{
    CGPoint positionB = [self getPositionFromRow:row andCol:col];
    return pow(positionA.x - positionB.x, 2) + pow(positionA.y - positionB.y, 2);
}

- (CGPoint) getPositionFromRow:(int)row andCol:(int)col{
    CGFloat y = BUBBLEDIAMETER * DISTANCE_RATIO_OF_DIAMETER * row + BUBBLERADIUS;
    CGFloat x = BUBBLEDIAMETER* col + BUBBLERADIUS;
    
    if(row % 2 == 1) {
        x += BUBBLERADIUS;
    }
    return CGPointMake(x, y);
}

- (void)addSpecialBubbles{
    NSUInteger numOfSpecialBubbles = arc4random_uniform(NUM_SPECIAL_BUBBLE_INCREMENT)+MIN_NUM_SPECIAL_BUBBLE;
    for (int i = 0; i<numOfSpecialBubbles; i++) {
        int row = arc4random_uniform(MAX_ROW - NUM_EMPTY_ROW);
        int column = arc4random_uniform([self getMaxNumberOfColumnForRow:row]);
        int bubbleType = arc4random_uniform(NUM_BUBBLE_TYPE - 1 ) + NUM_COLOR;
        
        //indestructible bubbles cannot in first row, since they will never be dropped then
        while (row == 0 && bubbleType == BUBBLE_INDESTRUCTIBLE) {
            bubbleType = arc4random_uniform(NUM_BUBBLE_TYPE - 1) + NUM_COLOR;
        }
        
        GameBubble *newBubble;
        switch (bubbleType) {
            case BUBBLE_INDESTRUCTIBLE:
                newBubble = [[GameBubbleIndestructible alloc]initWithDelegate:self.delegate];
                break;
            case BUBBLE_LIGHTENING:
                newBubble = [[GameBubbleLightening alloc]initWithDelegate:self.delegate];
                break;
            case BUBBLE_BOMB:
                newBubble = [[GameBubbleBomb alloc]initWithDelegate:self.delegate];
                break;
            case BUBBLE_STAR:
                newBubble = [[GameBubbleStar alloc]initWithDelegate:self.delegate];
                break;
            default:
                break;
        }
        
        [self replaceBubbleAtRow:row andColumn:column withBubble:newBubble];
    }
}

-(NSUInteger)getBubbleNumber{
    int count = 0;
    for (int row = 0; row < MAX_ROW; row++) {
        NSUInteger maxColumnNumber = [self getMaxNumberOfColumnForRow:row];
        for (int column = 0; column < maxColumnNumber; column++) {
            GameBubble *bubble = self.bubbleCollection[row][column];
            if (bubble.color!=TRANSPARENT) {
                count ++;
            }
        }
    }
    return count;
}

@end
