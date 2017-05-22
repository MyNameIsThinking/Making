//
//  ShareViewController.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ShareViewController.h"
#import "MakingCell.h"
#import "CoreTextModel.h"
#import "UIImage+Save.h"
#import "FitHelper.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

typedef NS_OPTIONS(NSUInteger, ShareType) {
    ShareTypeLocal = 0,
    ShareTypeWeChat = 1,
    ShareTypeWeiBo = 2,
    ShareTypeQZone = 3,
};

@protocol  ShareViewDelegate <NSObject>

- (void)pressShare:(ShareType)type;

@end
@interface ShareView : UIView
@property (nonatomic, retain) NSMutableArray *shares;
@property (nonatomic, weak) id<ShareViewDelegate> delegate;
@end

@interface ShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ShareViewDelegate>
@property (nonatomic, retain) NSArray *models;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *backBtn;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UIView *grayLine;
@property (nonatomic, retain) ShareView *shareView;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, retain) NSMutableArray *hiddenList;
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
        _models = models;
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
- (void)pressShare:(ShareType)type {

    UIImage *shareImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < _models.count; i++) {
        CoreTextModel *model = _models[i];
        MakingCell *cell = [[MakingCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds))];
        cell.backgroundColor = model.BGColor;
        [cell showWithModel:model withFontName:nil withBackgroundImage:model.BGImage];
        UIImage *image = [cell getImageFromView];
        
        if (_models.count > 1) {
            if (![[_hiddenList objectAtIndex:i] boolValue]) {
                [images addObject:image];
            }
        } else if (_models.count == 1) {
            [images addObject:image];
        }
        
        if (i == 0) {
            shareImage = image;
        }
    }
    
    switch (type) {
        case ShareTypeLocal: {
        
            for (int i = 0; i < images.count; i++) {
                UIImage *image = images[i];
                [image saveToPhotosAlbumOnSuccess:^{
                    NSLog(@"Success");
                } onError:^{
                    NSLog(@"Fail");
                }];
            }
        }
            break;
        case ShareTypeWeiBo: {
            
            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://www.sina.com";
            authRequest.scope = @"all";
            
            WBMessageObject *message = [WBMessageObject message];
            message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
            WBImageObject *image = [WBImageObject object];
            image.imageData = UIImageJPEGRepresentation(shareImage, 1.f);
            message.imageObject = image;
#if 1
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
#else
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
#endif
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];
        }
            break;
        default:
            break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.models.count) {
        case 1: {
            return CGSizeMake([FitHelper fitWidth:335], [FitHelper fitWidth:335]);
        }
            break;
        case 2: {
            return CGSizeMake([FitHelper fitWidth:163], [FitHelper fitWidth:163]);
        }
            break;
        case 3: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
        case 4: {
            return CGSizeMake([FitHelper fitWidth:163], [FitHelper fitWidth:163]);
        }
            break;
        case 5: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
        case 6: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
        case 7: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
        case 8: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
        case 9: {
            return CGSizeMake([FitHelper fitWidth:105], [FitHelper fitWidth:105]);
        }
            break;
            
        default:
            break;
    }
    
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat width  = [FitHelper fitWidth:335];
    
    switch (self.models.count) {
        case 1: {
            return 0;
        }
            break;
        case 2: {
            return 0;
        }
            break;
        case 3: {
            return 0;
        }
            break;
        case 4: {
            return width - (2*[FitHelper fitWidth:163]);
        }
            break;
        case 5: {
            return ((width/3)*2) - (2*[FitHelper fitWidth:105]);
        }
            break;
        case 6: {
            return ((width/3)*2) - (2*[FitHelper fitWidth:105]);
        }
            break;
        case 7: {
            return [FitHelper fitWidth:10];
        }
            break;
        case 8: {
            return [FitHelper fitWidth:10];
        }
            break;
        case 9: {
            return [FitHelper fitWidth:10];
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    CGFloat x = [FitHelper fitWidth:20];
    CGFloat width  = [FitHelper fitWidth:335];
    _scale = 1;
    switch (self.models.count) {
        case 1: {
            self.collectionView.frame = CGRectMake(x, x, width, width);
            _scale = 1;
        }
            break;
        case 2: {
            self.collectionView.frame = CGRectMake(x, x, width, width/2);
            _scale = 2;
        }
            break;
        case 3: {
            self.collectionView.frame = CGRectMake(x, x, width, [FitHelper fitWidth:105]);
            _scale = 3;
        }
            break;
        case 4: {
            self.collectionView.frame = CGRectMake(x, x, width, width);
            _scale = 2;
        }
            break;
        case 5: {
            self.collectionView.frame = CGRectMake(x, x, width, (width/3)*2);
            _scale = 3;
        }
            break;
        case 6: {
            self.collectionView.frame = CGRectMake(x, x, width, (width/3)*2);
            _scale = 3;
        }
            break;
        case 7: {
            self.collectionView.frame = CGRectMake(x, x, width, width);
            _scale = 3;
        }
            break;
        case 8: {
            self.collectionView.frame = CGRectMake(x, x, width, width);
            _scale = 3;
        }
            break;
        case 9: {
            self.collectionView.frame = CGRectMake(x, x, width, width);
            _scale = 3;
        }
            break;
            
        default:
            break;
    }
    self.collectionView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetWidth(self.view.bounds)/2);
    
    self.countLabel.hidden = self.models.count <= 1;
    self.grayLine.hidden = self.models.count <= 1;
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MakingCell *cell = (MakingCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    CoreTextModel *model = _models[indexPath.row];
    cell.backgroundColor = model.BGColor;
    [cell showWithModel:model withFontName:nil withBackgroundImage:model.BGImage];
    
    UIImage *image = [UIImage imageNamed:@"icon-chk-solid"];
    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-image.size.width-[FitHelper fitWidth:10], CGRectGetHeight(cell.frame)-image.size.height-[FitHelper fitWidth:10], image.size.width, image.size.height)];
    checkImageView.tag = 404;
    checkImageView.image = image;
    [cell addSubview:checkImageView];
    checkImageView.hidden = _models.count <= 1;
    [self.hiddenList addObject:@(checkImageView.hidden)];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MakingCell *cell = (MakingCell *)[collectionView cellForItemAtIndexPath:indexPath];
    for (UIView *view in cell.subviews) {
        if (view.tag == 404) {
            view.hidden = !view.hidden;
            [_hiddenList replaceObjectAtIndex:indexPath.item withObject:@(view.hidden)];
            break;
        }
    }
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
        UIImage *image = [UIImage imageNamed:@"btn-back"];
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:image forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-image.size.width)/2, CGRectGetHeight(self.view.bounds)-[FitHelper fitHeight:20]-image.size.height, image.size.width,image.size.height);
        [_backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
    }
                                    
    return _backBtn;
}
- (UILabel *)countLabel {

    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor whiteColor];
        _countLabel.text = [NSString stringWithFormat:@"共%i张",(int)self.models.count];
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
- (ShareView *)shareView {

    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), MIN(self.backBtn.frame.origin.y-self.countLabel.frame.origin.y-self.countLabel.frame.size.height, 50))];
        _shareView.delegate = self;
        _shareView.center = CGPointMake(_shareView.center.x, self.countLabel.frame.origin.y+self.countLabel.frame.size.height+60);
    }
    
    return _shareView;
}
- (NSMutableArray *)hiddenList {
    if (!_hiddenList) {
        _hiddenList = [[NSMutableArray alloc] init];
    }
    return _hiddenList;
}
@end

@implementation ShareView

- (void)dealloc {

    self.shares = nil;
}
- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        UIImage *saveImage = [UIImage imageNamed:@"btn-share-save"];
        [self.shares addObject:saveImage];
        [self.shares addObject:[UIImage imageNamed:@"btn-share-wechat"]];
        [self.shares addObject:[UIImage imageNamed:@"btn-share-weibo"]];
        [self.shares addObject:[UIImage imageNamed:@"btn-share-pinterest"]];
        
        CGFloat offset = (frame.size.width-(saveImage.size.width*self.shares.count)-(2*[FitHelper fitWidth:20]))/(self.shares.count-1);
        
        for (int i = 0; i < self.shares.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            UIImage *image = self.shares[i];
            [btn setImage:image forState:UIControlStateNormal];
            btn.frame = CGRectMake([FitHelper fitWidth:20]+((image.size.width+offset)*i), 0, image.size.width, image.size.height);
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 2;
            btn.layer.cornerRadius = image.size.width/2;
            btn.layer.borderColor = [UIColor yellowColor].CGColor;
            [btn addTarget:self action:@selector(pressShare:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    
    return self;
}
- (void)pressShare:(UIButton *)sender {

    if ([_delegate respondsToSelector:@selector(pressShare:)]) {
        [_delegate pressShare:(ShareType)sender.tag];
    }
}
- (NSMutableArray *)shares {

    if (!_shares) {
        _shares = [[NSMutableArray alloc] init];
    }
    
    return _shares;
}

@end
