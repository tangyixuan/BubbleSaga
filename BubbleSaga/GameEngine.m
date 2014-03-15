//
//  GameEngine.m
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameEngine.h"

@interface GameEngine()

@property (nonatomic) PhysicalEngine *physicalEngine;
@property (nonatomic) GameBubbleBasic *currentBubble;
@property (nonatomic) BubbleCollection *bubbleCollection;

@property (nonatomic) NSTimer *lunchTimer;
@property (nonatomic) id<GameBubbleViewUpdateDelegate> delegate;
@property (nonatomic) NSTimer *removeTimer;
@property (nonatomic) NSArray *removeViews;

@property (nonatomic) UIImageView *cannon;
@property (nonatomic) NSUInteger cannonIndex;
@property (nonatomic) NSTimer *cannonTimer;

@end

@implementation GameEngine

- (id)initWithBubbleCollection:(BubbleCollection *)bubbleCollection AndDelegate:(id<GameBubbleViewUpdateDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.bubbleCollection = bubbleCollection;
        self.delegate = delegate;
        self.physicalEngine = [[PhysicalEngine alloc]initWithBubbleCollection:bubbleCollection andDelegate:self];
        
    }
    return self;
}

- (void) bubbleLunch:(GameBubbleBasic *)bubble withPosition:(CGPoint)position andCannon:(UIImageView *)cannon
{
    self.currentBubble = bubble;
    self.cannon = cannon;
    if (!self.lunchTimer){
        if([self.physicalEngine isValidToInitLunch: bubble withPosition:position]){
            self.currentBubble.view.layer.zPosition = 1;
            [self.delegate updateView:self.currentBubble.view];
            [self rotateCannon];
            self.lunchTimer = [NSTimer scheduledTimerWithTimeInterval:GAME_LOOP_TIME_INTERVAL target:self selector: @selector(updateLunchPosition) userInfo: nil repeats:YES];
        }
    }
}

- (void)rotateCannon
{
    CGFloat angle = self.physicalEngine.angle;
    
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformMakeRotation(angle);
    
    self.cannon.transform = rotationTransform;
    self.cannonIndex = 1;
    self.cannonTimer = [NSTimer scheduledTimerWithTimeInterval:CANNON_ANIMATION_TIME_INTERVAL target:self selector:@selector(cannonAnimation) userInfo:nil repeats:YES];
}

- (void) cannonAnimation
{
    if (self.cannonIndex < 12) {
        [self.delegate setCannonImageOfIndex: self.cannonIndex];
        self.cannonIndex ++;
    } else {
        [self.cannonTimer invalidate];
        [UIView animateWithDuration: ROTATE_TIME_INTERVAL animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformMakeRotation(0);
            self.cannon.transform = rotationTransform;
        }];
        self.cannonIndex = 0;
    }
}

- (void) updateLunchPosition
{
    [self.physicalEngine lunchBubble];
    
    if([self.physicalEngine collisionWithBubble]){
        [self.lunchTimer invalidate];
        self.lunchTimer = nil;
        
        if ([self gameFailed]) {
            [self.delegate showGameFailedView];
        }else{
            [self.delegate setLunchingBubbleView];
            [self.physicalEngine triggleSpecialBubbles];
            if ([self.physicalEngine hasConnectedBubbleOfSameColor]) {
                self.removeViews = [self.physicalEngine getRemoveBubbleViews];
                self.removeTimer = [NSTimer scheduledTimerWithTimeInterval:GAME_LOOP_TIME_INTERVAL target:self selector: @selector(removeAnimation) userInfo:nil repeats:YES];
            }
            NSArray *disconnectedViews = [self.physicalEngine removeBubbleDisconnected];
            [self disConnectedAnimation:disconnectedViews];
            if ([self gameWon]) {
                [self.delegate showGameWonView];
            }
            [self.delegate setScoreValue];
        }
    }else if([self.physicalEngine touchCeil]){
        [self.lunchTimer invalidate];
        self.lunchTimer = nil;
        [self.delegate setLunchingBubbleView];
        
    }else if([self.physicalEngine touchBoundary] ){
        [self.physicalEngine changeLunchDirection];
        [self.delegate updateView:self.currentBubble.view];
    }
}

-(void) removeAnimation
{
    UIView *removeView;
    for(int i = 0; i< [self.removeViews count];i++){
        removeView = [self.removeViews objectAtIndex:i];
        removeView.alpha = removeView.alpha- ALPHA_DECREMENT;
        CGRect newFrame =  removeView.frame;
        newFrame.size.width += SIZE_INCREMENT;
        newFrame.size.height += SIZE_INCREMENT;
        CGPoint tempCenter = removeView.center;
        removeView.frame = newFrame;
        removeView.center = tempCenter;
        [self.delegate updateView:removeView];
        if(removeView.alpha <= 0){
            [removeView removeFromSuperview];
            [self.removeTimer invalidate];
        }
    }
}

- (void) disConnectedAnimation:(NSArray *)views
{
    UIView *disconnectedView;
    for(disconnectedView in views){
        [self.delegate addView:disconnectedView];
        [UIView animateWithDuration: ANIMATION_TIME_INTERVAL animations:^{
            disconnectedView.center = CGPointMake(disconnectedView.center.x, 1024+32);
        }];
        [NSTimer scheduledTimerWithTimeInterval:ANIMATION_TIME_INTERVAL target:self selector:@selector(removeView:) userInfo:disconnectedView repeats:NO];
    }
}

//private
-  (void)removeView:(NSTimer *)timer
{
    UIView *disconnectedView = [timer userInfo];
    [self.delegate removeView:disconnectedView];
    //remove to render
}

- (BOOL) gameFailed
{
    return self.currentBubble.view.center.y > BOTTOM_BOUNDARY ? YES : NO;
}

- (BOOL) gameWon
{
    return [self.bubbleCollection isEmpty];
}

@end
