//
//  UIImage+Save.m
//  Making
//
//  Created by rico on 2016/4/9.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "UIImage+Save.h"
#import <objc/runtime.h>

static char const * const kSuccessBlockKey = "UIImageOnSaveSuccessBlock";
static char const * const kErrorBlockKey = "UIImageOnSaveErrorBlock";

@implementation UIImage (Save)

@dynamic successBlock;
@dynamic errorBlock;

- (void)saveToPhotosAlbumOnSuccess:(UIImageOnSaveSuccessBlock)successBlock
                           onError:(UIImageOnSaveErrorBlock)errorBlock
{
    self.successBlock = successBlock;
    self.errorBlock = errorBlock;
    
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImageOnSaveSuccessBlock)successBlock {
    return objc_getAssociatedObject(self, kSuccessBlockKey);
}

- (void)setSuccessBlock:(UIImageOnSaveSuccessBlock)successBlockNew {
    objc_setAssociatedObject(self, kSuccessBlockKey, successBlockNew, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageOnSaveErrorBlock)errorBlock {
    return objc_getAssociatedObject(self, kSuccessBlockKey);
}

- (void)setErrorBlock:(UIImageOnSaveErrorBlock)errorBlockNew {
    objc_setAssociatedObject(self, kErrorBlockKey, errorBlockNew, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Private

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        if (self.errorBlock) {
            self.errorBlock();
        }
    } else {
        if (self.successBlock) {
            self.successBlock();
        }
    }
}


@end
