//
//  UIImage+Round.m
//  MeiKeLaMei
//
//  Created by tztddong on 16/8/31.
//  Copyright © 2016年 gyk. All rights reserved.
//

#import "UIImage+Round.h"

@implementation UIImage (Round)

- (UIImage *)imageWithCornerRadius:(CGFloat)radius size:(CGSize)size{
    
    CGRect rect = (CGRect){0.f, 0.f, size};
    
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
