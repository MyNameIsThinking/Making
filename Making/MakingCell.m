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
#import "FitHelper.h"

@interface MakingCell () {

    CGSize size;
}

@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, retain) UIView *cellView;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIView *forewordView;
@property (nonatomic, retain) M80AttributedLabel *mainLabel;
@property (nonatomic, retain) M80AttributedLabel *forewordLabel;
@property (nonatomic, retain) UIButton *photoBtn;
@property (nonatomic, retain) UIImageView *checkImageView;
@property (nonatomic, retain) UIImageView *cellBackGroundImageView;

@end
@implementation MakingCell

+ (NSString *)identifier {
    return @"MakingCell";
}
+ (CGSize)getCellSize {
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
}
- (void)dealloc {
    self.cellImage = nil;
    self.model = nil;
    self.cellImageView = nil;
    self.cellView = nil;
    self.mainView = nil;
    self.forewordView = nil;
    self.mainLabel = nil;
    self.forewordLabel = nil;
}
- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        size = [MakingCell getCellSize];
    }
    
    return self;
}
- (void)layoutSubviews {

    [super layoutSubviews];
    self.photoBtn.hidden = !_isShowPhoto;
    self.checkImageView.hidden = !_isShowCheck;
}
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName withBackgroundImage:(UIImage *)image {
    
    [_mainLabel removeFromSuperview];
    _mainLabel = nil;
    [_forewordLabel removeFromSuperview];
    _forewordLabel = nil;
    
    [_cellBackGroundImageView removeFromSuperview];
    _cellBackGroundImageView = nil;
    
    _model = [[CoreTextModel alloc] initWithModel:model];
    _model.BGImage = image;
    if (_model.BGImage) {
        [self.cellView addSubview:self.cellBackGroundImageView];
        self.cellBackGroundImageView.image = _model.BGImage;
    }
    
    [self.cellView addSubview:self.mainView];
    [self.cellView addSubview:self.forewordView];
    
    
    
    self.mainLabel.textAlignment = model.textAlignment;
    self.mainLabel.text = model.text;
    self.fontName = fontName?fontName:model.fontName;
    self.mainLabel.font = [UIFont fontWithName:self.fontName size:26];
    self.mainLabel.textColor = [UIColor grayColor];
    self.mainLabel.frame = CGRectInset(self.mainView.bounds,10,10);
    [self.mainView addSubview:self.mainLabel];
    
    self.forewordLabel.textAlignment = model.forewordAlignment;
    self.forewordLabel.text = model.forewordText;
    self.forewordFontName = fontName?fontName:model.forewordFontName;
    self.forewordLabel.font = [UIFont fontWithName:self.fontName size:12];
    self.forewordLabel.textColor = [UIColor grayColor];
    self.forewordLabel.frame = CGRectInset(self.forewordView.bounds,10,10);
    [self.forewordView addSubview:self.forewordLabel];
    
    _cellImage = [self getImageFromView];
    self.cellImageView.image = _cellImage;
    [self addSubview:self.cellImageView];
    
    [self addSubview:self.photoBtn];
    [self addSubview:self.checkImageView];
}
- (void)openImagePicker:(UIButton *)sender {
    NSLog(@"openImagePicker");
}
- (UIImageView *)cellImageView {

    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    return _cellImageView;
}
- (UIView *)cellView {

    if (!_cellView) {
        _cellView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    
    return _cellView;
}
- (UIView *)mainView {

    if (!_mainView) {
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-(100))];
        _mainView.backgroundColor = [UIColor clearColor];
    }
    
    return _mainView;
}
- (UIView *)forewordView {
    
    if (!_forewordView) {
        
        _forewordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height, size.width, size.height-self.mainView.frame.size.height)];
        _forewordView.backgroundColor = [UIColor clearColor];
    }
    
    return _forewordView;
}
- (M80AttributedLabel *)mainLabel {

    if (!_mainLabel) {
        _mainLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _mainLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _mainLabel;
}
- (M80AttributedLabel *)forewordLabel {
    
    if (!_forewordLabel) {
        _forewordLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _forewordLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _forewordLabel;
}
- (void)openImagePicker {

    if ([_cellDelegate respondsToSelector:@selector(openImagePicker)]) {
        [_cellDelegate openImagePicker];
    }
}
- (UIButton *)photoBtn {

    if (!_photoBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-image-edit"];
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake([FitHelper fitWidth:10], CGRectGetHeight(self.frame)-image.size.height-[FitHelper fitWidth:10], image.size.width, image.size.height);
        [_photoBtn setImage:image forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(openImagePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photoBtn;
}
- (UIImageView *)cellBackGroundImageView {

    if (!_cellBackGroundImageView) {
        _cellBackGroundImageView = [[UIImageView alloc] initWithFrame:self.cellView.bounds];
        _cellBackGroundImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _cellBackGroundImageView;
}
- (UIImage *)getImageFromView {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.cellView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImageView *)checkImageView {
    
    if (!_checkImageView) {
        UIImage *image = [UIImage imageNamed:@"icon-chk-solid"];
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-image.size.width-[FitHelper fitWidth:10], CGRectGetHeight(self.frame)-image.size.height-[FitHelper fitWidth:10], image.size.width, image.size.height)];
        _checkImageView.image = image;
        
    }
    
    return _checkImageView;
}

@end
