//
//  SeniorPostDataModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeniorPostDataModel : NSObject
//帖子标题
@property (nonatomic,strong) NSString *postTitle;
//帖子内容
@property (nonatomic,strong) NSString *postContent;
//所包含的子元素数组
@property (nonatomic,strong) NSMutableArray <SeniorPostingAddElementModel *>*dataSource;
//@的用户数组
@property (nonatomic,strong) NSMutableArray *people;

//发布者相关
@property (nonatomic,strong) NSString *avatar;//头像
@property (nonatomic,strong) NSString *author;//发布者
@property (nonatomic,assign) NSInteger userId;//id
@property (nonatomic,strong) NSString *createTime;//发布时间
@property (nonatomic,assign) BOOL isAttention;//是否关注
@property (nonatomic,assign) BOOL isCollection;//是否收藏
@property (nonatomic,assign) BOOL hasPraised;//是否点赞
@property (nonatomic,assign) NSInteger praiseCount;//点赞数
@end

NS_ASSUME_NONNULL_END
