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
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIView *forewordView;
@property (nonatomic, retain) M80AttributedLabel *label;
@property (nonatomic, retain) M80AttributedLabel *forewordLabel;
@end
@implementation MakingCell

+ (NSString *)identifier {
    return @"MakingCell";
}
- (void)dealloc {
    self.model = nil;
    self.label = nil;
    self.forewordLabel = nil;
}
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName {
    
    [_label removeFromSuperview];
    _label = nil;
    [_forewordLabel removeFromSuperview];
    _forewordLabel = nil;
    
    [self addSubview:self.mainView];
    [self addSubview:self.forewordView];
    
    _model = model;
    self.label.textAlignment = model.textAlignment;
    self.label.text = model.text;
    self.fontName = fontName?fontName:model.fontName;
    self.label.font = [UIFont fontWithName:self.fontName size:26/_scale];
    self.label.textColor = [UIColor grayColor];
    self.label.frame = CGRectInset(self.mainView.bounds,10,10);
    [self.mainView addSubview:self.label];
    
    self.forewordLabel.textAlignment = model.forewordAlignment;
    self.forewordLabel.text = model.forewordText;
    self.fontName = fontName?fontName:model.forewordFontName;
    self.forewordLabel.font = [UIFont fontWithName:self.fontName size:12/_scale];
    self.forewordLabel.textColor = [UIColor grayColor];
    self.forewordLabel.frame = CGRectInset(self.forewordView.bounds,10,10);
    [self.forewordView addSubview:self.forewordLabel];
}
- (UIView *)mainView {

    if (!_mainView) {
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-(100/_scale))];
        _mainView.backgroundColor = [UIColor redColor];
    }
    
    return _mainView;
}
- (UIView *)forewordView {
    
    if (!_forewordView) {
        
        _forewordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height, self.bounds.size.width, self.bounds.size.height-self.mainView.frame.size.height)];
        _forewordView.backgroundColor = [UIColor greenColor];
    }
    
    return _forewordView;
}
- (M80AttributedLabel *)label {

    if (!_label) {
        _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
    }
    
    return _label;
}
- (M80AttributedLabel *)forewordLabel {
    
    if (!_forewordLabel) {
        _forewordLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _forewordLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _forewordLabel;
}
- (UIImage *)getImageFromView {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
