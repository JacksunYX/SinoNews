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
    NSArray* newsIdArr = [NSArray bg_arrayWithName:@"newsIdArr"];
    if (kArrayIsEmpty(newsIdArr)) {
        self.idsArr = [NSMutableArray new];
    }else{
        self.idsArr = [newsIdArr mutableCopy];
    }
    GGLog(@"idsArr:%ld",self.idsArr.count);
    return self;
}

//比对获取到的新闻模型中是否有已经阅读过的了
-(NSMutableArray *)compareBrowsHistoryWithBackgroundData:(NSMutableArray *)backgroundData
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
    GGLog(@"idsArr:%ld",self.idsArr.count);
    return backgroundData;
}

//添加一个历史
-(void)addBrowHistory:(NSInteger)itemId
{
    if ([self.idsArr containsObject:@(itemId)]) {
        return;
    }
    [self.idsArr addObject:@(itemId)];
    GGLog(@"idsArr:%ld",self.idsArr.count);
}

//保存本地历史
-(void)saveBrowHistory
{
    GGLog(@"idsArr:%ld",self.idsArr.count);
    [self.idsArr bg_saveArrayWithName:@"newsIdArr"];
}

//清除浏览过的文章id
-(void)clearBrowsNewsIdArr
{
    GCDAsynGlobal(^{
        [NSArray bg_clearArrayWithName:@"newsIdArr"];
        [self.idsArr removeAllObjects];
        GGLog(@"idsArr:%ld",self.idsArr.count);
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ClearBrowsHistory object:nil userInfo:nil];
    });
}

@end
