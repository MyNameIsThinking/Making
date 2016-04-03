//
//  ShareViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ShareViewController.h"
#import "MakingCell.h"

@interface ShareView : UIView
@property (nonatomic, retain) NSMutableArray *shares;
@end

@interface ShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) NSArray *models;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *backBtn;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UIView *grayLine;
@property (nonatomic, retain) ShareView *shareView;
@end

@implementation ShareViewController

- (void)dealloc {
    self.models = nil;
    self.collectionView = nil;
    self.collectionViewLayout = nil;
    self.backBtn = nil;
    self.countLabel = nil;
    self.grayLine = nil;
    self.shareView = nil;
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
    [self.view addSubview:self.countLabel];
    [self.view insertSubview:self.grayLine belowSubview:self.countLabel];
    [self.view addSubview:self.shareView];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.models.count) {
        case 1: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
        case 2: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetWidth(self.view.bounds)/2);
        }
            break;
        case 3: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 4: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetWidth(self.view.bounds)/2);
        }
            break;
        case 5: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 6: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 7: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 8: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 9: {
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
        }
            break;
            
        default:
            break;
    }
    
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (self.models.count) {
        case 1: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
        case 2: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/2);
        }
            break;
        case 3: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/3);
        }
            break;
        case 4: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
        case 5: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (CGRectGetWidth(self.view.bounds)/3)*2);
        }
            break;
        case 6: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (CGRectGetWidth(self.view.bounds)/3)*2);
        }
            break;
        case 7: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
        case 8: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
        case 9: {
            self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        }
            break;
            
        default:
            break;
    }
    self.collectionView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetWidth(self.view.bounds)/2);
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    [cell showWithModels:nil];
    return cell;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
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
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
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
- (UILabel *)countLabel {

    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor whiteColor];
        _countLabel.text = [NSString stringWithFormat:@"共%i張",(int)self.models.count];
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor grayColor];
        CGSize size = [_countLabel.text sizeWithAttributes:@{NSFontAttributeName:_countLabel.font}];
        CGFloat width = size.width+20;
        _countLabel.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-width)/2, CGRectGetWidth(self.view.bounds)+size.height, width, size.height);
    }
    
    return _countLabel;
}
- (UIView *)grayLine {

    if (!_grayLine) {
        CGFloat offset = 40;
        _grayLine = [[UIView alloc] initWithFrame:CGRectMake(offset/2, 0, CGRectGetWidth(self.view.bounds)-offset, 1)];
        _grayLine.center = CGPointMake(_grayLine.center.x, self.countLabel.center.y);
        _grayLine.backgroundColor = [UIColor grayColor];
    }
    
    return _grayLine;
}
- (NSArray *)models {

    if (!_models) {
        _models = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    }
    
    return _models;
}
- (ShareView *)shareView {

    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), MIN(self.backBtn.frame.origin.y-self.countLabel.frame.origin.y-self.countLabel.frame.size.height, 50))];
        _shareView.center = CGPointMake(_shareView.center.x, self.countLabel.frame.origin.y+self.countLabel.frame.size.height+60);
    }
    
    return _shareView;
}
@end

@implementation ShareView

- (void)dealloc {

    self.shares = nil;
}
- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        [self.shares addObject:@"本地"];
        [self.shares addObject:@"微信"];
        [self.shares addObject:@"微博"];
        [self.shares addObject:@"空間"];
        
        CGFloat offset = (frame.size.width-(frame.size.height*self.shares.count))/self.shares.count;
        
        for (int i = 0; i < self.shares.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.shares[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat width = frame.size.height;
            btn.frame = CGRectMake((offset/2)+((width+offset)*i), 0, width, width);
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 2;
            btn.layer.cornerRadius = width/2;
            btn.layer.borderColor = [UIColor yellowColor].CGColor;
            [self addSubview:btn];
        }
    }
    
    return self;
}
- (NSMutableArray *)shares {

    if (!_shares) {
        _shares = [[NSMutableArray alloc] init];
    }
    
    return _shares;
}
@end