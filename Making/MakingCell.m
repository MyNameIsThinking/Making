//
//  MakingCell.m
//  Making
//
//  Created by rico on 2016/3/30.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "MakingCell.h"
#import <CoreText/CoreText.h>
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
    self.models = nil;
    self.label = nil;
}
- (void)showWithModels:(NSArray *)models {
    _models = models;
    [self setBackgroundColor:_backgroundColor];
    [self addSubview:self.label];
}
- (M80AttributedLabel *)label {

    if (!_label) {
        _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _label.text      = @"Hello M80AttributedLabel";
        _label.font      = [UIFont fontWithName:@"Zapfino" size:25];
        _label.textColor = UIColorFromRGB(0xFF9F00);
        _label.frame     = CGRectInset(self.bounds,0,0);
    }
    
    return _label;
}
@end
