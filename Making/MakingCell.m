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
@property (nonatomic, retain) UILabel *forewordLabel;
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
        self.isShowPhoto = 0;
        self.isShowCheck = NO;
    }
    
    return self;
}
- (void)layoutSubviews {

    [super layoutSubviews];
    self.photoBtn.hidden = _isShowPhoto==0;
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
    UIFont *mainFont = nil;
    if ([self.fontName isEqualToString:@"SFUIDisplay-Bold"]) {
        mainFont = [UIFont systemFontOfSize:model.fontSize];
    } else {
        mainFont = [UIFont fontWithName:self.fontName size:model.fontSize];
    }
    self.mainLabel.font = mainFont;
    self.mainLabel.textColor = [UIColor whiteColor];
    self.mainLabel.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.mainLabel];
    
    self.forewordLabel.text = model.forewordText;
    self.forewordLabel.textAlignment = kCTTextAlignmentLeft;
    self.forewordFontName = fontName?fontName:model.forewordFontName;
    UIFont *forewordFont = nil;
    if ([self.forewordFontName isEqualToString:@"SFUIDisplay-Bold"]) {
        forewordFont = [UIFont systemFontOfSize:model.forewordFontSize];
    } else {
        forewordFont = [UIFont fontWithName:self.forewordFontName size:model.forewordFontSize];
    }
    self.forewordLabel.font = forewordFont;
    self.forewordLabel.textColor = [UIColor whiteColor];
    self.forewordLabel.backgroundColor = [UIColor clearColor];
    [self.forewordView addSubview:self.forewordLabel];
    
    CGPoint mainOrigin = CGPointZero;
    CGPoint forewordOrigin = CGPointZero;
    if (_model.forewordPosition==0) {
        mainOrigin = CGPointMake([FitHelper fitWidth:25], size.height - CGRectGetHeight(self.mainView.frame)-[FitHelper fitHeight:25]);
        forewordOrigin = CGPointMake([FitHelper fitWidth:25], [FitHelper fitHeight:25]);
    } else {
        mainOrigin = CGPointMake([FitHelper fitWidth:25], [FitHelper fitHeight:25]);
        forewordOrigin = CGPointMake([FitHelper fitWidth:25], size.height - CGRectGetHeight(self.forewordView.frame)-[FitHelper fitHeight:25]);
    }
    self.mainView.frame = CGRectMake(mainOrigin.x, mainOrigin.y, CGRectGetWidth(self.mainView.frame), CGRectGetHeight(self.mainView.frame));
    self.forewordView.frame = CGRectMake(forewordOrigin.x, forewordOrigin.y, CGRectGetWidth(self.forewordView.frame), CGRectGetHeight(self.forewordView.frame));
    
    CGSize mainLabelSize = [model.text sizeWithAttributes:@{NSFontAttributeName:mainFont}];
    CGSize forewordSize = [model.forewordText sizeWithAttributes:@{NSFontAttributeName:forewordFont}];
    CGSize mainViewSize = CGSizeMake(CGRectGetWidth(_mainView.frame), CGRectGetHeight(_mainView.frame));
    CGSize forewordViewSize = CGSizeMake(CGRectGetWidth(_forewordView.frame), CGRectGetHeight(_forewordView.frame));
    switch (_model.mainPosition) {
        case 0: {
            self.mainLabel.frame = CGRectMake(0, 0, mainLabelSize.width, mainLabelSize.height);
            self.mainLabel.center = CGPointMake(CGRectGetWidth(self.mainView.frame)*.5f, CGRectGetHeight(self.mainView.frame)*.5f);
        }
            break;
        case 1: {
            self.mainLabel.frame = CGRectMake(0, 0, mainLabelSize.width, mainLabelSize.height);
        }
            break;
        case 2: {
            self.mainLabel.frame = CGRectMake(mainViewSize.width-mainLabelSize.width, 0, mainLabelSize.width, mainLabelSize.height);
        }
            break;
        case 3: {
            self.mainLabel.frame = CGRectMake(0, mainViewSize.height-mainLabelSize.height, mainLabelSize.width, mainLabelSize.height);
        }
            break;
        case 4: {
            self.mainLabel.frame = CGRectMake(mainViewSize.width-mainLabelSize.width, mainViewSize.height-mainLabelSize.height, mainLabelSize.width, mainLabelSize.height);
        }
            break;
            
        default:
            break;
    }
    switch (_model.forewordAlignment) {
        case 0: {
            self.forewordLabel.frame = CGRectMake(0, 0, forewordSize.width, forewordSize.height);
            self.forewordLabel.center = CGPointMake(self.forewordLabel.center.x, CGRectGetHeight(self.forewordView.frame)*.5f);
        }
            break;
        case 1: {
            self.forewordLabel.frame = CGRectMake(forewordViewSize.width-forewordSize.width, 0, forewordSize.width, forewordSize.height);
            self.forewordLabel.center = CGPointMake(self.forewordLabel.center.x, CGRectGetHeight(self.forewordView.frame)*.5f);
        }
            break;
        case 2: {
            self.forewordLabel.frame = CGRectMake(0, 0, forewordSize.width, forewordSize.height);
            self.forewordLabel.center = CGPointMake(CGRectGetWidth(self.forewordView.frame)*.5f, CGRectGetHeight(self.forewordView.frame)*.5f);
        }
            break;
            
        default:
            break;
    }
    
    _cellImage = [self getImageFromView];
    self.cellImageView.image = _cellImage;
    [self addSubview:self.cellImageView];
    
    [self addSubview:self.photoBtn];
    [self addSubview:self.checkImageView];
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
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width-(2*[FitHelper fitWidth:25]), size.height-CGRectGetHeight(self.forewordView.frame)-(2*[FitHelper fitHeight:25]))];
        _mainView.backgroundColor = [UIColor clearColor];
    }
    
    return _mainView;
}
- (UIView *)forewordView {
    
    if (!_forewordView) {
        NSString *text = _model.forewordText;
        UIFont *font = [UIFont fontWithName:self.fontName size:_model.forewordFontSize];
        CGSize fontSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
        _forewordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width-(2*[FitHelper fitWidth:25]), fontSize.height + [FitHelper fitHeight:25])];
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
- (UILabel *)forewordLabel {
    
    if (!_forewordLabel) {
        _forewordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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

    UIImage *image = [UIImage imageNamed:@"btn-image-edit"];
    
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:image forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(openImagePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    _photoBtn.frame = CGRectMake([FitHelper fitWidth:_isShowPhoto==1?10:15], CGRectGetHeight(self.frame)-image.size.height-[FitHelper fitWidth:_isShowPhoto==1?10:15], image.size.width, image.size.height);
    return _photoBtn;
}
- (UIImageView *)cellBackGroundImageView {

    if (!_cellBackGroundImageView) {
        _cellBackGroundImageView = [[UIImageView alloc] initWithFrame:self.cellView.bounds];
        _cellBackGroundImageView.backgroundColor = [UIColor clearColor];
        _cellBackGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
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
