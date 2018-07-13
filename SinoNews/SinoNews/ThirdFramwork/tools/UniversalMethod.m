//
//  UniversalMethod.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//通用方法总和


#import "UniversalMethod.h"
#import "XLChannelModel.h"

#import "NewsDetailViewController.h"
#import "TopicViewController.h"
#import "RankDetailViewController.h"

@interface UniversalMethod ()

@end

@implementation UniversalMethod

//根据广告模型跳转到不同界面
+(void)jumpWithADModel:(ADModel *)model
{
    UIViewController *vc;
    switch ([model.redirectType integerValue]) {
        case 1: //新闻
        {
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = [model.advertsId integerValue];
            vc = ndVC;
        }
            break;
        case 2: //专题
        {
            TopicViewController *tVC = [TopicViewController new];
            tVC.topicId = [model.advertsId integerValue];
            vc = tVC;
        }
            break;
        case 5: //公司
        {
            RankDetailViewController *rdVC = [RankDetailViewController new];
            rdVC.companyId = model.advertsId;
            vc = rdVC;
        }
            break;
        case 7: //外链
        {
            [[UIApplication sharedApplication] openURL:UrlWithStr(model.redirectUrl)];
        }
            break;
            
        default:
            return;
            break;
    }
    
    [[HttpRequest currentViewController].navigationController pushViewController:vc animated:YES];
}

//频道比对
+(void)compareChannels:(NSArray *)serverData
          reasonAction:(void (^)(BOOL changed1 ,BOOL changed2, NSArray *attentionArr, NSArray *unAttentionArr))reason
{
    //标记
    BOOL changed1 = NO;
    BOOL changed2 = NO;
    
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    
    //1.本地有缓存，开始比对
    if (!kArrayIsEmpty(columnArr)) {
        //分别取出已关注、未关注频道数组
        NSMutableArray *attentionArr = [NSMutableArray arrayWithArray:columnArr[0]];
        NSMutableArray *unAttentionArr = columnArr[1];
        //1⃣️先拿已关注数组与后台数组比对
        NSMutableArray *finalAttentionArr = [self compareAttentionArr1:attentionArr arr2:serverData changed:changed1];
        //获取除去已关注频道，剩余的频道
        NSMutableArray *residuumArr = [serverData mutableCopy];
        [residuumArr removeObjectsInArray:finalAttentionArr];
        //2⃣️再拿未关注数组与剩余频道数组比对
        NSMutableArray *finalUnattentionArr = [self compareUnattentionArr1:unAttentionArr arr2:residuumArr changed:changed2];
        
        //回调
        if (reason) {
            reason(changed1,changed2,finalAttentionArr,finalUnattentionArr);
        }
        
    }else{
        //2.本地无缓存，直接丢弃
        GGLog(@"本地缓存频道数组为空！");
    }
}

//比对已关注数组
+(NSMutableArray *)compareAttentionArr1:(NSArray <XLChannelModel *>*)arr1
                                   arr2:(NSArray <XLChannelModel *>*)arr2
                                changed:(BOOL)change
{
    NSMutableArray *finalArr = [NSMutableArray new];
    //先拿已关注数组与后台数组比对
    //遍历
    for (int i = 0; i< arr1.count; i ++) {
        XLChannelModel *model = arr1[i];
        //与总数据比对
        for (XLChannelModel *model2 in arr2) {
            //如果id相同说明这个频道还存在
            if (CompareString(model.channelId, model2.channelId)) {
                //直接替换成后台最新的
                if (!CompareString(model.channelName, model2.channelName)) {
                    change = YES;   //说明有更新
                }
                [finalArr addObject:model2];
                break;
            }
            
        }
        
    }
    //最后得到的就是比对后的已关注数组了
    return finalArr;
}

//比对未关注数组
+(NSMutableArray *)compareUnattentionArr1:(NSArray <XLChannelModel *>*)arr1
                                     arr2:(NSArray <XLChannelModel *>*)arr2
                                  changed:(BOOL)change
{
    NSMutableArray *finalArr = [NSMutableArray new];
    //遍历后台的未关注频道
    for (int i = 0; i< arr2.count; i ++) {
        XLChannelModel *model = arr2[i];
        model.isNew = YES;  //先标记为新加入的
        change = YES;   //每次循环，重置
        //与本地数组比对
        for (XLChannelModel *model2 in arr1) {
            //如果id相同说明这个本地有缓存这个频道
            if (CompareString(model.channelId, model2.channelId)) {
                
                //比对一下，如果名称也未变化，撤销new的记号
                if (CompareString(model.channelName, model2.channelName)) {
                    model.isNew = NO;
                    change = NO;    //只有当id和名称都无变化才算
                }
                
                break;
            }
            
        }
        //替换成后台最新的
        [finalArr addObject:model];
        
    }
    
    return finalArr;
}


@end
