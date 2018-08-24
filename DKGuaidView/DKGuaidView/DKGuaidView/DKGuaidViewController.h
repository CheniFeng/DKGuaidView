//
//  DKGuaidViewController.h
//  DKGuaidView
//
//  Created by 雪凌 on 2018/8/24.
//  Copyright © 2018年 雪凌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKGuaidViewController : UIViewController

/**
 *  是否显示页数指示器
 */
@property (nonatomic, assign, readwrite) BOOL showPageIndicator;


/**
 *  引导图片的名称数组
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *imageNames;


/**
 *  点击进入时的回调
 */
@property (nonatomic, copy, nullable) dispatch_block_t shouldHiddenBlock;

@end

@interface DKGuaidViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
