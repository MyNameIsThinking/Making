//
//  MakingLayer.h
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CoreTextModel.h"

@interface MakingLayer : CALayer

@property (nonatomic, retain) NSArray *models;
@property (nonatomic, assign) BOOL isShadow;
@end
