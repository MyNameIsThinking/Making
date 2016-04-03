//
//  MakingCell.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MakingCell.h"
#import "CoreTextModel.h"
#import "M80AttributedLabel.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]


@interface MakingCell ()
@property (nonatomic, retain) M80AttributedLabel *label;
@end
@implementation MakingCell

+ (NSString *)identifier {
    return @"MakingCell";
}
- (void)dealloc {
    self.backgroundColor = nil;
    self.model = nil;
    self.label = nil;
}
- (void)showWithModel:(CoreTextModel *)model {
    _model = model;
    [self setBackgroundColor:_backgroundColor];
    
    self.label.textAlignment = model.textAlignment;
    self.label.text      = model.text;
    self.label.font      = [UIFont fontWithName:@"Zapfino" size:25/_scale];
    self.label.textColor = UIColorFromRGB(0xFF9F00);
    self.label.frame     = CGRectInset(self.bounds,0,0);
    [self addSubview:self.label];
}
- (M80AttributedLabel *)label {

    if (!_label) {
        _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        
    }
    
    return _label;
}
@end
