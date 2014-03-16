//
//  UIImage+Color.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor*)color;
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
