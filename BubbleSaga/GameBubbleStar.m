//
//  GameBubbleStar.m
//  BubbleSaga
//
//  Created by tangyixuan on 1/3/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameBubbleStar.h"

@interface GameBubbleStar ()

@end

@implementation GameBubbleStar

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>) delegate{
    
    self = [super initGeneral];
    if (self) {
        self.bubbleType = BUBBLE_STAR;
        self.delegate = delegate;
        [self initView];
    }
    return self;
}

- (void) initView{
    UIImage *bubbleImage = [UIImage imageNamed:@"bubble-star.png"];
    CGSize bubbleViewSize;
    bubbleViewSize.width = bubbleViewSize.height = BUBBLEDIAMETER;
    UIImage *newSizedBubbleImage = [UIImage imageWithImage:bubbleImage scaledToSize:bubbleViewSize];
    self.view = [[UIImageView alloc]initWithImage:newSizedBubbleImage];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.bubbleType = BUBBLE_STAR;
        [self initView];
    }
    return self;
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
