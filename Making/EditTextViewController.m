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
    [self.view addSubview:self.mainTextView];
    [self.mainTextView becomeFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.mainTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.mainTextView.frame = CGRectMake(0, 0, size.width, CGRectGetHeight(self.view.bounds)-size.height);
}
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (UITextView *)mainTextView {

    if (!_mainTextView) {
        
        _mainTextView = [[UITextView alloc] init];
        _mainTextView.delegate = self;
        _mainTextView.backgroundColor = [UIColor yellowColor];
        _mainTextView.returnKeyType = UIReturnKeyDone;
    }
    
    return _mainTextView;
}

@end
