//
//  MainSectionModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/19.
//  Copyright © 2018 Sino. All rights reserved.
//
//主/子版块模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainSectionModel : NSObject
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger postCount;//发帖数
@property (nonatomic,assign) NSInteger sectionId;//id
@property (nonatomic,strong) NSMutableArray <MainSectionModel *>*subSections;//包含的子版块数组
@property (nonatomic,assign) BOOL isAttentioned;//是否关注
@property (nonatomic,assign) BOOL haveUnFold;   //是否展开

//获取本地关注版块列表
+(NSMutableArray *)getLocalAttentionSections;
//新增一个本地关注版块
+(void)addANew:(MainSectionModel *)section;
//新增多个本地关注版块
+(void)addMutilNews:(NSArray <MainSectionModel*>*)sections;
//清除所有本地关注版块
+(void)removeAllSections;

@end

NS_ASSUME_NONNULL_END
