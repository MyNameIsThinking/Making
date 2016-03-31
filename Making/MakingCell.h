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
+ (NSString *)identifier;
- (void)initialize;
@end
