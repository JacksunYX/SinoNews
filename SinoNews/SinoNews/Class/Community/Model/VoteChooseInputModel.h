//
//  VoteChooseInputModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/9.
//  Copyright © 2018 Sino. All rights reserved.
//
//投票编辑页面，投票子选项的模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoteChooseInputModel : NSObject
@property (nonatomic,strong) NSString *content;//投票选项内容
@property (nonatomic,assign) NSInteger chooseId;//选项id
@property (nonatomic,assign) BOOL isSelected;  //是否已被选
//隐藏选择图标
@property (nonatomic,assign) BOOL hiddenSelectIcon;
@property (nonatomic,assign) BOOL hiddenVoteResult;
@property (nonatomic,assign) NSInteger havePolls;//占票数
@property (nonatomic,assign) NSInteger totalPolls;//总票数

@end

NS_ASSUME_NONNULL_END
