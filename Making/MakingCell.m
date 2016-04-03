//
//  MakingCell.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MakingCell.h"

@interface MakingCell ()
@end
@implementation MakingCell

+ (NSString *)identifier {
    return @"MakingCell";
}
- (void)dealloc {
    self.makingLayer = nil;
}
- (void)showWithModels:(NSArray *)models {

    [self.layer addSublayer:self.makingLayer];
    self.makingLayer.models = models;
    self.makingLayer.isShadow = _isShadow;
    self.makingLayer.backgroundColor = _backgroundColor.CGColor;
    [self.makingLayer setNeedsDisplay];
}
- (MakingLayer *)makingLayer {

    if (!_makingLayer) {
        _makingLayer = [[MakingLayer alloc] init];
        _makingLayer.frame = self.bounds;
        _makingLayer.cornerRadius = 10.0;
        _makingLayer.masksToBounds = YES;
        _makingLayer.borderWidth = 2;
        _makingLayer.borderColor = [UIColor yellowColor].CGColor;
    }
    
    return _makingLayer;
}
@end
