//
//  ViewController.m
//  Making
//
//  Created by rico on 2016/3/29.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "ChangeTypeViewController.h"
#import "EditTextViewController.h"
#import "ShareViewController.h"
#import "CountViewController.h"
#import "MakingCell.h"
#import "M80AttributedLabel.h"

const NSTimeInterval durationTime = 0.4;

@interface ViewController () <MainDelegate,ChangeTypeDelegate>

@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) ChangeTypeViewController *changeTypeViewController;
@property (nonatomic, retain) M80AttributedLabel *animationLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.view addSubview:self.mainViewController.view];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)pressBtnWithType:(UIButton *)sender {

    PressType pressType = (PressType)sender.tag;
    switch (pressType) {
        case PressTypeEditText: {
            [self presentViewController:[[EditTextViewController alloc] init] animated:YES completion:^{
            }];
        }
            break;
        case PressTypeShare: {
            [self.navigationController pushViewController:[[ShareViewController alloc] initWithModels:nil] animated:YES];
        }
            break;
        case PressTypeCount: {
            [self presentViewController:[[CountViewController alloc] init] animated:YES completion:^{
            }];
        
        }
            break;
        case PressTypeInfo:
            NSLog(@"PressTypeInfo");
            break;
            
        default:
            break;
    }
}
- (void)pressClose {
    
    [UIView animateWithDuration:durationTime animations:^{
        _changeTypeViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_changeTypeViewController.view belowSubview:_mainViewController.view];
        _changeTypeViewController.view.alpha = 1;
        [_changeTypeViewController.view removeFromSuperview];
        self.changeTypeViewController = nil;
        [_mainViewController.view addSubview:_mainViewController.collectionView];
        [_mainViewController.collectionView reloadData];
    }];
}
- (void)pressCell:(MakingCell *)cell Type:(PressType)type {

    self.animationLabel.textAlignment = cell.model.textAlignment;
    self.animationLabel.text      = cell.model.text;
    self.animationLabel.font      = [UIFont fontWithName:@"Zapfino" size:26];
    self.animationLabel.textColor = [UIColor grayColor];
    self.animationLabel.backgroundColor = cell.backgroundColor;
    self.animationLabel.frame     = CGRectInset(cell.bounds,0,0);

    [self toCell:self.animationLabel];
    [_mainViewController.collectionView removeFromSuperview];
    
    self.changeTypeViewController.defaultColor = cell.backgroundColor;
    self.changeTypeViewController.defaultModel = cell.model;
    self.changeTypeViewController.changeType = (ChangeType)type;
    
    [self.view insertSubview:self.changeTypeViewController.view belowSubview:_mainViewController.view];
    [UIView animateWithDuration:durationTime animations:^{
        _mainViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_mainViewController.view belowSubview:_changeTypeViewController.view];
        _mainViewController.view.alpha = 1;
    }];
}
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView {
    
    [self.mainViewController setSelectCell:cell];
    
    self.animationLabel.textAlignment = cell.model.textAlignment;
    self.animationLabel.text      = cell.model.text;
    self.animationLabel.font      = [UIFont fontWithName:@"Zapfino" size:26/2];
    self.animationLabel.textColor = [UIColor grayColor];
    self.animationLabel.backgroundColor = cell.backgroundColor;
    self.animationLabel.frame     = CGRectInset(cell.bounds,0,0);
    
    [self toMain:self.animationLabel scroller:scrollView cell:cell];
    [self pressClose];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_animationLabel removeFromSuperview];
    _animationLabel = nil;
}
- (void)toCell:(M80AttributedLabel *)label {
    
    [self.view addSubview:self.animationLabel];
    
    CFTimeInterval time = durationTime;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(label.layer.frame.origin.x+(label.layer.frame.size.width/2), label.layer.frame.origin.y+(label.layer.frame.size.height/2))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, CGRectGetHeight(label.layer.frame)/4)];
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.duration = time;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = time;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = time;
    [animationGroup setAnimations:[NSArray arrayWithObjects:positionAnimation,scaleAnimation, nil]];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [label.layer addAnimation:animationGroup forKey:@"toCell"];
}
- (void)toMain:(M80AttributedLabel *)label  scroller:(UIScrollView *)scroller cell:(MakingCell *)cell {
    label.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-scroller.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    [self.view addSubview:label];
    
    CFTimeInterval time = durationTime;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:label.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((int)(CGRectGetWidth(self.view.bounds)/2), CGRectGetHeight(label.layer.frame))];
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.duration = time;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = time;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = time;
    [animationGroup setAnimations:[NSArray arrayWithObjects:positionAnimation,scaleAnimation, nil]];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [label.layer addAnimation:animationGroup forKey:@"toMain"];
    
}
- (MainViewController *)mainViewController {

    if (!_mainViewController) {
        
        _mainViewController = [[MainViewController alloc] init];
        _mainViewController.delegate = self;
        _mainViewController.view.frame = self.view.bounds;
        _mainViewController.view.backgroundColor = [UIColor whiteColor];
    }
    
    return _mainViewController;
}
- (ChangeTypeViewController *)changeTypeViewController {
    
    if (!_changeTypeViewController) {
        
        _changeTypeViewController = [[ChangeTypeViewController alloc] init];
        _changeTypeViewController.delegate = self;
        _changeTypeViewController.view.frame = self.view.bounds;
        _changeTypeViewController.view.backgroundColor = [UIColor whiteColor];
    }
    
    return _changeTypeViewController;
}
- (M80AttributedLabel *)animationLabel {

    if (!_animationLabel) {
        _animationLabel = [[M80AttributedLabel alloc] init];
    }
    
    return _animationLabel;
}

@end
