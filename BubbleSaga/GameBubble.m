//
//  GameBubble.m
//  BubbleSaga
//
//  Created by tangyixuan on 18/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameBubble.h"

@implementation GameBubble

- (id)initWithDelegate:(id<GameBubbleViewUpdateDelegate>) delegate
{
    return nil;
}

- (id)initGeneral
{
    self = [super init];
    if (self) {
        self.color = INVALID_COLOR;
        self.row = 0;
        self.column = 0;
    }
    return self;
}

- (void) setRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    self.row = row;
    self.column = column;
    [self calculateViewCenter];
    [self.delegate updateView:self.view];
}

- (void) calculateViewCenter
{
    CGFloat y = BUBBLEDIAMETER * DISTANCE_RATIO_OF_DIAMETER * self.row + BUBBLERADIUS;
    CGFloat x = BUBBLEDIAMETER* self.column + BUBBLERADIUS;
    
    if(self.row % 2 == 1) {
        x += BUBBLERADIUS;
    }
    
    self.view.center = CGPointMake(x, y);
}

- (BOOL)isSpecialBubble
{
    //does not count indestructivle bubble in, since they can only be dropped
    if (self.bubbleType > NUM_COLOR && self.bubbleType < NUM_TOOL) {
        return YES;
    }else{
        return NO;
    }
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.row forKey:@"row"];
    [aCoder encodeInteger:self.column forKey:@"column"];
    [aCoder encodeInteger:self.color forKey:@"color"];
    [aCoder encodeObject:self.delegate forKey:@"delegate"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self){
        self.color = [aDecoder decodeIntegerForKey:@"color"];
        self.delegate = [aDecoder decodeObjectForKey:@"delegate"];
        self.row = [aDecoder decodeIntegerForKey:@"row"];
        self.column = [aDecoder decodeIntegerForKey:@"column"];
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
