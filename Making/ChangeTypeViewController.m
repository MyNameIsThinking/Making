//
//  ChangeTypeViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ChangeTypeViewController.h"
#import "MakingCell.h"
#import "ChangeTypeManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIColor (ColorSame)

- (BOOL)isSameToColor:(UIColor *)color {
    
    if (CGColorEqualToColor(self.CGColor, color.CGColor)) {
        return YES;
    } else {
        return NO;
    }
}

@end

@interface ChangeTypeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) NSMutableArray *colors;
@property (nonatomic, retain) NSMutableArray *xmls;
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
}
- (void)setChangeType:(ChangeType)changeType {

    {
        self.colors = nil;
        _colors = [[NSMutableArray alloc] initWithArray:[ChangeTypeManager shareInstance].colors];
        int selectIndex = -1;
        for (int i = 0; i < _colors.count; i++) {
            UIColor *color = _colors[i];
            if ([_defaultColor isSameToColor:color]) {
                selectIndex = i;
                break;
            }
        }
        
        if (selectIndex != -1 && selectIndex != 1) {
            [_colors exchangeObjectAtIndex:1 withObjectAtIndex:selectIndex];
        }
    }
    
    {
        self.xmls = nil;
        _xmls = [[NSMutableArray alloc] initWithArray:[ChangeTypeManager shareInstance].xmls];
        int selectIndex = -1;
        for (int i = 0; i < _xmls.count; i++) {
            XMLUtil *xml = _xmls[i];
            if ([_defaultModel.identifier isEqualToString:xml.model.identifier]) {
                selectIndex = i;
                break;
            }
        }
        
        if (selectIndex != -1 && selectIndex != 1) {
            [_xmls exchangeObjectAtIndex:1 withObjectAtIndex:selectIndex];
        }
    }
    
    if (_changeType != changeType) {
        _changeType = changeType;
        [_collectionView reloadData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    MakingCell *cell = (MakingCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(pressCell:scrollView:)]) {
        [_delegate pressCell:cell scrollView:collectionView];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = CGRectGetWidth(self.view.bounds)/2;
    return CGSizeMake(width, width);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_changeType == ChangeTypeAlignment) {
        return _xmls.count;
    }
    return _colors.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    cell.scale = 2;
    if (_changeType==ChangeTypeBackground) {
        cell.BGColor = _colors[indexPath.row];
        [cell showWithModel:self.defaultModel];
    } else {
        cell.BGColor = self.defaultColor;
        XMLUtil *xml = _xmls[indexPath.row];
        [cell showWithModel:xml.model];
    }
    
    return cell;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
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
- (BOOL)isSameColor:(UIColor *)colorA withColor:(UIColor *)colorB {

    return YES;
}
@end
