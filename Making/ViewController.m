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

@interface ViewController () <MainDelegate,ChangeTypeDelegate>

@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) ChangeTypeViewController *changeTypeViewController;
@property (nonatomic, retain) MakingLayer *animationLayer;
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
        case PressTypeChangeType:
        case PressTypeChangeBackground: {
        
            self.animationLayer.frame = _mainViewController.currCell.frame;
            self.animationLayer.backgroundColor = _mainViewController.currCell.backgroundColor.CGColor;
            [self.view.layer addSublayer:self.animationLayer];
            [self toCell:self.animationLayer];
            [_mainViewController.currCell removeFromSuperview];
            
            self.changeTypeViewController.defaultColor = _mainViewController.currCell.backgroundColor;
            self.changeTypeViewController.defaultModels = _mainViewController.currCell.models;
            self.changeTypeViewController.changeType = (ChangeType)pressType;
            
            [self.view insertSubview:self.changeTypeViewController.view belowSubview:_mainViewController.view];
            [UIView animateWithDuration:1 animations:^{
                _mainViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                [self.view insertSubview:_mainViewController.view belowSubview:_changeTypeViewController.view];
                _mainViewController.view.alpha = 1;
            }];
            
        }
            break;
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
    [_mainViewController.collectionView reloadData];
    [UIView animateWithDuration:1 animations:^{
        _changeTypeViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_changeTypeViewController.view belowSubview:_mainViewController.view];
        _changeTypeViewController.view.alpha = 1;
        [_changeTypeViewController.view removeFromSuperview];
        self.changeTypeViewController = nil;
    }];
}
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView {
    [self pressClose];
    self.animationLayer.frame = cell.frame;
    self.animationLayer.backgroundColor = [UIColor redColor].CGColor;
    [self toMain:self.animationLayer scroller:scrollView];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_animationLayer removeFromSuperlayer];
    _animationLayer = nil;
}
- (void)toCell:(MakingLayer *)layer {
    
    CFTimeInterval time = 0.2f;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.frame.origin.x+(layer.frame.size.width/2), layer.frame.origin.y+(layer.frame.size.height/2))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, CGRectGetHeight(layer.frame)/4)];
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
    [layer addAnimation:animationGroup forKey:@"toCell"];
}
- (void)toMain:(MakingLayer *)layer  scroller:(UIScrollView *)scroller {
    layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y-scroller.contentOffset.y, layer.frame.size.width, layer.frame.size.height);
    [self.view.layer addSublayer:layer];
    
    CFTimeInterval time = 0.2f;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(layer.frame))];
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
    [layer addAnimation:animationGroup forKey:@"toMain"];
    
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
- (MakingLayer *)animationLayer {

    if (!_animationLayer) {
        _animationLayer = [[MakingLayer alloc] init];
    }
    
    return _animationLayer;
}

@end
