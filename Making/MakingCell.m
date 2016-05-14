//
//  MakingCell.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MakingCell.h"
#import "CoreTextModel.h"
#import "M80AttributedLabel.h"

@interface MakingCell ()
@property (nonatomic, retain) M80AttributedLabel *label;
@end
@implementation MakingCell

+ (NSString *)identifier {
    return @"MakingCell";
}
- (void)dealloc {
    self.model = nil;
    self.label = nil;
}
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName {
    
    [_label removeFromSuperview];
    _label = nil;
    _model = model;
    self.label.textAlignment = model.textAlignment;
    self.label.text      = model.text;
    self.fontName = fontName?fontName:model.fontName;
    self.label.font      = [UIFont fontWithName:self.fontName size:26/_scale];
    self.label.textColor = [UIColor grayColor];
    self.label.frame     = CGRectInset(self.bounds,0,0);
    [self addSubview:self.label];
}
- (M80AttributedLabel *)label {

    if (!_label) {
        _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
    }
    
    return _label;
}
- (UIImage *)getImageFromView {
    
    CGSize size = CGSizeMake(500, 500);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
