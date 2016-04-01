//
//  EditTextViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "EditTextViewController.h"

@interface EditTextViewController () <UITextViewDelegate>
@property (nonatomic, retain) UITextView *mainTextView;
@property (nonatomic, retain) UITextView *forewordTextView;
@property (nonatomic, retain) UIButton *doneBtn;
@property (nonatomic, retain) UIButton *returnBtn;
@property (nonatomic, retain) UIButton *copyedBtn;
@end

@implementation EditTextViewController
- (void)dealloc {
    self.mainTextView = nil;
    self.forewordTextView = nil;
}
- (id)init {

    self = [super init];
    if (self) {
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
    [self.view addSubview:self.forewordTextView];
    [self.mainTextView becomeFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if ([self.mainTextView isFirstResponder]) {
            [self.forewordTextView becomeFirstResponder];
        } else if ([self.forewordTextView isFirstResponder]) {
            [self.mainTextView becomeFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    self.copyedBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.copyedBtn.frame))/2, CGRectGetHeight(self.view.bounds)-size.height-CGRectGetHeight(self.copyedBtn.frame), CGRectGetWidth(self.copyedBtn.frame), CGRectGetHeight(self.copyedBtn.frame));
    self.returnBtn.center = CGPointMake(CGRectGetWidth(self.returnBtn.frame)*1.5, self.copyedBtn.center.y);
    self.doneBtn.center = CGPointMake(CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.returnBtn.frame)*1.5, self.copyedBtn.center.y);
    
    self.forewordTextView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, self.copyedBtn.center.y-(CGRectGetHeight(self.copyedBtn.frame)/2)-(CGRectGetHeight(self.forewordTextView.frame)/2));
    
    self.mainTextView.frame = CGRectMake(0, 0, size.width, self.forewordTextView.frame.origin.y);
    
}
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)goBack:(UIButton *)sender {

    if ([sender isEqual:_doneBtn]) {
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
        _mainTextView.backgroundColor = [UIColor yellowColor];
        _mainTextView.returnKeyType = UIReturnKeyNext;
    }
    
    return _mainTextView;
}
- (UITextView *)forewordTextView {

    if (!_forewordTextView) {
        CGFloat height = 60;
        _forewordTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -height, CGRectGetWidth(self.view.bounds), height)];
        _forewordTextView.delegate = self;
        _forewordTextView.backgroundColor = [UIColor redColor];
        _forewordTextView.returnKeyType = UIReturnKeyNext;
    }
    
    return _forewordTextView;
}
- (UIButton *)doneBtn {

    if (!_doneBtn) {
        CGFloat width = 30;
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(0, -width, width, width);
        [_doneBtn setTitle:@"完" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneBtn;
}
- (UIButton *)returnBtn {

    if (!_returnBtn) {
        CGFloat width = 30;
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(0, -width, width, width);
        [_returnBtn setTitle:@"返" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _returnBtn;
}
- (UIButton *)copyedBtn {

    if (!_copyedBtn) {
        CGFloat width = 30;
        _copyedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyedBtn.frame = CGRectMake(0, -width, width, width);
        [_copyedBtn setTitle:@"拷" forState:UIControlStateNormal];
        [_copyedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _copyedBtn;
}
@end
