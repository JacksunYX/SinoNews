//
//  HomePageModel.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageModel.h"

//排序函数
NSComparator cmptr = ^(HomePageModel *obj1, HomePageModel *obj2){
    if ([obj1.saveTimeStr integerValue] > [obj2.saveTimeStr integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1.saveTimeStr integerValue] < [obj2.saveTimeStr integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};


@implementation HomePageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"news_id" : @"id"};
}

+(void)saveWithNewsModel:(NormalNewsModel *)model
{
    //将新闻模型转换为首页列表的模型来保存
    HomePageModel *model2 = [HomePageModel new];
    model2.itemTitle = model.newsTitle;
    model2.itemType = model.itemType;
    model2.itemId = model.itemId;
    model2.images = model.images;
    
    model2.username = model.author;
//    model2.commentCount = model.commentCount; //暂时不显示评论数
    model2.viewCount = model.viewCount;
    //保存
    [self saveWithModel:model2];
}

//存储数据
+(void)saveWithModel:(HomePageModel *)model
{
    //获取当前时间戳字符串作为存储时的标记
    model.saveTimeStr = [NSString currentTimeStr];
    //先查找
    NSArray* findAlls = [self bg_findAll:nil];
    if (!kArrayIsEmpty(findAlls)) {
        for (HomePageModel *dic in findAlls) {
            if (dic.itemId == model.itemId) {
                //先删除
                NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"itemId"),bg_sqlValue(@(model.itemId))];
                [self bg_delete:nil where:where];
                break;
            }
        }
    }
    //再添加
    [model bg_saveAsync:^(BOOL isSuccess) {
        GGLog(@"浏览历史插入了新的数据");
    }];
}

//获取本书存储数据
+(NSArray *)getCurrentHistory
{
    //查找返回即可
    NSArray* findAlls = [self bg_findAll:nil];
    return findAlls;
}

+(NSArray *)getSortedHistory
{
//    NSMutableArray *arr1 = [NSMutableArray new];
//    NSMutableArray *arr2 = [NSMutableArray new];
//    NSMutableArray *arr3 = [NSMutableArray new];
//    [arr1 addObject:arr2];
//    [arr1 addObject:arr3];
//    [arr2 addObjectsFromArray:@[@"1",@"22"]];
//    [arr3 addObjectsFromArray:@[@"asdasd",@"拉倒吧"]];
//    arr2 = [NSMutableArray new];
//    GGLog(@"arr1:%@",arr1);
    
    //先查找
    NSArray* findAlls = [self bg_findAll:nil];
    NSMutableArray *dataArr;
    
    if (!kArrayIsEmpty(findAlls)) {
        //倒序一下
        findAlls = (NSArray *)[[findAlls reverseObjectEnumerator] allObjects];
        dataArr = [NSMutableArray new];
        
        HomePageModel *sortModel = [findAlls firstObject];
        NSMutableArray *sectionArr = [NSMutableArray new];
        [sectionArr addObject:sortModel];
        [dataArr addObject:sectionArr];
        
        for (int j = 1; j < findAlls.count; j ++) {
            HomePageModel *model = findAlls[j];
            //如果2个时间戳转化成的时间字符串相同，说明是同一天的
            NSString *time1 = [NSString getDateStringWithTimeStr:model.saveTimeStr];
            NSString *time2 = [NSString getDateStringWithTimeStr:sortModel.saveTimeStr];
            if (CompareString(time1, time2)) {
                [sectionArr addObject:model];
            }else{  //反之，则是其他时间的
                sectionArr = [NSMutableArray new];
                sortModel = model;
                [sectionArr addObject:sortModel];
                [dataArr addObject:sectionArr];
            }
        }
        
    }
    
    GGLog(@"dataArr:%@",dataArr);
    
    return dataArr;
}

//清除缓存
+(void)clearLocaHistory
{
    GCDAsynGlobal(^{
        [self bg_clear:nil];
    });
}


@end
