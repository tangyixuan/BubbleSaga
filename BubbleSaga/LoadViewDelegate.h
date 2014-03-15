//
//  LoadViewDelegate.h
//  BubbleSaga
//
//  Created by tangyixuan on 1/3/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadViewDelegate <NSObject>

-(void) loadCorrespondingViewOfRow:(int) row;

@end
