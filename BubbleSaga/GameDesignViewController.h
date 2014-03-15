//
//  GameDesignViewController.h
//  BubbleSaga
//
//  Created by tangyixuan on 28/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileListViewController.h"
#import "GamePlayViewController.h"
#import "LoadViewDelegate.h"
#import "GameBubbleViewUpdateDelegate.h"

@interface GameDesignViewController : UIViewController <GameBubbleViewUpdateDelegate, LoadViewDelegate>

@end
