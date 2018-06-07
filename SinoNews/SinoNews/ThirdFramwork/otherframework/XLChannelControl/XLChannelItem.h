//
//  XLChannelItem.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLChannelItem : UICollectionViewCell
//标题
@property (nonatomic, copy) NSString *title;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否被固定
@property (nonatomic, assign) BOOL isFixed;

//是否可以被移除
@property (nonatomic, assign) BOOL canDelete;

//是否是最新
@property (nonatomic, assign) BOOL isNew;

@end
