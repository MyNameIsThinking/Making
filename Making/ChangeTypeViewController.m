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
#import "FitHelper.h"

@implementation UIColor (ColorSame)

- (BOOL)isSameToColor:(UIColor *)color {
    
    if (CGColorEqualToColor(self.CGColor, color.CGColor)) {
        return YES;
    } else {
        return NO;
    }
}

@end

@interface ChangeTypeViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, MakingCellDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) NSMutableArray *colors;
@property (nonatomic, retain) NSMutableArray *xmls;
@property (nonatomic, retain) NSMutableArray *fonts;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, assign) NSInteger showCheckIndex;
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

    _changeType = changeType;

    switch (_changeType) {
        case ChangeTypeBackground: {
            self.colors = nil;
            _colors = [[NSMutableArray alloc] initWithArray:[ChangeTypeManager shareInstance].colors];
            int selectIndex = -1;
            for (int i = 0; i < _colors.count; i++) {
                if ([_colors[i] isKindOfClass:[UIColor class]]) {
                    UIColor *color = _colors[i];
                    if ([_defaultColor isSameToColor:color]) {
                        selectIndex = i;
                        break;
                    }
                }
            }
            _showCheckIndex = selectIndex+1;
        }
            break;
            
        case ChangeTypeAlignment: {
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
            _showCheckIndex = selectIndex;
        }
            break;
        case ChangeTypeFont: {
            self.fonts = nil;
            _fonts = [[NSMutableArray alloc] initWithArray:[ChangeTypeManager shareInstance].fonts];
            int selectIndex = -1;
            for (int i = 0; i < _fonts.count; i++) {
                NSString *fontName = _fonts[i];
                if ([_defaultFont isEqualToString:fontName]) {
                    selectIndex = i;
                    break;
                }
            }
            _showCheckIndex = selectIndex;
        }
            break;
        default:
            break;
    }
    
    [_collectionView reloadData];
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
    } else if (_changeType==ChangeTypeBackground) {
        return _colors.count+1;
    } else if (_changeType==ChangeTypeFont) {
        return _fonts.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MakingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MakingCell identifier] forIndexPath:indexPath];
    if (_changeType==ChangeTypeBackground) {
        cell.backgroundColor = indexPath.row==0?[UIColor whiteColor]:_colors[indexPath.row-1];
        UIImage *image = self.defaultModel.BGImage?:[UIImage imageNamed:@"icon-origin"];
        [cell showWithModel:self.defaultModel withFontName:nil withBackgroundImage:indexPath.row==0?image:nil];
        cell.cellDelegate = self;
    } else if (_changeType==ChangeTypeAlignment) {
        cell.backgroundColor = self.defaultColor;
        XMLUtil *xml = _xmls[indexPath.row];
        [cell showWithModel:xml.model withFontName:nil withBackgroundImage:self.defaultModel.BGImage];
        cell.cellDelegate = nil;
    } else if (_changeType==ChangeTypeFont) {
        cell.backgroundColor = self.defaultColor;
        NSString *fontName = _fonts[indexPath.row];
        [cell showWithModel:self.defaultModel withFontName:fontName withBackgroundImage:self.defaultModel.BGImage];
        cell.cellDelegate = nil;
    }
    
    cell.isShowPhoto = (indexPath.item==0 && _changeType==ChangeTypeBackground)?1:0;
    cell.isShowCheck = indexPath.item==_showCheckIndex;
    
    return cell;
}
#pragma mark - MakingCellDelegate
- (void)openImagePicker {

    [self presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    self.defaultModel.BGImage = image;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
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
        UIImage *image = [UIImage imageNamed:@"btn-cancel-shadowed"];
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-image.size.width)/2, CGRectGetHeight(self.view.bounds)-image.size.height-[FitHelper fitHeight:20], image.size.width, image.size.height);
        [_closeBtn addTarget:self action:@selector(pressClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (void)pressClose {
    [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:_showCheckIndex inSection:0]];
}
- (UIImagePickerController *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
        
    }
    
    return _imagePicker;
}
@end
