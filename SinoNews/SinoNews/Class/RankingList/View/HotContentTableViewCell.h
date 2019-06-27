//
//  HotContentTableViewCell.h
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/6/26.
//  Copyright © 2019 Sino. All rights reserved.
//排行榜版块-热门内容cell

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nullable const HotContentTableViewCellID;

@interface HotContentTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@end

NS_ASSUME_NONNULL_END
