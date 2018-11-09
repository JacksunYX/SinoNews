//
//  VotePostingTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/9.
//  Copyright © 2018 Sino. All rights reserved.
//
//投票发帖自定义cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const VotePostingTableViewCellID;
@interface VotePostingTableViewCell : UITableViewCell
//移除回调
@property (nonatomic,copy) void(^deleteBlock)(void);
//输入回调
@property (nonatomic,copy) void(^inputBlock)(NSString *inputString);
-(void)setSortNum:(NSInteger)num;
-(void)setContent:(NSString *)contentString;

@end

NS_ASSUME_NONNULL_END
