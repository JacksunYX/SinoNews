//
//  SeniorPostDataModel.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostDataModel.h"

@implementation SeniorPostDataModel

-(instancetype)init
{
    if (self == [super init]) {
        _dataSource = [NSMutableArray new];
    }
    return self;
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"dataSource":[SeniorPostingAddElementModel class],
             @"voteSelects":[VoteChooseInputModel class],
             };
}

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

//获取本地草稿列表
+(NSMutableArray *)getLocalDrafts
{
    NSArray* finfAlls = [self bg_findAll:nil];
    GGLog(@"本地草稿查询完毕");
    return finfAlls.mutableCopy;
}

//新增一个草稿
+(void)addANewDraft:(SeniorPostDataModel *)postModel
{
    //先删除
    [self remove:postModel];
    //获取当前时间戳字符串作为存储时的标记
    postModel.saveTime = [NSString currentTimeStr];
    //再添加
    [postModel bg_save];
    
    LRToast(@"草稿保存完毕");
}

//移除某个草稿
+(void)remove:(SeniorPostDataModel *)postModel
{
    NSInteger count = [self bg_count:nil where:nil];
    if (count>0) {
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"saveTime"),bg_sqlValue(postModel.saveTime)];
        //删除
        [self bg_delete:nil where:where];
        GGLog(@"草稿已删除");
    }else{
        GGLog(@"已无草稿可删除");
    }
    
}

//清除所有草稿
+(void)removeAllDrafts
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


//检查当前模型是否有需要保存的数据
-(BOOL)isContentNeutrality
{
    BOOL have = NO;
    if (![NSString isEmpty:self.postTitle]) {
        have = YES;
    }else if (![NSString isEmpty:self.postContent]){
        have = YES;
    }else{
        //最后判断子内容是否有空的
        if (self.dataSource.count>0) {
            have = YES;
        }else if (self.voteSelects.count>0){
            have = YES;
        }
    }
    return have;
}

@end
