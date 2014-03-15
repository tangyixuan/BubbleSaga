//
//  ViewController.m
//  BubbleSaga
//
//  Created by tangyixuan on 24/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GamePlayViewController.h"

@interface GamePlayViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameArea;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *shotLimitLabel;
@property (nonatomic) int shotLimit;
@property (nonatomic) int scoreGained;
@property (nonatomic) int initBubbleNumber;

@property (nonatomic) GameEngine *engine;
@property (nonatomic) BubbleCollection *bubbleCollection;
@property (nonatomic) BubbleBuffer *bubbleBuffer;

@property (nonatomic) GameBubbleBasic *nextBubble;
@property (nonatomic) GameBubbleBasic *currentBubble;
@property (nonatomic) NSMutableArray *cannonImages;
@property (nonatomic) UIImageView *cannonView;

@property (nonatomic) BOOL tapAvailable;

@end

@implementation GamePlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    for(UIView *subview in [self.gameArea subviews]){
        [subview removeFromSuperview];
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:backgroundImage];
    CGFloat gameViewHeight = self.gameArea.frame.size.height;
    CGFloat gameViewWidth = self.gameArea.frame.size.width;
    backgroundView.frame = CGRectMake(0,0,gameViewWidth,gameViewHeight);
    [self.gameArea addSubview:backgroundView];
    self.tapAvailable = YES;
    
    self.bubbleCollection = [[BubbleCollection alloc] initWithDelegate:self];
    [self.bubbleCollection fillBubbleCollectionWithTransparentBubbles];
    if (self.passInData) {
        [self.bubbleCollection resetWithData:self.passInData];
    }
    
    self.bubbleBuffer = [[BubbleBuffer alloc] initWithDelegate:self];
    self.engine = [[GameEngine alloc]initWithBubbleCollection:self.bubbleCollection AndDelegate:self];
    
    [self setcannonBase];
    [self setcannon];
    
    self.shotLimit = SHOT_LIMIT;
    self.shotLimitLabel.textColor = [UIColor yellowColor];
    [self.gameArea addSubview:self.shotLimitLabel];
    self.shotLimitLabel.text = [NSString stringWithFormat:@"Shot Left: %d",self.shotLimit];
    
    self.scoreGained = 0;
    self.score.textColor = [UIColor yellowColor];
    [self.gameArea addSubview:self.score];
    self.score.text = [NSString stringWithFormat:@"Score: %d",self.scoreGained];
    self.initBubbleNumber = [self.bubbleCollection getBubbleNumber];
    
    [self setNextBubbleView];
    [self setLunchingBubbleView];
    
    UIView *bottomBoundary = [[UIView alloc]initWithFrame:CGRectMake(0, (BOTTOM_BOUNDARY+BUBBLERADIUS), SCREENWIDTH, 2)];
    bottomBoundary.backgroundColor = [UIColor redColor];
    [self.gameArea addSubview:bottomBoundary];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.gameArea addGestureRecognizer:tapGesture];
}

- (void) setcannonBase
{
    UIView *cannonBaseView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cannon-base.png"]];
    cannonBaseView.frame = CGRectMake(0, 0, CANNON_BASE_WIDTH, CANNON_BASE_HEIGHT);
    cannonBaseView.center = CGPointMake(SCREENWIDTH/2, SCREENLENGTH-BUBBLERADIUS);
    [self.gameArea addSubview:cannonBaseView];
    cannonBaseView.layer.zPosition = 3;
}

- (void) setcannon
{
    UIImage *cannonImage = [UIImage imageNamed:@"cannon.png"];
    [self splitImage:cannonImage into:CANNON_ROW_NUM and:CANNON_COLUMN_NUM];
    self.cannonView =   [[UIImageView alloc]initWithImage:[self.cannonImages objectAtIndex:0]];
    self.cannonView.frame = CGRectMake(0, 0, CANNON_WIDTH, CANNON_HEIGHT);
    self.cannonView.center = CGPointMake(SCREENWIDTH/2, SCREENLENGTH - CANNON_HEIGHT/3);
    self.cannonView.layer.anchorPoint = CGPointMake(0.5,1);
    
    [self.gameArea addSubview:self.cannonView];
    self.cannonView.layer.zPosition = 2;
}

- (void)setCannonImageOfIndex:(NSUInteger)index
{
    [self.cannonView setImage:[self.cannonImages objectAtIndex:index]];
}

-(void)splitImage: (UIImage*)image into:(NSUInteger)rowNum and:(NSUInteger) columnNum
{
    self.cannonImages = [[NSMutableArray alloc]init];
    CGFloat width  = image.size.width/columnNum;
    CGFloat height = image.size.height/rowNum;
    
    for (int row = 0; row < rowNum; row++) {
        for (int column = 0; column < columnNum; column++) {
            CGRect frame = CGRectMake(width*column, height*row, width, height);
            CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage,frame);
            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
            [self.cannonImages addObject:newImage];
            CFRelease(newImageRef);
        }
    }
}

- (void)setNextBubbleView
{
    self.nextBubble = [self.bubbleBuffer getNextBubble];
    [self setBubble:self.nextBubble AtIndex:2];
    [self setBubble:self.bubbleBuffer.secondBubble AtIndex:1];
    [self setBubble:self.bubbleBuffer.thirdBubble AtIndex:0];
}

-(void)setBubble:(GameBubbleBasic *)bubble AtIndex:(NSUInteger)index
{
    bubble.view.center = CGPointMake(index*BUBBLEDIAMETER-BUBBLERADIUS, SCREENLENGTH - BUBBLERADIUS);
    [self.gameArea addSubview:bubble.view];
    bubble.view.layer.zPosition = 4;
    [UIView animateWithDuration: ANIMATION_TIME_INTERVAL animations:^{
        bubble.view.center = CGPointMake(index*BUBBLEDIAMETER+BUBBLERADIUS, SCREENLENGTH - BUBBLERADIUS);
    }];
}

- (void)setLunchingBubbleView
{
    self.shotLimitLabel.text = [NSString stringWithFormat:@"Shot Left: %d",self.shotLimit];
    self.shotLimit--;
    self.initBubbleNumber = [self.bubbleCollection getBubbleNumber];
    
    if (self.shotLimit < 0) {
        [self showGameFailedView];
    }else{
        self.currentBubble = self.nextBubble;
        self.tapAvailable =false;
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            self.currentBubble.view.center = CGPointMake(SCREENWIDTH/2, SCREENLENGTH - BUBBLERADIUS);
        }];
        [NSTimer scheduledTimerWithTimeInterval:ANIMATION_TIME_INTERVAL target:self selector:@selector(enableTap) userInfo:nil repeats:NO];
        [self setNextBubbleView];
    }
}

-(void) enableTap
{
    self.tapAvailable = YES;
}

- (void)tapHandler:(UIGestureRecognizer *)gesture
{
    if(self.tapAvailable){
        CGPoint position = [gesture locationInView:gesture.view];
        [self.engine bubbleLunch: self.currentBubble withPosition: position andCannon:self.cannonView];
    }
}

//delegate function
- (void)updateView:(UIView *)view
{
    if ([view superview]) {
        [view removeFromSuperview];
    }
    view.layer.zPosition = 10;
    [self.gameArea addSubview:view];
}

//delegate function
- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
}

//delegate function
- (void)addView:(UIView *)view
{
    [self.gameArea addSubview:view];
}

//delegate function
- (void)showGameFailedView
{
    UIAlertView *gameFailedAlertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
    [gameFailedAlertView addButtonWithTitle:@"Exit"];
    gameFailedAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [gameFailedAlertView show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(int)buttonIndex
{
    if (buttonIndex == 0) {
        [self viewDidLoad];
    } else if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//delegate function
- (void)showGameWonView
{
    UIAlertView *gameWonAlertView = [[UIAlertView alloc] initWithTitle:@"You Win!" message:nil delegate:self cancelButtonTitle:@"Restart" otherButtonTitles:nil];
    gameWonAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [gameWonAlertView addButtonWithTitle:@"Exit"];
    [gameWonAlertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setScoreValue
{
    self.scoreGained += self.initBubbleNumber - [self.bubbleCollection getBubbleNumber];
    self.score.text = [NSString stringWithFormat:@"Score: %d",self.scoreGained];
}

- (id)createBubbleOfType:(NSUInteger)toolIndex{
    return nil;
}

@end
