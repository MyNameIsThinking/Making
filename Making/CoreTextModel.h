//
//  CoreTextModel.h
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextModel : NSObject

@property (nonatomic, retain) NSString *text;                   //文字
@property (nonatomic, retain) NSString *defaultText;            //默認文案
@property (nonatomic, retain) NSString *fontName;               //字體
@property (nonatomic, assign) CGFloat fontSize;                 //字大小
@property (nonatomic, retain) UIColor *color;                   //字顏色
@property (nonatomic, assign) BOOL isStrokeWidth;               //加粗
@property (nonatomic, assign) CGFloat kern;                     //字距
@property (nonatomic, assign) CGSize originalSize;              //字原始大小
@property (nonatomic, retain) NSNumber *alignment;              //字對齊
@property (nonatomic, assign) CGRect frame;                     //字邊框
@property (nonatomic, assign) UIEdgeInsets edgeInsets;          //
@end
