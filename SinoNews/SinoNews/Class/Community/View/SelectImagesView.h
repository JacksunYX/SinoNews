//
//  SelectImagesView.h
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//
//自定义选择图片的视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectImagesView : UIView
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, assign) NSInteger numPerRow;  //每行个数
@property (nonatomic, assign) NSInteger maxNum;     //最多显示数目
@end

NS_ASSUME_NONNULL_END
