//
//  ChangeTypeManager.h
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextModel.h"

@interface ChangeTypeManager : NSObject
@property (nonatomic, retain) NSArray *xmls;
@property (nonatomic, retain) NSArray *colors;
+ (ChangeTypeManager *)shareInstance;
@end

@interface XMLUtil : NSObject

@property (nonatomic, retain) CoreTextModel *model;
- (id)initWithFileName:(NSString *)name;
@end