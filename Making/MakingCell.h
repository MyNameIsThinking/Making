//
//  MakingCell.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreTextModel.h"

@interface MakingLayer : CALayer

@end

@interface MakingCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isShadow;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) NSArray *models;
+ (NSString *)identifier;
- (void)showWithModels:(NSArray *)models;
@end


