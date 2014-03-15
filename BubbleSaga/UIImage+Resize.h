//
//  UIImage+Resize.h
//  ps5
//
//  Created by tangyixuan on 22/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+(UIImage *)imageWithImage: (UIImage *)image scaledToSize:(CGSize) newSize;

@end
