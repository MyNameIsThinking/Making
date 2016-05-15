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
@property (nonatomic, retain) UIImageView *animationImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.view addSubview:self.mainViewController.view];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - MainDelegate
- (void)pressBtnWithType:(UIButton *)sender {

    PressType pressType = (PressType)sender.tag;
    switch (pressType) {
        case PressTypeShare: {
            NSArray *models = [[NSArray alloc] initWithArray:_mainViewController.mainModels];
            [self.navigationController pushViewController:[[ShareViewController alloc] initWithModels:models] animated:YES];
        }
            break;
        case PressTypeCount: {
            [self presentViewController:[[CountViewController alloc] initWithMainModels:_mainViewController.mainModels] animated:YES completion:^{
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
- (void)pressMainCellWithModel:(CoreTextModel *)model {
    [self presentViewController:[[EditTextViewController alloc] initWithModel:model] animated:YES completion:^{
    }];
}
- (void)pressCell:(MakingCell *)cell changeType:(PressType)type {
    
    UIImage *image = [cell getImageFromView];
    self.animationImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.animationImageView.image = image;
    [self toCell:self.animationImageView];
    [_mainViewController.collectionView removeFromSuperview];
    
    self.changeTypeViewController.defaultColor = cell.backgroundColor;
    self.changeTypeViewController.defaultModel = cell.model;
    self.changeTypeViewController.defaultFont = cell.fontName;
    self.changeTypeViewController.changeType = (ChangeType)type;
    
    [self.view insertSubview:self.changeTypeViewController.view belowSubview:_mainViewController.view];
    [UIView animateWithDuration:durationTime animations:^{
        _mainViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_mainViewController.view belowSubview:_changeTypeViewController.view];
        _mainViewController.view.alpha = 1;
    }];
}
#pragma mark - ChangeTypeDelegate
- (void)pressClose {
    
    [UIView animateWithDuration:durationTime animations:^{
        _changeTypeViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_changeTypeViewController.view belowSubview:_mainViewController.view];
        _changeTypeViewController.view.alpha = 1;
        [_changeTypeViewController.view removeFromSuperview];
        self.changeTypeViewController = nil;
        [_mainViewController.view addSubview:_mainViewController.collectionView];
    }];
}
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView {
    
    [self.mainViewController setSelectCell:cell];
    UIImage *image = [cell getImageFromView];
    self.animationImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.animationImageView.image = image;
    [self toMain:self.animationImageView scroller:scrollView cell:cell];
    [self pressClose];
}
#pragma mark - event
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_animationImageView removeFromSuperview];
    _animationImageView = nil;
}
- (void)toCell:(UIImageView *)imageView {
    
    [self.view addSubview:imageView];
    
    CFTimeInterval time = durationTime;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(imageView.layer.frame.origin.x+(imageView.layer.frame.size.width/2), imageView.layer.frame.origin.y+(imageView.layer.frame.size.height/2))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, CGRectGetHeight(imageView.layer.frame)/4)];
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
    [imageView.layer addAnimation:animationGroup forKey:@"toCell"];
}
- (void)toMain:(UIImageView *)imageView  scroller:(UIScrollView *)scroller cell:(MakingCell *)cell {
    imageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-scroller.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    [self.view addSubview:imageView];
    
    CFTimeInterval time = durationTime;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:imageView.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((int)(CGRectGetWidth(self.view.bounds)/2), CGRectGetHeight(imageView.layer.frame))];
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
    [imageView.layer addAnimation:animationGroup forKey:@"toMain"];
    
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
- (UIImageView *)animationImageView {

    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
    }
    
    return _animationImageView;
}

@end
