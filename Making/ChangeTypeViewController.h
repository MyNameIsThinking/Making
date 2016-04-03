//
//  ChangeTypeViewController.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "BaseViewController.h"
#import "MakingCell.h"
#import "CoreTextModel.h"

typedef NS_OPTIONS(NSUInteger, ChangeType) {
    ChangeTypeAlignment = 0,
    ChangeTypeBackground = 1,
};

@protocol ChangeTypeDelegate <NSObject>

- (void)pressClose;
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView;

@end
@interface ChangeTypeViewController : BaseViewController
@property (nonatomic, weak) id<ChangeTypeDelegate> delegate;
@property (nonatomic, assign) ChangeType changeType;
@property (nonatomic, retain) NSArray *defaultModels;
@property (nonatomic, retain) UIColor *defaultColor;
@end
