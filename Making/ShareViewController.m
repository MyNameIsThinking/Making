//
//  ShareViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ShareViewController.h"
#import "MakingCell.h"

@interface ShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *backBtn;
@end

@implementation ShareViewController

- (void)dealloc {

}
- (id)initWithModels:(NSArray *)models {

    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.backBtn];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    [cell initialize];
    return cell;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[MakingCell class] forCellWithReuseIdentifier:[MakingCell identifier]];
    }
    
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionViewLayout {
    
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _collectionViewLayout;
}
- (UIButton *)backBtn {

    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"<" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:50];
        CGSize size = [_backBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_backBtn.titleLabel.font}];
        _backBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-size.width)/2, CGRectGetHeight(self.view.bounds)-20-size.height, size.width,size.height);
        [_backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
    }
                                    
    return _backBtn;
}
@end
