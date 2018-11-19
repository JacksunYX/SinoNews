//
//  MainSectionModel.m
//  SinoNews
//
//  Created by Michael on 2018/11/19.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "MainSectionModel.h"

@implementation MainSectionModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"subSections" : [MainSectionModel class],
             };
}

//设置唯一约束
+(NSArray *)bg_uniqueKeys{
    return @[@"name"];
}


//获取本地关注版块列表
+(NSMutableArray *)getLocalAttentionSections
{
    NSArray* finfAlls = [self bg_findAll:nil];
    GGLog(@"关注版块查询完毕");
    return finfAlls.mutableCopy;
}

//新增一个本地关注版块
+(void)addANew:(MainSectionModel *)section
{
    [section bg_save];
    GGLog(@"关注版块对象已存储完成");
}

//新增多个本地关注版块
+(void)addMutilNews:(NSArray <MainSectionModel*>*)sections
{
    [self bg_saveOrUpdateArray:sections];
    GGLog(@"同时存储多个关注版块完成");
}

//清除所有本地关注版块
+(void)removeAllSections
{
//    [self bg_clearAsync:nil complete:^(BOOL isSuccess) {
//        
//    }];
    [self bg_clear:nil];
    GGLog(@"关注版块对象已全部清除");
}


@end
