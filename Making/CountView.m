//
//  CountView.m
//  Making
//
//  Created by rico on 2016/4/2.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "CountView.h"
#import "MakingCell.h"
#import "CoreTextModel.h"
#import "FitHelper.h"

#define kCELLCOUNT @"CellCount"

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
@interface CountView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, CountMakingCellDelegate, UIGestureRecognizerDelegate> {

}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) CenterLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) NSIndexPath *currIndexPath;
@property (nonatomic, retain) NSMutableArray *mainModels;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) MainViewController *mainView;
@property (nonatomic, retain) UISwipeGestureRecognizer *left;
@property (nonatomic, retain) UISwipeGestureRecognizer *right;
@end

@implementation CountView

- (void)dealloc {

    self.titleLabel = nil;
    self.collectionView = nil;
    self.collectionViewLayout = nil;
    self.closeBtn = nil;
}
- (id)initWithMainModels:(NSMutableArray *)mainModels mainView:(MainViewController *)mainView {

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _mainModels = mainModels;
        _mainView = mainView;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.collectionView];
        [self addSubview:self.closeBtn];
        [self addSubview:self.pageControl];
    }
    
    return self;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = CGRectGetHeight(self.bounds)/3;
    return CGSizeMake(height, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self.pageControl setNumberOfPages:_mainModels.count];
    _pageControl.hidden = _pageControl.numberOfPages==1;
    return _mainModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CountMakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CountMakingCell identifier] forIndexPath:indexPath];
    cell.delegate = self;
    CoreTextModel *model = _mainModels[indexPath.row];
    cell.backgroundColor = model.BGColor;
    [cell showWithModel:model withFontName:nil withBackgroundImage:model.BGImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCELLCOUNT object:@(_mainModels.count)];
    
    return cell;
}
- (void)goBack {
    CountMakingCell *cell = (CountMakingCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_pageControl.currentPage inSection:0]];
    cell.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(cell.frame))*.5f, _collectionView.frame.origin.y+cell.frame.origin.y, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
    [self addSubview:cell];
    cell.addBtn.hidden = YES;
    cell.delBtn.hidden = YES;
    _collectionView.hidden = YES;
    CGFloat scale = CGRectGetWidth(self.frame)/CGRectGetWidth(cell.frame);
    CGFloat offset_Y = (cell.center.y - (CGRectGetWidth(self.frame)*.5f))-45.f;
    [UIView animateWithDuration:.3f animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        cell.transform = CGAffineTransformTranslate(transform, 0, -offset_Y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_mainView.collectionView reloadData];
            [self removeFromSuperview];
        }];
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
        [self.pageControl setCurrentPage:_currIndexPath.item];
    }
}
- (void)pressAdd:(CountMakingCell *)cell {
    if (_mainModels.count < 9) {
        CoreTextModel *copyModel = _mainModels[_currIndexPath.row];
        CoreTextModel *model = [[CoreTextModel alloc] initWithModel:copyModel];
        [_mainModels insertObject:model atIndex:_currIndexPath.row+1];
        [self.collectionView performBatchUpdates:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCELLCOUNT object:@(_mainModels.count)];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionView indexPathForCell:cell].item+1 inSection:0];
            [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
            [self scrollViewDidEndDecelerating:_collectionView];
        }];
    }
}
- (void)pressDel:(CountMakingCell *)cell {
    if (_mainModels.count > 1) {
        [_mainModels removeObjectAtIndex:_currIndexPath.row];
        [self.collectionView performBatchUpdates:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCELLCOUNT object:@(_mainModels.count)];
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
            [self scrollViewDidEndDecelerating:_collectionView];
        }];
    }
}
- (void)swip:(UISwipeGestureRecognizer *)sender {
    _collectionView.userInteractionEnabled = NO;
    if (sender.state == UIGestureRecognizerStateEnded) {
        UISwipeGestureRecognizerDirection dir = sender.direction;
        if (dir == UISwipeGestureRecognizerDirectionRight) {
            NSInteger nextIndex = _pageControl.currentPage-1;
            if (nextIndex < [_collectionView numberOfItemsInSection:0] && nextIndex>=0) {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                [_pageControl setCurrentPage:nextIndex];
            }
        } else if (dir == UISwipeGestureRecognizerDirectionLeft) {
            NSInteger nextIndex = _pageControl.currentPage+1;
            if (nextIndex < [_collectionView numberOfItemsInSection:0] && nextIndex>=0) {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                [_pageControl setCurrentPage:nextIndex];
            }
        }
    }
    _collectionView.userInteractionEnabled = YES;
}
- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"批量制作";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
        _titleLabel.frame = CGRectMake((CGRectGetWidth(self.bounds)-size.width)/2, [FitHelper fitHeight:80], size.width, size.height);
    }
    
    return _titleLabel;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        CGFloat y = self.titleLabel.frame.origin.y+CGRectGetHeight(self.titleLabel.frame)+[FitHelper fitHeight:80];
        CGFloat height = [FitHelper fitWidth:250]+[FitHelper fitWidth:30];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.bounds), height) collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView setClipsToBounds:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[CountMakingCell class] forCellWithReuseIdentifier:[CountMakingCell identifier]];
        [_collectionView addGestureRecognizer:self.left];
        [_collectionView addGestureRecognizer:self.right];
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
        UIImage *image = [UIImage imageNamed:@"btn-confirm"];
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        CGSize size = image.size;
        _closeBtn.frame = CGRectMake((CGRectGetWidth(self.bounds)-size.width)/2, CGRectGetHeight(self.bounds)-image.size.height-[FitHelper fitHeight:20], size.width, size.height);
        [_closeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}
- (UIPageControl *)pageControl {

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, _collectionView.frame.origin.y+CGRectGetHeight(_collectionView.frame)+[FitHelper fitHeight:10], CGRectGetWidth(self.frame), 8);
        [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    }
    
    return _pageControl;
}
- (UISwipeGestureRecognizer *)left {
    if (!_left) {
        _left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        _left.direction = UISwipeGestureRecognizerDirectionLeft;
        _left.delegate = self;
    }
    return _left;
}
- (UISwipeGestureRecognizer *)right {
    if (!_right) {
        _right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
        _right.direction = UISwipeGestureRecognizerDirectionRight;
        _right.delegate = self;
    }
    return _right;
}
@end
@implementation CountMakingCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _addBtn = nil;
    _delBtn = nil;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCellCount:) name:kCELLCOUNT object:nil];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.2f animations:^{
            _addBtn.alpha = 1.f;
            _delBtn.alpha = 1.f;
        }];
    });
}
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName withBackgroundImage:(UIImage *)image {

    [super showWithModel:model withFontName:fontName withBackgroundImage:model.BGImage];
    [self addSubview:self.addBtn];
    [self addSubview:self.delBtn];
}
- (void)setCellCount:(NSNotification *)notification {
    NSInteger cellCount = [[notification object] integerValue];
    _addBtn.hidden = cellCount >= 9;
    _delBtn.hidden = cellCount <= 1;
}
- (UIButton *)addBtn {

    if (!_addBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-copy"];
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:image forState:UIControlStateNormal];
        CGSize size = image.size;
        _addBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-size.width-[FitHelper fitWidth:10], CGRectGetHeight(self.frame)-size.height-[FitHelper fitWidth:10], size.width, size.height);
        [_addBtn addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.alpha = 0.f;
    }
    
    return _addBtn;
}
- (UIButton *)delBtn {
    
    if (!_delBtn) {
        UIImage *image = [UIImage imageNamed:@"btn-remove"];
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:image forState:UIControlStateNormal];
        CGSize size = image.size;;
        _delBtn.frame = CGRectMake([FitHelper fitWidth:10], CGRectGetHeight(self.frame)-size.height-[FitHelper fitWidth:10], size.width, size.height);
        [_delBtn addTarget:self action:@selector(pressDel) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.alpha = 0.f;
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

@interface CenterLayout () {
    NSIndexPath *_insertIndexPath;
    NSIndexPath *_deleteIndexPath;
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
    CGFloat width = [FitHelper fitWidth:250];
    theAttributes.size = CGSizeMake(width, width);
    theAttributes.center = CGPointMake((CGRectGetWidth(self.collectionView.frame)/2)+((CGRectGetHeight(self.collectionView.frame))*(indexPath.item)), CGRectGetHeight(self.collectionView.frame)/2);
    return theAttributes;
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.cellCount*CGRectGetHeight(self.collectionView.frame)+((CGRectGetHeight(self.collectionView.frame)/3)*2), 0);
}
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            _deleteIndexPath = update.indexPathBeforeUpdate;
        } else if (update.updateAction == UICollectionUpdateActionInsert) {
            _insertIndexPath = update.indexPathAfterUpdate;
        }
    }
}
- (void)finalizeCollectionViewUpdates {
    if (_insertIndexPath) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:_insertIndexPath.item inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } else if (_deleteIndexPath) {
        NSIndexPath *nextIndexPath;
        if (_deleteIndexPath.item>0) {
            nextIndexPath = [NSIndexPath indexPathForItem:_deleteIndexPath.item-1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    _insertIndexPath = nil;
    _deleteIndexPath = nil;
}
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if (itemIndexPath.item == _insertIndexPath.item && _insertIndexPath) {
        UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
        attributes.transform = CGAffineTransformMakeScale(0.f, 0.f);
        return attributes;
    }
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    attributes.transform = CGAffineTransformMakeScale(.2f, .2f);
    attributes.alpha = 0.0;
    return attributes;
}
@end
