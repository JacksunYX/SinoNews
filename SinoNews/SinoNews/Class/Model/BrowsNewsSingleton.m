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
    NSArray *domainsArr = [NSArray bg_arrayWithName:@"domainsArr"];
    if (kArrayIsEmpty(newsIdArr)) {
        self.idsArr = [NSMutableArray new];
    }else{
        self.idsArr = [newsIdArr mutableCopy];
    }
    if (kArrayIsEmpty(domainsArr)) {
        //为空的话就要创建一个并保存在本地
        [self saveDomainsArr];
    }else{
        self.domainsArr = [domainsArr mutableCopy];
        GGLog(@"domainsArr:%@\ndomain个数：%ld",self.domainsArr,self.domainsArr.count);
    }
    
    GGLog(@"idsArr:%ld",self.idsArr.count);
    return self;
}

//保存domainsArr到本地
-(void)saveDomainsArr
{
    self.domainsArr = [NSMutableArray new];
    //添加
    NSArray *arr = @[
                     @"https://qsl.bravetroops.biz",
                     @"https://www.sadasd2.info",
                     @"https://www.d43d439.info",
                     @"https://www.243223ew.info",
                     @"https://www.fsfs2df.info",
                     @"https://www.f43th7.info",
                     @"https://www.32r3rew.info",
                     @"https://www.32e23e.info",
                     @"https://www.dsfs6dafs.info",
                     @"https://www.g56y65h.info",
                     ];
    for (int i = 0; i < arr.count; i ++) {
        NSString *string = arr[i];
        [self.domainsArr addObject:[NSString encryptWithText:string]];
    }
    [self.domainsArr bg_saveArrayWithName:@"domainsArr"];
    GGLog(@"domains已保存");
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
