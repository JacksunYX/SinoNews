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
//+(NSArray *)bg_uniqueKeys{
//    return @[@"name"];
//}


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
    NSInteger count = [self getLocalAttentionSections].count;
    
    [section bg_save];
    GGLog(@"版块已存储至本地");
    if (count==0) {
        //从0到1
        GGLog(@"本地关注版块数量已增至1");
        [kNotificationCenter postNotificationName:SectionsIncreaseNotify object:nil];
    }
}

//移除某个版块
+(void)remove:(MainSectionModel *)section
{
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"name"),bg_sqlValue(section.name)];
    [self bg_delete:nil where:where];
    GGLog(@"版块已从本地移除");
    if ([self getLocalAttentionSections].count<=0) {
        GGLog(@"本地已无关注版块");
        [kNotificationCenter postNotificationName:SectionsReduceNotify object:nil];
    }
}

//新增多个本地关注版块
+(void)addMutilNews:(NSArray <MainSectionModel*>*)sections
{
    NSInteger count = [self getLocalAttentionSections].count;
    [self bg_saveOrUpdateArray:sections];
    GGLog(@"同时存储多个关注版块完成");
    if (count==0) {
        //从0到1
        GGLog(@"本地关注版块数量已增至1");
        [kNotificationCenter postNotificationName:SectionsIncreaseNotify object:nil];
    }
}

//清除所有本地关注版块
+(void)removeAllSections
{
    [self bg_clear:nil];
    GGLog(@"关注版块对象已全部清除");
    GGLog(@"本地已无关注版块");
    [kNotificationCenter postNotificationName:SectionsReduceNotify object:nil];
}


@end
