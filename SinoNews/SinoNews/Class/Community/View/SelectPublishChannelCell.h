//
//  SelectPublishChannelCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//
//选择发表到的版块自定义cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nullable const SelectPublishChannelCellID;
@interface SelectPublishChannelCell : UITableViewCell
//默认无标记，1为有标记
@property (nonatomic,assign) NSInteger type;
-(void)setTitle:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
