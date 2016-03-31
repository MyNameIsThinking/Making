//
//  ChangeTypeViewController.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakingCell.h"

@protocol ChangeTypeDelegate <NSObject>

- (void)pressClose;
- (void)pressCell:(MakingCell *)cell scrollView:(UIScrollView *)scrollView;

@end
@interface ChangeTypeViewController : UIViewController
@property (nonatomic, assign) id<ChangeTypeDelegate> delegate;
@end
