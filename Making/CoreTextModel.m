//
//  CoreTextModel.m
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "CoreTextModel.h"

@implementation CoreTextModel

- (id)initWithModel:(CoreTextModel *)model {

    self = [super init];
    
    if (self) {
        self.identifier = model.identifier;             //唯一標示符
        self.text = model.text;                         //文字
        self.fontSize = model.fontSize;                 //文字大小
        self.fontName = model.fontName;                 //字体
        self.textColor = model.textColor;               //文字颜色
        self.highlightColor = model.highlightColor;     //链接点击时背景高亮色
        self.linkColor = model.linkColor;               //链接色
        self.underLineForLink = model.underLineForLink; //链接是否带下划线
        self.autoDetectLinks = model.autoDetectLinks;   //自动检测
        self.numberOfLines = model.numberOfLines;       //行数
        self.mainPosition = model.mainPosition;
        self.textAlignment = model.textAlignment;       //文字排版样式
        self.lineBreakMode = model.lineBreakMode;       //LineBreakMode
        self.lineSpacing = model.lineSpacing;           //行间距
        self.paragraphSpacing = model.paragraphSpacing; //段间距
        self.BGColor = model.BGColor;                   //背景颜色
        self.BGImage = model.BGImage;                   //背景圖
        
        self.forewordText = model.forewordText;
        self.forewordFontSize = model.forewordFontSize;
        self.forewordAlignment = model.forewordAlignment;
        self.forewordPosition = model.forewordPosition;
        self.forewordFontName = model.forewordFontName;
    }
    
    return self;
}
@end
