//
//  CoreTextModel.h
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CoreTextModel : NSObject

@property (nonatomic,strong)    NSString *identifier;           //唯一標示符
@property (nonatomic,strong)    NSString *text;                 //文字
@property (nonatomic,strong)    UIFont *font;                   //字体
@property (nonatomic,strong)    UIColor *textColor;             //文字颜色
@property (nonatomic,strong)    UIColor *highlightColor;        //链接点击时背景高亮色
@property (nonatomic,strong)    UIColor *linkColor;             //链接色
@property (nonatomic,assign)    BOOL    underLineForLink;       //链接是否带下划线
@property (nonatomic,assign)    BOOL    autoDetectLinks;        //自动检测
@property (nonatomic,assign)    NSInteger   numberOfLines;      //行数
@property (nonatomic,assign)    CTTextAlignment textAlignment;  //文字排版样式
@property (nonatomic,assign)    CTLineBreakMode lineBreakMode;  //LineBreakMode
@property (nonatomic,assign)    CGFloat lineSpacing;            //行间距
@property (nonatomic,assign)    CGFloat paragraphSpacing;       //段间距
@end
