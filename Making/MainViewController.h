//
//  MainViewController.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakingCell.h"

typedef NS_OPTIONS(NSUInteger, PressType) {
    PressTypeChangeType = 0,
    PressTypeChangeBackground = 1,
    PressTypeEditText = 2,
    PressTypeShare = 3,
    PressTypeCount = 4,
    PressTypeInfo = 5,
};
@protocol MainDelegate <NSObject>

- (void)pressBtnWithType:(UIButton *)sender;

@end

@interface MainViewController : UIViewController
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) MakingCell *currCell;
@property (nonatomic, assign) id<MainDelegate> delegate;
@end
