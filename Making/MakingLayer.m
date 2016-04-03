//
//  MakingLayer.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MakingLayer.h"
#import <CoreText/CoreText.h>

@interface NSString (SafeRang)
- (NSString *)substringSafeWithRange:(NSRange)range;
@end
@implementation NSString (SafeRang)

- (NSString *)substringSafeWithRange:(NSRange)range {
    
    if (self.length > range.location+range.length-1) {
        return [self substringWithRange:range];
    }
    
    return self;
}
@end

@implementation MakingLayer

- (void)dealloc {

    self.models = nil;
}
- (void)drawInContext:(CGContextRef)ctx {
    
    [super drawInContext:ctx];
    
    if (self.isShadow) {
        CGContextSetShadowWithColor(ctx, CGSizeMake (0, 5), 4, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor);
        CGContextBeginTransparencyLayer (ctx, NULL);
        CGContextEndTransparencyLayer (ctx);
    }
    
    for (CoreTextModel *model in _models) {
        CGPoint shadowPoint = CGPointMake(model.frame.origin.x, model.frame.origin.y);
        model.color = [UIColor yellowColor];
        [self drawTextAtPoint:shadowPoint withContext:ctx withModel:model];
    }
    CGContextSetShadowWithColor(ctx, CGSizeMake (0, 0), 0, [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
    CGContextBeginTransparencyLayer (ctx, NULL);
    CGContextEndTransparencyLayer (ctx);
}
- (void)drawTextAtPoint:(CGPoint)location withContext:(CGContextRef)ctx withModel:(CoreTextModel *)model {
    
    CGAffineTransform textMatrix = CGAffineTransformMakeTranslation(location.x, location.y);
    textMatrix = CGAffineTransformScale(textMatrix, 1, -1);
    CGContextSetTextMatrix(ctx, textMatrix);
    
    CGFloat width = 0;
    CGFloat verticalKern = 0;
    
    for (NSInteger j = 0; j < model.text.length; j++) {
        
        NSString *subText = [model.text substringSafeWithRange:NSMakeRange(j, 1)];
        
        NSString *fontName = model.fontName;
        
        NSUInteger myLength = subText.length;
        CTFontRef ctfont = CTFontCreateWithName((CFStringRef)fontName, model.fontSize, NULL);
        CGGlyph *glyphs = malloc(sizeof(CGGlyph) *myLength);
        UniChar *characters = malloc(sizeof(UniChar) *myLength);
        CGSize *advances = malloc(sizeof(CGSize) *myLength);
        [subText getCharacters:characters range:NSMakeRange(0,myLength)];
        
        if (!CTFontGetGlyphsForCharacters(ctfont, characters, glyphs, myLength)) {
            CFRelease(ctfont);
            fontName = @"STHeitiSC-Medium";
            ctfont = CTFontCreateWithName((CFStringRef)fontName, model.fontSize, NULL);
            CTFontGetGlyphsForCharacters(ctfont, characters, glyphs, myLength);
        }
        CTFontGetAdvancesForGlyphs(ctfont, kCTFontOrientationHorizontal, glyphs, advances, myLength);
        free(characters);
        CGFontRef cgfont = CTFontCopyGraphicsFont(ctfont, NULL);
        CGContextSetFont(ctx, cgfont);
        CGContextSetFontSize(ctx, CTFontGetSize(ctfont));
        
        //畫字
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetFillColorWithColor(ctx, model.color.CGColor);
        //加粗
        if (model.isStrokeWidth) {
            CGContextSetLineWidth(ctx, 5);
            CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
            CGContextSetStrokeColorWithColor(ctx,model.color.CGColor);
        }
        
        location.y = -CTFontGetAscent(ctfont);
        CGFloat kern = model.kern;
        
        CGFloat offsetX = 0;
        CGSize originalSize = model.originalSize;
        
        switch ([model.alignment integerValue]) {
            case kCTTextAlignmentLeft: {
                offsetX = 0;
            }
                break;
            case kCTTextAlignmentRight: {
                offsetX = model.frame.size.width - originalSize.width;
            }
                break;
            case kCTTextAlignmentCenter: {
                offsetX = (model.frame.size.width - originalSize.width)/2;
            }
                break;
                
            default:
                break;
        }
        location.x = CTFontGetAdvancesForGlyphs(ctfont, kCTFontOrientationHorizontal, glyphs, advances, 0);
        location.x += offsetX+(j*kern)+width;
        location.y = -CTFontGetAscent(ctfont);
        CGContextShowGlyphsAtPositions(ctx, &glyphs[0], &location, 1);
        width += advances->width;
        
        verticalKern = model.kern;
        
        free(glyphs);
        free(advances);
        CGFontRelease(cgfont);
        CFRelease(ctfont);
    }
    
}
@end
