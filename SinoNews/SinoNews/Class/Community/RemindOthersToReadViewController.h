//
//  RemindOthersToReadViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//
//@其他人一级界面/2级界面

#import "BaseViewController.h"
#import "RemindSelectTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemindOthersToReadViewController : BaseViewController
//1级界面回调
@property (nonatomic,copy) void(^selectBlock)(NSMutableArray *selectArr);
//2级界面回调
@property (nonatomic,copy) void(^select2Block)(NSMutableArray *selectArr,NSMutableArray *deselectArr);
//选中要@的用户数据数组(1级)
@property (nonatomic,strong) NSMutableArray *selectedArr;
//选中要@的用户数据数组(2级页面接受到在1级页面选中的@用户数组)
@property (nonatomic,strong) NSMutableArray *selected2Arr;
@property (nonatomic,assign) NSInteger type;//0默认1级，其他为2级
@property (nonatomic,strong) NSString *keyword;//查询关键字

@end

NS_ASSUME_NONNULL_END
