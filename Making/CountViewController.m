//
//  CountViewController.m
//  Making
//
//  Created by rico on 2016/4/2.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "CountViewController.h"
#import "MakingCell.h"

@interface CenterLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) int visibleCount;
@end
@interface CountViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate> {

}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) CenterLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, assign) int count;
@end

@implementation CountViewController

- (void)dealloc {

    self.titleLabel = nil;
    self.scrollView = nil;
    self.collectionView = nil;
    self.collectionViewLayout = nil;
    self.closeBtn = nil;
}
- (id)init {

    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.selectIndex = 0;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 9;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.scrollView];
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
    return self.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    [cell initialize];
    cell.makingLayer.masksToBounds = YES;
    cell.makingLayer.borderWidth = 2;
    cell.makingLayer.borderColor = [UIColor yellowColor].CGColor;
    return cell;
}
- (void)goBack {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    if (scrollView == _scrollView) {
        NSIndexPath *indexPath = nil;
        if (velocity.x > 0) {
            self.selectIndex++;
            if (self.selectIndex >=self.count) {
                self.selectIndex = self.count-1;
            }
            indexPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
        } else if (velocity.x < 0) {
            self.selectIndex--;
            if (self.selectIndex <= 0) {
                self.selectIndex = 0;
            }
            indexPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
        }
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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
        _collectionView.userInteractionEnabled = NO;
        [_collectionView setClipsToBounds:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[MakingCell class] forCellWithReuseIdentifier:[MakingCell identifier]];
    }
    
    return _collectionView;
}
- (UIScrollView *)scrollView {

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.collectionView.frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        CGFloat width = CGRectGetHeight(self.view.bounds)/3;
        [_scrollView setContentSize:CGSizeMake((self.count+1)*width, 0)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        _scrollView.delegate = self;
    }
    
    return _scrollView;
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
    self.visibleCount = lastIndex - firstIndex;
    
    int maxVisibleOnScreen = 3;
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
