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
@property (nonatomic, retain) MakingCell *currCell;
@end

@implementation MainViewController

- (void)dealloc {
    self.collectionView = nil;
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [_collectionView reloadData];
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
    newModel.fontName = selectCell.fontName;
    newModel.forewordFontName = selectCell.forewordFontName;
    [_mainModels replaceObjectAtIndex:_currIndex withObject:newModel];
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mainModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    _currCell = cell;
    _currIndex = indexPath.row;
    CoreTextModel *model = _mainModels[indexPath.row];
    cell.backgroundColor = model.BGColor;
    [cell showWithModel:model withFontName:nil];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([_delegate respondsToSelector:@selector(pressMainCellWithModel:)]) {
        CoreTextModel *model = _mainModels[indexPath.row];
        [_delegate pressMainCellWithModel:model];
    }
}
- (UICollectionView *)collectionView {

    if (!_collectionView) {
        CGFloat width = [MakingCell getCellSize].width;
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
- (void)pressCellWithChangeType:(UIButton *)sender {

    if ([_delegate respondsToSelector:@selector(pressCell:changeType:)]) {
        [_delegate pressCell:_currCell changeType:(PressType)sender.tag];
    }
}
- (UIButton *)changeTypeBtn {

    if (!_changeTypeBtn) {
        _changeTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeTypeBtn.tag = PressTypeChangeType;
        UIImage *image = [UIImage imageNamed:@"btn-layout"];
        [_changeTypeBtn setImage:image forState:UIControlStateNormal];
        _changeTypeBtn.frame = CGRectMake(0, CGRectGetHeight(_collectionView.frame)+image.size.width/2, image.size.width, image
                                          .size.height);
        _changeTypeBtn.center = CGPointMake(CGRectGetWidth(_collectionView.frame)/2, _changeTypeBtn.center.y);
        [_changeTypeBtn addTarget:self action:@selector(pressCellWithChangeType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeTypeBtn;
}
- (UIButton *)changeBackgroundBtn {
    
    if (!_changeBackgroundBtn) {
        _changeBackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBackgroundBtn.tag = PressTypeChangeBackground;
        UIImage *image = [UIImage imageNamed:@"btn-theme"];
        [_changeBackgroundBtn setImage:image forState:UIControlStateNormal];
        _changeBackgroundBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y, image.size.width, image.size.height);
        _changeBackgroundBtn.center = CGPointMake(_changeTypeBtn.frame.origin.x/2, _changeTypeBtn.center.y);
        [_changeBackgroundBtn addTarget:self action:@selector(pressCellWithChangeType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeBackgroundBtn;
}
- (UIButton *)editTextBtn {
    
    if (!_editTextBtn) {
        _editTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editTextBtn.tag = PressTypeChangeFont;
        UIImage *image = [UIImage imageNamed:@"btn-font"];
        [_editTextBtn setImage:image forState:UIControlStateNormal];
        _editTextBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y, image.size.width, image.size.height);
        _editTextBtn.center = CGPointMake(_changeTypeBtn.frame.origin.x+_changeTypeBtn.frame.size.width+_changeBackgroundBtn.center.x, _changeTypeBtn.center.y);
        [_editTextBtn addTarget:self action:@selector(pressCellWithChangeType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editTextBtn;
}
- (UIButton *)shareBtn {
    
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.tag = PressTypeShare;
        UIImage *image = [UIImage imageNamed:@"btn-share"];
        [_shareBtn setImage:image forState:UIControlStateNormal];
        _shareBtn.frame = CGRectMake(0, _changeTypeBtn.frame.origin.y+CGRectGetHeight(_changeTypeBtn.frame)+image.size.width/2, image.size.width, image.size.height);
        _shareBtn.center = CGPointMake(_changeTypeBtn.center.x, _shareBtn.center.y);
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
        UIImage *image = [UIImage imageNamed:@"btn-add"];
        [_countBtn setImage:image forState:UIControlStateNormal];
        _countBtn.frame = CGRectMake(10, CGRectGetHeight(self.view.bounds)-image.size.height-10, image.size.width, image.size.height);
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
        UIImage *image = [UIImage imageNamed:@"btn-info"];
        [_infoBtn setImage:image forState:UIControlStateNormal];
        _infoBtn.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-image.size.width-10, CGRectGetHeight(self.view.bounds)-image.size.height-10, image.size.width, image.size.height);
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
