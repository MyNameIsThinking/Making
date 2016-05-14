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

@interface MakingCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isShadow;
@property (nonatomic, retain) CoreTextModel *model;
@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) CGFloat scale;
+ (NSString *)identifier;
- (void)showWithModel:(CoreTextModel *)model withFontName:(NSString *)fontName;
- (UIImage *)getImageFromView;
@end


