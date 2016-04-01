//
//  ChangeTypeViewController.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "BaseViewController.h"
#import "MakingCell.h"

@protocol ChangeTypeDelegate <NSObject>

- (void)pressClose;
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView;

@end
@interface ChangeTypeViewController : BaseViewController
@property (nonatomic, assign) id<ChangeTypeDelegate> delegate;
@end
