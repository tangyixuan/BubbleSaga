//
//  UIImage+Resize.m
//  ps5
//
//  Created by tangyixuan on 22/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+(UIImage *)imageWithImage: (UIImage *)image scaledToSize:(CGSize) newSize{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

@end
