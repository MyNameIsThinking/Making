//
//  MainViewController.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "BaseViewController.h"
#import "MakingCell.h"
#import "CoreTextModel.h"

typedef NS_OPTIONS(NSUInteger, PressType) {
    PressTypeChangeType = 0,
    PressTypeChangeBackground = 1,
    PressTypeChangeFont = 2,
    PressTypeShare = 3,
    PressTypeCount = 4,
    PressTypeInfo = 5,
};
@protocol MainDelegate <NSObject>

- (void)pressBtnWithType:(UIButton *)sender;
- (void)pressMainCell;
- (void)pressCell:(MakingCell *)cell changeType:(PressType)type;
@end

@interface MainViewController : BaseViewController
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, weak) id<MainDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *mainModels;
- (void)setSelectCell:(MakingCell *)selectCell;
@end
