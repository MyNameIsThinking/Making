//
//  UIImage+Save.h
//  Making
//
//  Created by rico on 2016/4/9.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImageOnSaveSuccessBlock)(void);
typedef void (^UIImageOnSaveErrorBlock)(void);

@interface UIImage (Save)

@property (nonatomic, strong) UIImageOnSaveSuccessBlock successBlock;
@property (nonatomic, strong) UIImageOnSaveErrorBlock errorBlock;

/*
 * Save the image instance to which the message is sent to the user
 * photos album.
 *
 * @param UIImageOnSaveSuccessBlock     To be called on success.
 * @param UIImageOnSaveErrorBlock       To be called on error.
 *
 */
- (void)saveToPhotosAlbumOnSuccess:(UIImageOnSaveSuccessBlock)successBlock
                           onError:(UIImageOnSaveErrorBlock)errorBlock;

@end
