//
//  GameBubbleBasic.m
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameBubbleBasic.h"

@interface GameBubbleBasic ()

@end

@implementation GameBubbleBasic

- (id)initWithColor:(NSUInteger)color andDelegate:(id<GameBubbleViewUpdateDelegate>)delegate
{
    self = [super initGeneral];
    if(self){
        self.bubbleType = BUBBLE_BASIC;
        self.color = color;
        self.delegate = delegate;
        [self initView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.bubbleType = BUBBLE_BASIC;
        [self initView];
    }
    return self;
}

- (id)initRandomWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate
{
    return [self initWithColor:arc4random_uniform(NUM_COLOR) andDelegate:delegate];
}

- (id)initRandomWithTransparentWithDelegate:(id<GameBubbleViewUpdateDelegate>)delegate
{
    return [self initWithColor: arc4random_uniform(NUM_COLOR+1) andDelegate:delegate];
}

- (void) initView
{
    if(self.color == TRANSPARENT){
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BUBBLEDIAMETER, BUBBLEDIAMETER)];
        self.view.layer.cornerRadius = BUBBLERADIUS;
        self.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
    }else{
        UIImage *bubbleImage;
        switch (self.color) {
            case BLUE:
                bubbleImage = [UIImage imageNamed:@"bubble-blue.png"];
                break;
            case RED:
                bubbleImage = [UIImage imageNamed:@"bubble-red.png"];
                break;
            case GREEN:
                bubbleImage = [UIImage imageNamed:@"bubble-green.png"];
                break;
            case ORANGE:
                bubbleImage = [UIImage imageNamed:@"bubble-orange.png"];
                break;
            default:
                NSLog(@"Invalid Color");
        }
        
        CGSize bubbleViewSize;
        bubbleViewSize.width = bubbleViewSize.height = BUBBLEDIAMETER;
        UIImage *newSizedBubbleImage = [UIImage imageWithImage:bubbleImage scaledToSize:bubbleViewSize];
        self.view = [[UIImageView alloc]initWithImage:newSizedBubbleImage];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
