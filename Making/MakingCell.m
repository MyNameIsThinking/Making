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
    self.backgroundColor = _BGColor;
    self.label.textAlignment = model.textAlignment;
    self.label.text      = model.text;
    self.label.font      = [UIFont fontWithName:@"Zapfino" size:25/_scale];
    self.label.textColor = [UIColor redColor];
    self.label.backgroundColor = _BGColor;
    self.label.frame     = CGRectInset(self.bounds,20/_scale,20/_scale);
    [self addSubview:self.label];
}
- (M80AttributedLabel *)label {

    if (!_label) {
        _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        
    }
    
    return _label;
}
@end
