//
//  CountViewController.m
//  Making
//
//  Created by rico on 2016/4/2.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "CountViewController.h"
#import "MakingCell.h"
#import "CoreTextModel.h"

@class CountMakingCell;

@protocol CountMakingCellDelegate <NSObject>

- (void)pressAdd:(CountMakingCell *)cell;
- (void)pressDel:(CountMakingCell *)cell;

@end

@interface CountMakingCell : MakingCell
@property (nonatomic, weak) id<CountMakingCellDelegate> delegate;
@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, retain) UIButton *delBtn;
@end

@interface CenterLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger cellCount;
@end
@interface CountViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, CountMakingCellDelegate> {

}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) CenterLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) NSIndexPath *currIndexPath;
@property (nonatomic, retain) NSMutableArray *mainModels;
@end

@implementation CountViewController

- (void)dealloc {

    self.titleLabel = nil;
    self.collectionView = nil;
    self.collectionViewLayout = nil;
    self.closeBtn = nil;
}
- (id)initWithMainModels:(NSMutableArray *)mainModels {

    self = [super init];
    if (self) {
        _mainModels = mainModels;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeBtn];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = CGRectGetHeight(self.view.bounds)/3;
    return CGSizeMake(height, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CountMakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CountMakingCell identifier] forIndexPath:indexPath];
    cell.delegate = self;
    CoreTextModel *model = _mainModels[indexPath.row];
    cell.backgroundColor = model.BGColor;
    [cell showWithModel:model withFontName:nil];
    
    return cell;
}
- (void)goBack {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidEndDecelerating:!decelerate?scrollView:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        float minDis = CGRectGetHeight(scrollView.frame);
        _currIndexPath = nil;
        float scrollViewCenter = scrollView.contentOffset.x+(CGRectGetWidth(scrollView.frame)/2);
        NSArray *array = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *cellIndexPath in array) {
            CountMakingCell *cell = (CountMakingCell *)[self.collectionView cellForItemAtIndexPath:cellIndexPath];
            float cellCenter = cell.center.x;
            if (fabsf(scrollViewCenter-cellCenter) < minDis) {
                minDis = fabsf(scrollViewCenter-cellCenter);
                _currIndexPath = cellIndexPath;
            }
        }
        [self.collectionView scrollToItemAtIndexPath:_currIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
- (void)pressAdd:(CountMakingCell *)cell {

    if (_mainModels.count < 9) {
        
        CoreTextModel *copyModel = _mainModels[_currIndexPath.row];
        CoreTextModel *model = [[CoreTextModel alloc] initWithModel:copyModel];
        [_mainModels insertObject:model atIndex:_currIndexPath.row+1];
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)pressDel:(CountMakingCell *)cell {
    
    if (_mainModels.count > 1) {
        [_mainModels removeObjectAtIndex:_currIndexPath.row];
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
        }];
    }
}
- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"批量製作";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
        _titleLabel.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-size.width)/2, (CGRectGetHeight(self.view.bounds)/6)+(size.height/2), size.width, size.height);
    }
    
    return _titleLabel;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        CGFloat height = CGRectGetHeight(self.view.bounds)/3;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.view.bounds), height) collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        [_collectionView setClipsToBounds:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[CountMakingCell class] forCellWithReuseIdentifier:[CountMakingCell identifier]];
    }
    
    return _collectionView;
}
- (CenterLayout *)collectionViewLayout {
    
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[CenterLayout alloc] init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _collectionViewLayout;
}
- (UIButton *)closeBtn {

    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"關" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGSize size = [_closeBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_closeBtn.titleLabel.font}];
        _closeBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-size.width)/2, CGRectGetHeight(self.view.bounds)-(CGRectGetHeight(self.view.bounds)/6)+(size.height/2), size.width, size.height);
        [_closeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}
@end
@implementation CountMakingCell

- (void)dealloc {

    self.addBtn = nil;
    self.delBtn = nil;
}
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName {

    [super showWithModel:model withFontName:fontName];
    [self addSubview:self.addBtn];
    [self addSubview:self.delBtn];
}
- (UIButton *)addBtn {

    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:40];
        CGSize size = [_addBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_addBtn.titleLabel.font}];
        _addBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-size.width-10, CGRectGetHeight(self.frame)-size.height-10, size.width, size.height);
        [_addBtn addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addBtn;
}
- (UIButton *)delBtn {
    
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setTitle:@"-" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:40];
        CGSize size = [_delBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_delBtn.titleLabel.font}];
        _delBtn.frame = CGRectMake(10, CGRectGetHeight(self.frame)-size.height-10, size.width, size.height);
        [_delBtn addTarget:self action:@selector(pressDel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _delBtn;
}
- (void)pressAdd {

    if ([_delegate respondsToSelector:@selector(pressAdd:)]) {
        [_delegate pressAdd:self];
    }
}
- (void)pressDel {

    if ([_delegate respondsToSelector:@selector(pressDel:)]) {
        [_delegate pressDel:self];
    }
}
@end
@implementation CenterLayout

- (void)prepareLayout {

    [super prepareLayout];
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    
    if (self.cellCount == 0) {
        return theLayoutAttributes;
    }
    
    float minX = CGRectGetMinX(rect);
    float maxX = CGRectGetMaxX(rect);
    
    int firstIndex = floorf(minX / CGRectGetHeight(self.collectionView.frame));
    int lastIndex = floorf(maxX / CGRectGetHeight(self.collectionView.frame));
    int activeIndex = (int)(firstIndex + lastIndex)/2;
    
    int maxVisibleOnScreen = (int)self.cellCount;
    int firstItem = fmax(0, activeIndex - (int)(maxVisibleOnScreen/2) );
    int lastItem = fmin( self.cellCount-1 , activeIndex + (int)(maxVisibleOnScreen/2) );
    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    return [theLayoutAttributes copy];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.size = CGSizeMake(CGRectGetHeight(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    theAttributes.center = CGPointMake((CGRectGetWidth(self.collectionView.frame)/2)+((CGRectGetHeight(self.collectionView.frame))*(indexPath.item)), CGRectGetHeight(self.collectionView.frame)/2);
    return theAttributes;
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.cellCount*CGRectGetHeight(self.collectionView.frame)+((CGRectGetHeight(self.collectionView.frame)/3)*2), 0);
}
@end
