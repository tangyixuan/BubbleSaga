//
//  FileListViewController.h
//  BubbleSaga
//
//  Created by tangyixuan on 1/3/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadViewDelegate.h"
#import "ConstantVariables.h"

@interface FileListViewController : UITableViewController

@property (nonatomic) NSMutableArray *fileNames;
@property (nonatomic) NSUInteger fileCount;
@property (nonatomic,weak) id <LoadViewDelegate> delegate;

- (id) initWithDelegate:(id<LoadViewDelegate>) delegate;

- (void) updateView;

@end
