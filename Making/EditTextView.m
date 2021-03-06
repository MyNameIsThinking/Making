//
//  EditTextViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "EditTextView.h"
#import "FitHelper.h"

@interface EditTextView () <UITextViewDelegate>
@property (nonatomic, retain) CoreTextModel *model;
@property (nonatomic, retain) UITextView *mainTextView;
@property (nonatomic, retain) NSDictionary *mainAttributes;
@property (nonatomic, retain) UITextView *forewordTextView;
@property (nonatomic, retain) UIButton *doneBtn;
@property (nonatomic, retain) UIButton *returnBtn;
@property (nonatomic, retain) UIButton *copyedBtn;
@property (nonatomic, retain) UILabel *fromLabel;
@property (nonatomic, retain) UIToolbar *toolbar;
@end

@implementation EditTextView
- (void)dealloc {
    _model = nil;
    _mainTextView = nil;
    _mainAttributes = nil;
    _forewordTextView = nil;
    _doneBtn = nil;
    _returnBtn = nil;
    _copyedBtn = nil;
    _fromLabel = nil;
    _toolbar = nil;
}
- (id)initWithModel:(CoreTextModel *)model {

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _model = model;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self addSubview:self.toolbar];
        [self addSubview:self.copyedBtn];
        [self addSubview:self.doneBtn];
        [self addSubview:self.returnBtn];
        [self addSubview:self.mainTextView];
        [self addSubview:self.fromLabel];
        [self addSubview:self.forewordTextView];
        [self.mainTextView becomeFirstResponder];
    }
    return self;
}
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    CGFloat width = [FitHelper fitWidth:15];
    self.copyedBtn.frame = CGRectMake((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.copyedBtn.frame))/2, CGRectGetHeight(self.bounds)-size.height-CGRectGetHeight(self.copyedBtn.frame)-[FitHelper fitHeight:15], CGRectGetWidth(self.copyedBtn.frame), CGRectGetHeight(self.copyedBtn.frame));
    self.returnBtn.center = CGPointMake(width+CGRectGetWidth(self.returnBtn.frame)/2, self.copyedBtn.center.y);
    self.doneBtn.center = CGPointMake(CGRectGetWidth(self.bounds)-self.returnBtn.center.x, self.copyedBtn.center.y);
    
    CGSize labelSize1 = [_forewordTextView.text sizeWithAttributes:@{NSFontAttributeName:_forewordTextView.font}];
    _forewordTextView.frame = CGRectMake(width, 0, labelSize1.width+50, labelSize1.height+20);
    
    self.forewordTextView.center = CGPointMake(_forewordTextView.center.x, self.copyedBtn.center.y-(CGRectGetHeight(self.copyedBtn.frame)/2)-(CGRectGetHeight(self.forewordTextView.frame)/2));
    
    CGSize labelSize2 = [_fromLabel.text sizeWithAttributes:@{NSFontAttributeName:_fromLabel.font}];
    _fromLabel.frame = CGRectMake(width+4, _forewordTextView.frame.origin.y-labelSize2.height, labelSize2.width, labelSize2.height);
    
    
    self.mainTextView.frame = CGRectMake(width, [FitHelper fitHeight:15], size.width-(2*width), _fromLabel.frame.origin.y-20);
    
}
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)goBack:(UIButton *)sender {
    if ([sender isEqual:_doneBtn]) {
        NSRange rang = NSMakeRange(_mainTextView.text.length-1, 1);
        NSString *rangText = [_mainTextView.text substringWithRange:rang];
        _model.text = [rangText isEqualToString:@"\n"]?_mainTextView.text:[NSString stringWithFormat:@"%@%@",_mainTextView.text,@"\n"];
        _model.forewordText = _forewordTextView.text;
    } else if ([sender isEqual:_returnBtn]) {
    }
    [self.mainTextView resignFirstResponder];
    [self.forewordTextView resignFirstResponder];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isEqual:_mainTextView]) {
        _copyedBtn.hidden = textView.text.length==0;
    }
}
- (UITextView *)mainTextView {
    if (!_mainTextView) {
        _mainTextView = [[UITextView alloc] init];
        _mainTextView.delegate = self;
        _mainTextView.textAlignment = NSTextAlignmentLeft;
        _mainTextView.attributedText = [[NSAttributedString alloc] initWithString:_model.text attributes:self.mainAttributes];
        _mainTextView.backgroundColor = [UIColor clearColor];
        _mainTextView.returnKeyType = UIReturnKeyNext;
    }
    return _mainTextView;
}
- (NSDictionary *)mainAttributes {

    if (!_mainAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 12;
        _mainAttributes = @{
                            NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:17.f],
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
    }
    
    return _mainAttributes;
}
- (UITextView *)forewordTextView {

    if (!_forewordTextView) {
        _forewordTextView = [[UITextView alloc] init];
        _forewordTextView.delegate = self;
        _forewordTextView.backgroundColor = [UIColor clearColor];
        _forewordTextView.textAlignment = NSTextAlignmentLeft;
        _forewordTextView.attributedText = [[NSAttributedString alloc] initWithString:_model.forewordText attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:17.f],}];
        _forewordTextView.returnKeyType = UIReturnKeyNext;
    }
    
    return _forewordTextView;
}
- (UIButton *)doneBtn {

    if (!_doneBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-confirm-small"];
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setImage:image forState:UIControlStateNormal];
        _doneBtn.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-image.size.height-10.f, image.size.width, image.size.height);
        self.doneBtn.center = CGPointMake(CGRectGetWidth(self.bounds)-self.returnBtn.center.x, self.copyedBtn.center.y);
        [_doneBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneBtn;
}
- (UIButton *)returnBtn {

    if (!_returnBtn) {
        CGFloat width = [FitHelper fitWidth:15];
        UIImage *image = [UIImage imageNamed:@"btn-cancel-small"];
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:image forState:UIControlStateNormal];
        _returnBtn.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-image.size.height-10.f, image.size.width, image.size.height);
        self.returnBtn.center = CGPointMake(width+CGRectGetWidth(self.returnBtn.frame)/2, self.copyedBtn.center.y);
        [_returnBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _returnBtn;
}
- (UIButton *)copyedBtn {
    if (!_copyedBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-paste"];
        _copyedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyedBtn setImage:image forState:UIControlStateNormal];
        _copyedBtn.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-image.size.height-10.f, image.size.width, image.size.height);
        _copyedBtn.center = CGPointMake(CGRectGetWidth(self.frame)*.5f, _copyedBtn.center.y);
    }
    return _copyedBtn;
}
- (UILabel *)fromLabel {

    if (!_fromLabel) {
        NSString *text = @"来自:";
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.text = text;
        _fromLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17.f];
        _fromLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _fromLabel;
}
- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _toolbar.backgroundColor = [UIColor clearColor];
    }
    return _toolbar;
}
@end
