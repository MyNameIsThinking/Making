//
//  MakingCell.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakingLayer.h"

@interface MakingCell : UICollectionViewCell
@property (nonatomic, retain) MakingLayer *makingLayer;
@property (nonatomic, assign) BOOL isShadow;
@property (nonatomic, retain) UIColor *backgroundColor;
+ (NSString *)identifier;
- (void)showWithModels:(NSArray *)models;
@end
