//
//  BrowsNewsSingleton.m
//  SinoNews
//
//  Created by Michael on 2018/7/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BrowsNewsSingleton.h"

@implementation BrowsNewsSingleton

-(instancetype)singletonInit
{
    // Default settings.
    //读取本地保存数据
    NSArray * newsIdArr = [NSArray bg_arrayWithName:@"newsIdArr"];
    NSArray * postsIdArr = [NSArray bg_arrayWithName:@"postsIdArr"];
    NSArray *domainsArr = [NSArray bg_arrayWithName:@"domainsArr"];
    if (kArrayIsEmpty(newsIdArr)) {
        self.idsArr = [NSMutableArray new];
    }else{
        self.idsArr = [newsIdArr mutableCopy];
    }
    if (kArrayIsEmpty(postsIdArr)) {
        self.postIdsArr = [NSMutableArray new];
    }else{
        self.postIdsArr = [postsIdArr mutableCopy];
    }
    
    if (kArrayIsEmpty(domainsArr)) {
        //为空的话就要创建一个并保存在本地
        [self saveDomainsArr];
    }else{
        self.domainsArr = [domainsArr mutableCopy];
        GGLog(@"domainsArr:%@\ndomain个数：%ld",self.domainsArr,self.domainsArr.count);
    }
    if (!self.parser) {
        GGLog(@"每次重启都会进入表情获取方法");
        GCDAsynGlobal(^{
            [self processLocationEmoji];
        });
    }
    
    NSLog(@"newsIdArr:%ld",self.idsArr.count);
    NSLog(@"postsIdArr:%ld",self.postIdsArr.count);
    return self;
}

//处理本地表情包
-(void)processLocationEmoji
{
    //设置本地表情识别
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    for (int i = 0; i < [WTUtils getEmoticonData].allKeys.count; i ++) {
        NSString *valueString = [NSString stringWithFormat:@"%.0f", ((CGFloat)i)];
        YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"smiley_%@", valueString]];
        image.preloadAllAnimatedImageFrames = YES;
        [mapper setObject:image
                   forKey:[[WTUtils getEmoticonData] allKeysForObject:valueString][0]];
    }
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    parser.emoticonMapper = mapper;
    self.parser = parser;
    GGLog(@"本地表情加载完毕");
}

//保存domainsArr到本地
-(void)saveDomainsArr
{
    self.domainsArr = [NSMutableArray new];
    //添加
    NSArray *arr = @[
                     @"8sJNTq1Ra93/3Pe1wMCGU7gs+jRY7GC2TEZixjnaPXmeBGsy1DqljKwiGSUiLLK1",
                     @"AGQvX7cI+OzqdqBKALwEUFX3tNcaSVizo3b8W7S0/HURoVOM9fTd0pe69NvocoIH",
                     @"LFeTZshfknNSb11/n28gzvtHaoz5Qch9hS+rxjhXlZWcSBqrLmx+yoLj8X9nwT+1",
                     @"3XXO1Mbnhs41NBOWC0FXq/m7YneeLCoQonnvZbKyMbnWudAI9bQQh1jB1OKf6n3+",
                     @"EOqZxWPB+4g5dmdrSUPxirdCjlurOmPxYnFhumRvcIOEcn6PzdqFByBqDurNxfYo",
                     @"ShIPWnO3VbRcSSVckzd9NOQadPBArRWngzeHo+sM+1ei00XGMGEcKFw9ssPFvxzf",
                     @"arHV4xaIawr7inBL07j4TjQObtJ6c03KhzG9EI3c67Ukey+bSqwNdLSPS6ZO33Dm",
                     @"/5/Gh3CMoPQkbMtID++KH4BLP+SPUyb4KpyXSIr5Qde1hhvOyhCZ2BAEQMFh+0T5",
                     @"61fTKncSacU85cwMYYBI7osmRBk7X0tB3693+EiUBVdEEfHN17GVYTDUDio4zzCf",
                     @"Qa2zTtHsqAG9hW1hAOE8G03eRr7EAEKOAPlGrFa0YsQV8asLJg1nQ9u6GKPxc+qs",
                     ];
    for (int i = 0; i < arr.count; i ++) {
        NSString *string = arr[i];
        //        string = [NSString encryptWithText:string];
        [self.domainsArr addObject:string];
    }
    [self.domainsArr bg_saveArrayWithName:@"domainsArr"];
    GGLog(@"domains已保存");
}

//比对获取到的新闻模型中是否有已经阅读过的了
-(NSMutableArray *)compareNewsBrowsHistoryWithBackgroundData:(NSMutableArray *)backgroundData
{
    //遍历
    for (id model in backgroundData) {
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = model;
            model1.hasBrows = [self.idsArr containsObject:@(model1.itemId)];
        }else if ([model isKindOfClass:[TopicModel class]]){
            TopicModel *model1 = model;
            model1.hasBrows = [self.idsArr containsObject:@([model1.topicId integerValue])];
        }
    }
    NSLog(@"newsIdArr:%ld",self.idsArr.count);
    return backgroundData;
}

//比对获取到的帖子模型中是否有已经阅读过的了
-(NSMutableArray *)comparePostsBrowsHistoryWithBackgroundData:(NSMutableArray *)backgroundData
{
    //遍历
    for (SeniorPostDataModel *model in backgroundData) {
        model.hasBrows = [self.postIdsArr containsObject:@(model.postId)];
    }
    NSLog(@"postsIdsArr:%ld",self.postIdsArr.count);
    return backgroundData;
}

//添加一个新闻浏览历史
-(void)addNewsBrowHistory:(NSInteger)itemId
{
    if ([self.idsArr containsObject:@(itemId)]) {
        return;
    }
    [self.idsArr addObject:@(itemId)];
    NSLog(@"idsArr:%ld",self.idsArr.count);
}

//添加一个帖子浏览历史
-(void)addPostsBrowHistory:(NSInteger)postId
{
    if ([self.postIdsArr containsObject:@(postId)]) {
        return;
    }
    [self.postIdsArr addObject:@(postId)];
    NSLog(@"postIdsArr:%ld",self.postIdsArr.count);
}

//保存本地历史
-(void)saveBrowHistory
{
    GGLog(@"idsArr:%ld",self.idsArr.count);
    [self.idsArr bg_saveArrayWithName:@"newsIdArr"];
    [self.postIdsArr bg_saveArrayWithName:@"postsIdArr"];
    NSLog(@"本地浏览历史已保存");
}

//清除浏览过的文章id
-(void)clearBrowsNewsIdArr
{
    GCDAsynGlobal(^{
        [NSArray bg_clearArrayWithName:@"newsIdArr"];
        [NSArray bg_clearArrayWithName:@"postsIdArr"];
        [self.idsArr removeAllObjects];
        [self.postIdsArr removeAllObjects];
        NSLog(@"本地浏览历史已清空");
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ClearBrowsHistory object:nil userInfo:nil];
    });
}

@end
