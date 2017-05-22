//
//  CountView.h
//  Making
//
//  Created by rico on 2016/4/2.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"

@interface CountView : UIView

@property (nonatomic, retain) UICollectionView *collectionView;

- (id)initWithMainModels:(NSMutableArray *)mainModels mainView:(MainViewController *)mainView;
@end
