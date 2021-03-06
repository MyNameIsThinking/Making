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
#import "EditTextView.h"
#import "ShareViewController.h"
#import "CountView.h"
#import "MakingCell.h"
#import "M80AttributedLabel.h"
#import "FitHelper.h"

const NSTimeInterval durationTime = 0.3f;

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
            [_animationImageView removeFromSuperview];
            _animationImageView = nil;
            MakingCell *cell = (MakingCell *)[_mainViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_mainViewController.currIndex inSection:0]];
            UIImage *image = cell.cellImage;
            self.animationImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            self.animationImageView.image = image;
            self.animationImageView.backgroundColor = cell.backgroundColor;
            [self.view addSubview:_animationImageView];
            
            CountView *countView = [[CountView alloc] initWithMainModels:_mainViewController.mainModels mainView:_mainViewController];
            countView.collectionView.alpha = 0.f;
            countView.alpha = 0.f;
            [_mainViewController.view addSubview:countView];
            [UIView animateWithDuration:durationTime animations:^{
                CGFloat scale = [FitHelper fitWidth:250]/CGRectGetWidth(_mainViewController.collectionView.frame);
                CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
                CGFloat offset_Y = countView.collectionView.center.y - _mainViewController.collectionView.center.y;
                _animationImageView.transform = CGAffineTransformTranslate(transform, 0, offset_Y + 68.f);
                countView.alpha = 1.f;
            } completion:^(BOOL finished) {
                countView.collectionView.alpha = 1.f;
                [_animationImageView removeFromSuperview];
                _animationImageView = nil;
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
    EditTextView *editTextView = [[EditTextView alloc] initWithModel:model];
    editTextView.alpha = 0.f;
    [self.view addSubview:editTextView];
    [UIView animateWithDuration:.3f animations:^{
        editTextView.alpha = 1.f;
    }];
}
- (void)pressCell:(MakingCell *)cell changeType:(PressType)type {
    
    self.changeTypeViewController.defaultColor = cell.backgroundColor;
    self.changeTypeViewController.defaultModel = cell.model;
    self.changeTypeViewController.defaultFont = cell.fontName;
    NSInteger cellIndex = [self.changeTypeViewController setType:(ChangeType)type];
    
    UIImage *image = cell.cellImage;
    self.animationImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    self.animationImageView.image = image;
    self.animationImageView.backgroundColor = cell.backgroundColor;
    [self toCell:self.animationImageView toIndex:cellIndex];
    [_mainViewController.collectionView removeFromSuperview];
    
    [self.view insertSubview:self.changeTypeViewController.view belowSubview:_mainViewController.view];
    [UIView animateWithDuration:durationTime animations:^{
        _mainViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:_mainViewController.view belowSubview:_changeTypeViewController.view];
        _mainViewController.view.alpha = 1;
    }];
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
    }];
}
#pragma mark - ChangeTypeDelegate
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView {
    [self.mainViewController setSelectCell:cell];
    UIImage *image = cell.cellImage;
    self.animationImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    self.animationImageView.image = image;
    self.animationImageView.backgroundColor = cell.backgroundColor;
    [self toMain:self.animationImageView scroller:scrollView cell:cell];
    [self pressClose];
}
#pragma mark - event
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_animationImageView removeFromSuperview];
    _animationImageView = nil;
}
- (void)toCell:(UIImageView *)imageView toIndex:(NSInteger)index {
    
    [self.view addSubview:imageView];
    
    CFTimeInterval time = durationTime;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(imageView.layer.frame.origin.x+(imageView.layer.frame.size.width/2), imageView.layer.frame.origin.y+(imageView.layer.frame.size.height/2))];
    
    CGFloat centerY = CGRectGetHeight(imageView.layer.frame)/4.f;
    CGFloat offsetY = CGRectGetHeight(imageView.layer.frame)/2.f;
    switch (index) {
        case 0: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*1, centerY)];
        }
            break;
        case 1: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, centerY)];
        }
            break;
        case 2: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*1, centerY+offsetY)];
        }
            break;
        case 3: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, centerY+offsetY)];
        }
            break;
        case 4: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*1, centerY+2*offsetY)];
        }
            break;
        case 5: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, centerY+2*offsetY)];
        }
            break;
        case 6: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*1, centerY+3*offsetY)];
        }
            break;
        case 7: {
            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetWidth(self.view.bounds)/4)*3, centerY+3*offsetY)];
        }
            break;
            
        default:
            break;
    }

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
