//
//  VotePostingTableViewCell2.h
//  SinoNews
//
//  Created by Michael on 2018/11/9.
//  Copyright © 2018 Sino. All rights reserved.
//
//投票发帖自定义cell2

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const VotePostingTableViewCell2ID;
@interface VotePostingTableViewCell2 : UITableViewCell
//0无选择按钮 1有选择按钮
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) void(^switchBlock)(BOOL switchisOn);

-(void)setLeftTitle:(NSString *)title;
-(void)setRightTitle:(NSString *)title;
-(void)setRightSwitchOn:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
