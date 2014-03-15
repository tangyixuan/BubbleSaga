//
//  ViewController.h
//  BubbleSaga
//
//  Created by tangyixuan on 24/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEngine.h"

@interface GamePlayViewController : UIViewController<GameBubbleViewUpdateDelegate>

@property (nonatomic) NSData *passInData;

@end
