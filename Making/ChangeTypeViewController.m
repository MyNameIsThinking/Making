//
//  ChangeTypeViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ChangeTypeViewController.h"
#import "MakingCell.h"

@interface ChangeTypeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@end

@implementation ChangeTypeViewController
- (void)dealloc {

    self.collectionView = nil;
    self.collectionViewLayout = nil;
    self.closeBtn = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeBtn];
    // Do any additional setup after loading the view.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    MakingCell *cell = (MakingCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(pressCell:scrollView:)]) {
        [_delegate pressCell:cell scrollView:collectionView];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(self.view.bounds)/2;
    return CGSizeMake(width, width);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    [cell showWithModels:nil];
    return cell;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        [_collectionView registerClass:[MakingCell class] forCellWithReuseIdentifier:[MakingCell identifier]];
    }
    
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionViewLayout {
    
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    return _collectionViewLayout;
}
- (UIButton *)closeBtn {

    if (!_closeBtn) {
        CGFloat width = 60;
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-width, width, width);
        _closeBtn.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, _closeBtn.frame.origin.y);
        [_closeBtn setTitle:@"關閉" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_delegate respondsToSelector:@selector(pressClose)]) {
            [_closeBtn addTarget:_delegate action:@selector(pressClose) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return _closeBtn;
}

@end
