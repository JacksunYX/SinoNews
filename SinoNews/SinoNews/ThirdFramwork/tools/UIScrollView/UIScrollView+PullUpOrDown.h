//
//  UIScrollView+PullUpOrDown.h
//  SinoNews
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (PullUpOrDown)



/**
 根据页码和模型数组来统一处理上下拉行为
 
 @param page 页码
 @param data 后台获取的数据
 @param dataSource 自身的可变模型数组
 */
-(NSMutableArray *)pullWithPage:(NSInteger)page data:(NSArray *)data dataSource:(NSMutableArray *)dataSource;

@end
