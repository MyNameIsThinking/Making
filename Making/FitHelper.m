//
//  FitHelper.m
//  Making
//
//  Created by rico on 2016/10/16.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "FitHelper.h"

@implementation FitHelper

+ (CGFloat)fitWidth:(CGFloat)width {
    CGFloat scale = width / 375;
    return [UIScreen mainScreen].bounds.size.width * scale;
}
+ (CGFloat)fitHeight:(CGFloat)height {
    CGFloat scale = height / 667;
    return [UIScreen mainScreen].bounds.size.height * scale;
}
@end
