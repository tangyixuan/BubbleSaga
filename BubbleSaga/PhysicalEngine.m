//
//  PhysicalEngine.m
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "PhysicalEngine.h"

@interface PhysicalEngine()

@property (nonatomic) CGFloat xIncrement;
@property (nonatomic) CGFloat yIncrement;
@property (nonatomic) CGFloat xDifference;
@property (nonatomic) CGFloat yDifference;
@property (nonatomic) CGFloat zDifference;
@property (nonatomic, weak) id<RenderViewsInPhysicalEngineDelegate> delegate;
@property (nonatomic) BubbleCollection *bubbleCollection;
@property (nonatomic) GameBubbleBasic *currentBubble;
@property (nonatomic) NSMutableArray *removeViews;
@property (nonatomic) NSMutableArray *specialBubblesTriggled;

@end

@implementation PhysicalEngine

- (id)initWithBubbleCollection:(BubbleCollection *)bubbleCollection andDelegate:(id<RenderViewsInPhysicalEngineDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.bubbleCollection = bubbleCollection;
        [self removeBubbleDisconnected];
    }
    return self;
}

- (BOOL) isValidToInitLunch:(GameBubbleBasic *)bubble withPosition:(CGPoint)position
{
    self.currentBubble = bubble;
    self.xDifference = position.x - bubble.view.center.x;
    self.yDifference = position.y - bubble.view.center.y;
    
    CGFloat angle = self.yDifference / self.xDifference;
    if (angle < 0){
        angle = - angle;
    }
    
    if(self.yDifference < 0 && angle > 0.5){
        self.zDifference = sqrt(pow(self.xDifference,2)+pow(self.yDifference,2));
        self.angle = sin(self.xDifference/self.zDifference)/cos(self.yDifference/self.zDifference);
        self.xIncrement = self.xDifference / self.zDifference * SPEED;
        self.yIncrement = self.yDifference / self.zDifference * SPEED;
        return YES;
    }else{
        return NO;
    }
}

- (void) lunchBubble
{
    self.currentBubble.view.center = CGPointMake(self.currentBubble.view.center.x + self.xIncrement, self.currentBubble.view.center.y + self.yIncrement);
    self.specialBubblesTriggled = [[NSMutableArray alloc]init];
}

- (BOOL) collisionWithBubble
{
    CGFloat x = self.currentBubble.view.center.x;
    CGFloat y = self.currentBubble.view.center.y;
    
    if(y < BOTTOM_BOUNDARY+BUBBLERADIUS){
        //search bubbles whose center is within Bubble diameter distance with this bubble
        NSInteger top = (y -BUBBLEDIAMETER -BUBBLERADIUS)/BUBBLEDIAMETER/DISTANCE_RATIO_OF_DIAMETER + 1;
        NSInteger bottom = (y + BUBBLEDIAMETER -BUBBLERADIUS)/BUBBLEDIAMETER/DISTANCE_RATIO_OF_DIAMETER + 1;
        for(NSInteger row = top; row < bottom; row++){
            if (row % 2 == 1){x = x - BUBBLERADIUS;}
            for(NSInteger column = (x - BUBBLEDIAMETER - BUBBLERADIUS)/ BUBBLEDIAMETER + 1; column < (x + BUBBLEDIAMETER - BUBBLERADIUS)/ BUBBLEDIAMETER + 1 ;column ++){
                if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
                    GameBubble *nearBubble = [self.bubbleCollection getBubbleAtRow:row andColumn:column];
                    if (nearBubble.color != TRANSPARENT) {
                        if([self distanceLessThanDiameterBetweenBubble:nearBubble andBubble:self.currentBubble]){
                            [self.bubbleCollection addBubble:self.currentBubble];
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return NO;
}

-(BOOL) hasConnectedBubbleOfSameColor
{
    NSArray *connectedBubbles;
    NSMutableArray *connectedBubblesOfSameColor = [[NSMutableArray alloc]init];
    Stack *stack = [Stack stack];
    [stack push: self.currentBubble];
    [connectedBubblesOfSameColor addObject:self.currentBubble];
    
    while([stack count] != 0){
        GameBubble *currentBubble = [stack pop];
        connectedBubbles = [self getConenctedBubblesForBubble: currentBubble];
        
        GameBubble *adjBubble;
        for(adjBubble in connectedBubbles){
            if(adjBubble.color == currentBubble.color && !([connectedBubblesOfSameColor containsObject:adjBubble])){
                [stack push:adjBubble];
                [connectedBubblesOfSameColor addObject:adjBubble];
            }
        }
    }
    
    self.removeViews = [[NSMutableArray alloc]init];
    
    if([connectedBubblesOfSameColor count]>=3){
        GameBubble *removeBubble;
        for(removeBubble in connectedBubblesOfSameColor){
            [self.removeViews addObject:removeBubble.view];
            [self.bubbleCollection replaceBubble:removeBubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:removeBubble.delegate]];
        }
        
        return YES;
    }
    return NO;
}

- (NSArray *)getRemoveBubbleViews
{
    return [self.removeViews copy];
}

//private methods
-(NSArray *) getConenctedBubblesForBubble:(GameBubble *)bubble{
    NSMutableArray *connectedBubbles = [NSMutableArray array];
    NSInteger row;
    NSInteger column;
    
    row = bubble.row - 1;
    if (row % 2 == 0) {
        column = bubble.column;
    }else{
        column = bubble.column-1;
    }
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    
    row = bubble.row - 1;
    if (row % 2 == 0) {
        column = bubble.column+1;
    }else{
        column = bubble.column;
    }
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    
    row = bubble.row;
    column = bubble.column - 1;
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    
    row = bubble.row;
    column = bubble.column + 1;
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    
    row = bubble.row + 1;
    if (row % 2 == 0) {
        column = bubble.column;
    }else{
        column = bubble.column-1;
    }
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    
    row = bubble.row + 1;
    if (row % 2 == 0) {
        column = bubble.column+1;
    }else{
        column = bubble.column;
    }
    if ([self.bubbleCollection isValidRow:row AndColumn:column]) {
        [connectedBubbles addObject:[self.bubbleCollection getBubbleAtRow:row andColumn:column]];
    }
    return [connectedBubbles copy];
}

- (NSArray *)removeBubbleDisconnected
{
    NSMutableSet *visitedBubbles = [NSMutableSet set];
    Stack *bubbleStack = [Stack stack];
    NSArray *connectedBubbles = [NSMutableArray array];
    
    for(int i=0; i<MAX_COLUMN; i++){
        GameBubble *rootBubble = [self.bubbleCollection getBubbleAtRow:0 andColumn:i];
        if(rootBubble.color!=TRANSPARENT){
            [visitedBubbles addObject:rootBubble];
            [bubbleStack push: rootBubble];
        }
    }
    
    while ([bubbleStack count]!=0) {
        GameBubble *currentBubble = [bubbleStack pop];
        connectedBubbles = [self getConenctedBubblesForBubble: currentBubble];
        
        GameBubble *adjBubble;
        for(adjBubble in connectedBubbles){
            if(adjBubble.color !=TRANSPARENT && !([visitedBubbles containsObject:adjBubble])){
                [bubbleStack push:adjBubble];
                [visitedBubbles addObject:adjBubble];
            }
        }
    }
    return [self.bubbleCollection removeBubbleNotIn: visitedBubbles withSpecialBubbles:self.specialBubblesTriggled];
}

-(BOOL)distanceLessThanDiameterBetweenBubble:(GameBubble *)A andBubble:(GameBubble *)B
{
    CGPoint centerA = A.view.center;
    CGPoint centerB = B.view.center;
    if(pow(centerA.x - centerB.x, 2) + pow(centerA.y - centerB.y, 2) < pow(BUBBLEDIAMETER,2)){
        return YES;
    }
    return NO;
}

- (BOOL) touchCeil
{
    if (self.currentBubble.view.center.y <= BUBBLERADIUS) {
        [self.bubbleCollection addBubble:self.currentBubble];
        return YES;
    }
    return NO;
}

- (BOOL) touchBoundary
{
    if((self.currentBubble.view.center.x > SCREENWIDTH - BUBBLERADIUS)||(self.currentBubble.view.center.x < BUBBLERADIUS)){
        return YES;
    }else{
        return NO;
    }
}

- (void) changeLunchDirection
{
    self.xIncrement = -self.xIncrement;
}

- (void)triggleSpecialBubbles
{
    
    NSArray *adjBubbles = [self getConenctedBubblesForBubble:self.currentBubble];
    GameBubble *bubble;
    for (bubble in adjBubbles) {
        if ([bubble isSpecialBubble]) {
            [self.specialBubblesTriggled addObject:bubble];
        }
    }
    
    NSArray *specialBubbleCopy = [self.specialBubblesTriggled copy];
    NSUInteger numOfSpecialBubbleTriggled = [specialBubbleCopy count];
    GameBubble *specialBubble;
    
    for (int index = 0; index < numOfSpecialBubbleTriggled; index ++){
        specialBubble = [specialBubbleCopy objectAtIndex:index];
        if ([self.specialBubblesTriggled containsObject:specialBubble]) {
            switch (specialBubble.bubbleType) {
                case BUBBLE_LIGHTENING:{
                    [self.bubbleCollection removeBubblesAtRow:specialBubble.row];
                    break;
                }
                case BUBBLE_BOMB:{
                    [self removeAdjcentBubblesOfBubble:specialBubble];
                    [self.bubbleCollection replaceBubble:specialBubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:specialBubble.delegate]];
                    break;
                }
                case BUBBLE_STAR:
                    [self.bubbleCollection removeBubblesOfColor:self.currentBubble.color];
                    [self.bubbleCollection replaceBubble:specialBubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:specialBubble.delegate]];
                    break;
                default:
                    break;
            }
            NSArray *disconnectedViews = [self removeBubbleDisconnected];
            [self.delegate disConnectedAnimation:disconnectedViews];
        }
    }
}

- (void)removeAdjcentBubblesOfBubble:specialBubble
{
    NSArray *adjBubbles = [self getConenctedBubblesForBubble:specialBubble];
    GameBubble *bubble;
    for (int i = 0;  i<[adjBubbles count];i++) {
        bubble = [adjBubbles objectAtIndex: i];
        [self.bubbleCollection replaceBubble:bubble withBubble:[[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:bubble.delegate]];
    }
}
@end
