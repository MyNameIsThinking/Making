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
- (void)initialize {

    [self.layer addSublayer:self.makingLayer];
}
- (MakingLayer *)makingLayer {

    if (!_makingLayer) {
        _makingLayer = [[MakingLayer alloc] init];
        _makingLayer.frame = self.bounds;
        _makingLayer.backgroundColor = [UIColor redColor].CGColor;
    }
    
    return _makingLayer;
}
@end
