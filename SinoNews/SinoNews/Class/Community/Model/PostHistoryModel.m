//
//  PostHistoryModel.m
//  SinoNews
//
//  Created by Michael on 2018/11/27.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PostHistoryModel.h"

//帖子浏览历史表单

@implementation PostHistoryModel

#pragma mark --浏览历史相关

//设置唯一约束(修改的时间)
+(NSArray *)bg_uniqueKeys{
    return @[@"saveTime"];
}

+(NSDictionary *)bg_objectClassInArray
{
    return @{
             @"dataSource":[SeniorPostingAddElementModel class],
             @"voteSelects":[VoteChooseInputModel class],
             };
}

//存储浏览历史
+(void)saveHistory:(SeniorPostDataModel *)model
{
    PostHistoryModel *newModel = [self processModel1:model];
    //先查找
    NSInteger count = [self bg_count:nil where:nil];
    if (count>0) {
        //先删除
        [self removeHistory:newModel];
    }
    //获取当前时间戳字符串作为存储时的标记
    newModel.saveTime = [NSString currentTimeStr];
    
    //再添加
    [newModel bg_saveAsync:^(BOOL isSuccess) {
        GGLog(@"帖子浏览历史插入了新的数据");
    }];
}

//模型转换1
+(PostHistoryModel *)processModel1:(SeniorPostDataModel *)model
{
    NSDictionary *dic = [model mj_JSONObject];
    PostHistoryModel *newModel = [PostHistoryModel mj_objectWithKeyValues:dic];
    return newModel;
}

//模型转换2
+(SeniorPostDataModel*)processModel2:(PostHistoryModel *)model
{
    NSDictionary *dic = [model mj_JSONObject];
    SeniorPostDataModel *newModel = [SeniorPostDataModel mj_objectWithKeyValues:dic];
    return newModel;
}

//移除某个历史
+(void)removeHistory:(PostHistoryModel *)postModel
{
    NSInteger count = [self bg_count:nil where:nil];
    if (count>0) {
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"saveTime"),bg_sqlValue(postModel.saveTime)];
        //删除
        [self bg_delete:nil where:where];
        GGLog(@"帖子历史已删除");
    }else{
        GGLog(@"已无帖子历史可删除");
    }
    
}

//获取已分组后的数据
+(NSArray *)getSortedHistory
{
    //先查找
    NSArray* findAlls = [self bg_findAll:nil];
    NSMutableArray *dataArr;
    
    if (!kArrayIsEmpty(findAlls)) {
        //倒序一下
        findAlls = (NSMutableArray *)[[findAlls reverseObjectEnumerator] allObjects];
        NSMutableArray *newArr = [NSMutableArray new];
        //转换模型
        for (PostHistoryModel *model in findAlls) {
            [newArr addObject:[self processModel2:model]];
        }
        dataArr = [NSMutableArray new];
        
        SeniorPostDataModel *sortModel = [newArr firstObject];
        NSMutableArray *sectionArr = [NSMutableArray new];
        [sectionArr addObject:sortModel];
        [dataArr addObject:sectionArr];
        
        for (int j = 1; j < newArr.count; j ++) {
            SeniorPostDataModel *model = newArr[j];
            //如果2个时间戳转化成的时间字符串相同，说明是同一天的
            NSString *time1 = [NSString getDateStringWithTimeStr:model.saveTime];
            NSString *time2 = [NSString getDateStringWithTimeStr:sortModel.saveTime];
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
+(void)clearLocalHistory
{
    NSInteger count = [self bg_count:nil where:nil];
    //如果有数据再去清除
    if (count>0) {
        [self bg_clear:nil];
        GGLog(@"草稿箱清空完毕");
    }else{
        GGLog(@"已无草稿可清理");
    }
}

@end
