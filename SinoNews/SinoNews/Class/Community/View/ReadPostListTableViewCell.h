//
//  ReadPostListTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//
//读帖界面列表cell

#import <UIKit/UIKit.h>

extern NSString * _Nullable const ReadPostListTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ReadPostListTableViewCell : UITableViewCell
@property (nonatomic,strong) SeniorPostDataModel *model;
-(void)setData:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
