//
//  EditTextViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "EditTextViewController.h"
#import "FitHelper.h"

@interface EditTextViewController () <UITextViewDelegate>
@property (nonatomic, retain) CoreTextModel *model;
@property (nonatomic, retain) UITextView *mainTextView;
@property (nonatomic, retain) NSDictionary *mainAttributes;
@property (nonatomic, retain) UITextView *forewordTextView;
@property (nonatomic, retain) UIButton *doneBtn;
@property (nonatomic, retain) UIButton *returnBtn;
@property (nonatomic, retain) UIButton *copyedBtn;
@property (nonatomic, retain) UILabel *fromLabel;
@end

@implementation EditTextViewController
- (void)dealloc {
    _model = nil;
    _mainTextView = nil;
    _mainAttributes = nil;
    _forewordTextView = nil;
    _doneBtn = nil;
    _returnBtn = nil;
    _copyedBtn = nil;
    _fromLabel = nil;
}
- (id)initWithModel:(CoreTextModel *)model {

    self = [super init];
    if (self) {
        _model = model;
        self.view.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.copyedBtn];
    [self.view addSubview:self.doneBtn];
    [self.view addSubview:self.returnBtn];
    [self.view addSubview:self.mainTextView];
    [self.view addSubview:self.fromLabel];
    [self.view addSubview:self.forewordTextView];
    [self.mainTextView becomeFirstResponder];
}
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    CGFloat width = [FitHelper fitWidth:15];
    
    self.copyedBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.copyedBtn.frame))/2, CGRectGetHeight(self.view.bounds)-size.height-CGRectGetHeight(self.copyedBtn.frame)-[FitHelper fitHeight:15], CGRectGetWidth(self.copyedBtn.frame), CGRectGetHeight(self.copyedBtn.frame));
    self.returnBtn.center = CGPointMake(width+CGRectGetWidth(self.returnBtn.frame)/2, self.copyedBtn.center.y);
    self.doneBtn.center = CGPointMake(CGRectGetWidth(self.view.bounds)-self.returnBtn.center.x, self.copyedBtn.center.y);
    
    CGSize labelSize1 = [_forewordTextView.text sizeWithAttributes:@{NSFontAttributeName:_forewordTextView.font}];
    _forewordTextView.frame = CGRectMake(width, 0, labelSize1.width+50, labelSize1.height+20);
    
    self.forewordTextView.center = CGPointMake(_forewordTextView.center.x, self.copyedBtn.center.y-(CGRectGetHeight(self.copyedBtn.frame)/2)-(CGRectGetHeight(self.forewordTextView.frame)/2)-50);
    
    CGSize labelSize2 = [_fromLabel.text sizeWithAttributes:@{NSFontAttributeName:_fromLabel.font}];
    _fromLabel.frame = CGRectMake(width+4, _forewordTextView.frame.origin.y-labelSize2.height, labelSize2.width, labelSize2.height);
    
    
    self.mainTextView.frame = CGRectMake(width, [FitHelper fitHeight:15], size.width-(2*width), _fromLabel.frame.origin.y-20);
    
}
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)goBack:(UIButton *)sender {

    if ([sender isEqual:_doneBtn]) {
        NSRange rang = NSMakeRange(_mainTextView.text.length-1, 1);
        NSString *rangText = [_mainTextView.text substringWithRange:rang];
        _model.text = [rangText isEqualToString:@"\n"]?_mainTextView.text:[NSString stringWithFormat:@"%@%@",_mainTextView.text,@"\n"];
        _model.forewordText = _forewordTextView.text;
        NSLog(@"保存");
    } else if ([sender isEqual:_returnBtn]) {
        NSLog(@"放棄");
    }
    [self.mainTextView resignFirstResponder];
    [self.forewordTextView resignFirstResponder];
}
- (UITextView *)mainTextView {

    if (!_mainTextView) {
        
        _mainTextView = [[UITextView alloc] init];
        _mainTextView.delegate = self;
        _mainTextView.textAlignment = NSTextAlignmentLeft;
        _mainTextView.attributedText = [[NSAttributedString alloc] initWithString:_model.text attributes:self.mainAttributes];
        _mainTextView.backgroundColor = [UIColor whiteColor];
        _mainTextView.returnKeyType = UIReturnKeyNext;
    }
    
    return _mainTextView;
}
- (NSDictionary *)mainAttributes {

    if (!_mainAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 12;
        _mainAttributes = @{
                            NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:8.5f],
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
    }
    
    return _mainAttributes;
}
- (UITextView *)forewordTextView {

    if (!_forewordTextView) {
        _forewordTextView = [[UITextView alloc] init];
        _forewordTextView.delegate = self;
        _forewordTextView.textAlignment = NSTextAlignmentLeft;
        _forewordTextView.attributedText = [[NSAttributedString alloc] initWithString:_model.forewordText attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:8.5f],}];
        _forewordTextView.returnKeyType = UIReturnKeyNext;
    }
    
    return _forewordTextView;
}
- (UIButton *)doneBtn {

    if (!_doneBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-confirm-small"];
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setImage:image forState:UIControlStateNormal];
        _doneBtn.frame = CGRectMake(0, -10, image.size.width, image.size.height);
        [_doneBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneBtn;
}
- (UIButton *)returnBtn {

    if (!_returnBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-cancel-small"];
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:image forState:UIControlStateNormal];
        _returnBtn.frame = CGRectMake(0, -10, image.size.width, image.size.height);
        [_returnBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _returnBtn;
}
- (UIButton *)copyedBtn {

    if (!_copyedBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-paste"];
        _copyedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyedBtn setImage:image forState:UIControlStateNormal];
        _copyedBtn.frame = CGRectMake(0, -10, image.size.width, image.size.height);
    }
    
    return _copyedBtn;
}
- (UILabel *)fromLabel {

    if (!_fromLabel) {
        NSString *text = @"來自:";
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.text = text;
        _fromLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:8.5f];
    }
    
    return _fromLabel;
}
@end
