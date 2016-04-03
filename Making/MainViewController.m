//
//  MainViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MainViewController.h"
#import "CoreTextModel.h"
#import "ChangeTypeManager.h"

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *changeBackgroundBtn;
@property (nonatomic, retain) UIButton *changeTypeBtn;
@property (nonatomic, retain) UIButton *editTextBtn;
@property (nonatomic, retain) UIButton *shareBtn;
@property (nonatomic, retain) UIButton *countBtn;
@property (nonatomic, retain) UIButton *infoBtn;
@property (nonatomic, retain) NSMutableArray *mainModels;
@property (nonatomic, retain) MakingCell *currCell;
@end

@implementation MainViewController

- (void)dealloc {
    self.collectionView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.changeTypeBtn];
    [self.view addSubview:self.changeBackgroundBtn];
    [self.view addSubview:self.editTextBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.countBtn];
    [self.view addSubview:self.infoBtn];
}
- (void)setSelectCell:(MakingCell *)selectCell {
    
    CoreTextModel *model = selectCell.model;
    CoreTextModel *newModel = [[CoreTextModel alloc] initWithModel:model];
    newModel.BGColor = selectCell.backgroundColor;
    [_mainModels replaceObjectAtIndex:_currIndex withObject:newModel];
    [_collectionView reloadData];
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
    return self.mainModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    cell.scale = 1;
    _currCell = cell;
    _currIndex = indexPath.row;
    CoreTextModel *model = _mainModels[indexPath.row];
    cell.backgroundColor = model.BGColor;
    [cell showWithModel:model];
    
    return cell;
}

- (UICollectionView *)collectionView {

    if (!_collectionView) {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, width) collectionViewLayout:self.collectionViewLayout];
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
- (void)pressBtnWithType:(UIButton *)sender {

    if ([_delegate respondsToSelector:@selector(pressCell:Type:)]) {
        [_delegate pressCell:_currCell Type:(PressType)sender.tag];
    }
}
- (UIButton *)changeTypeBtn {

    if (!_changeTypeBtn) {
        _changeTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeTypeBtn.tag = PressTypeChangeType;
        CGFloat width = 60;
        _changeTypeBtn.frame = CGRectMake(0, CGRectGetHeight(_collectionView.frame)+width, width, width);
        _changeTypeBtn.center = CGPointMake(CGRectGetWidth(_collectionView.frame)/2, _changeTypeBtn.center.y);
        [_changeTypeBtn setTitle:@"風格" forState:UIControlStateNormal];
        [_changeTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_changeTypeBtn addTarget:self action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeTypeBtn;
}
- (UIButton *)changeBackgroundBtn {
    
    if (!_changeBackgroundBtn) {
        _changeBackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBackgroundBtn.tag = PressTypeChangeBackground;
        CGFloat width = 60;
        _changeBackgroundBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y, width, width);
        _changeBackgroundBtn.center = CGPointMake(CGRectGetWidth(_collectionView.frame)/4, _changeTypeBtn.center.y);
        [_changeBackgroundBtn setTitle:@"背景" forState:UIControlStateNormal];
        [_changeBackgroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeBackgroundBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_changeBackgroundBtn addTarget:self action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeBackgroundBtn;
}
- (UIButton *)editTextBtn {
    
    if (!_editTextBtn) {
        _editTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editTextBtn.tag = PressTypeEditText;
        CGFloat width = 60;
        _editTextBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y, width, width);
        _editTextBtn.center = CGPointMake((CGRectGetWidth(_collectionView.frame)/4)*3, _changeTypeBtn.center.y);
        [_editTextBtn setTitle:@"編輯" forState:UIControlStateNormal];
        [_editTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _editTextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_delegate respondsToSelector:@selector(pressBtnWithType:)]) {
            [_editTextBtn addTarget:_delegate action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return _editTextBtn;
}
- (UIButton *)shareBtn {
    
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.tag = PressTypeShare;
        CGFloat width = 60;
        _shareBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y+CGRectGetHeight(_changeTypeBtn.frame)+width/2, width, width);
        _shareBtn.center = CGPointMake(_changeTypeBtn.center.x, _shareBtn.center.y);
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_delegate respondsToSelector:@selector(pressBtnWithType:)]) {
            [_shareBtn addTarget:_delegate action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return _shareBtn;
}
- (UIButton *)countBtn {
    
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.tag = PressTypeCount;
        CGFloat width = 60;
        _countBtn.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-width, width, width);
        _countBtn.center = CGPointMake(CGRectGetWidth(_collectionView.frame)/4, _countBtn.center.y);
        [_countBtn setTitle:@"新增" forState:UIControlStateNormal];
        [_countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _countBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_delegate respondsToSelector:@selector(pressBtnWithType:)]) {
            [_countBtn addTarget:_delegate action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return _countBtn;
}
- (UIButton *)infoBtn {
    
    if (!_infoBtn) {
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoBtn.tag = PressTypeInfo;
        CGFloat width = 60;
        _infoBtn.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-width, width, width);
        _infoBtn.center = CGPointMake((CGRectGetWidth(_collectionView.frame)/4)*3, _infoBtn.center.y);
        [_infoBtn setTitle:@"信息" forState:UIControlStateNormal];
        [_infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _infoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_delegate respondsToSelector:@selector(pressBtnWithType:)]) {
            [_infoBtn addTarget:_delegate action:@selector(pressBtnWithType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return _infoBtn;
}
- (NSMutableArray *)mainModels {

    if (!_mainModels) {
        _mainModels = [[NSMutableArray alloc] init];
        XMLUtil *xml = [ChangeTypeManager shareInstance].xmls[0];
        CoreTextModel *model = [[CoreTextModel alloc] initWithModel:xml.model];
        model.BGColor = [UIColor whiteColor];
        [_mainModels addObject:model];
    }
    
    return _mainModels;
}
@end
