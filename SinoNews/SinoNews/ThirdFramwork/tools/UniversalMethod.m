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
//标记
@property (nonatomic,assign) BOOL change1;
@property (nonatomic,assign) BOOL change2;

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
    UniversalMethod *manager = [UniversalMethod new];
    
    //标记
//    BOOL changed1 = NO;
//    BOOL changed2 = NO;
    
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    NSMutableArray *finalAttentionArr = [NSMutableArray new];
    NSMutableArray *finalUnattentionArr = [NSMutableArray new];
    //1.本地有缓存，开始比对
    if (!kArrayIsEmpty(columnArr)) {
        //分别取出已关注、未关注频道数组
        NSMutableArray *attentionArr = [NSMutableArray arrayWithArray:columnArr[0]];
        NSMutableArray *unAttentionArr = columnArr[1];
        GGLog(@"1.开始比对频道数组");
        //1⃣️先拿已关注数组与后台数组比对
        finalAttentionArr = [self compareAttentionArr1:attentionArr arr2:serverData changed:manager];
        
        //获取除去已关注频道，剩余的频道
        NSMutableArray *residuumArr = [serverData mutableCopy];
        [residuumArr removeObjectsInArray:finalAttentionArr];
        //2⃣️再拿未关注数组与剩余频道数组比对
        finalUnattentionArr = [self compareUnattentionArr1:unAttentionArr arr2:residuumArr changed:manager];
        
        GGLog(@"4.比对完毕~");
    }else{
        //2.本地无缓存，直接丢弃
        GGLog(@"本地缓存频道数组为空！");
        manager.change1 = YES;
        manager.change2 = YES;
    }
    
    //回调
    if (reason) {
        reason(manager.change1,manager.change2,finalAttentionArr,finalUnattentionArr);
    }
}

//比对已关注数组
+(NSMutableArray *)compareAttentionArr1:(NSArray <XLChannelModel *>*)arr1
                                   arr2:(NSArray <XLChannelModel *>*)arr2
                                changed:(UniversalMethod *)manager
{
    NSMutableArray *finalArr = [NSMutableArray new];
    //先拿已关注数组与后台数组比对
    //遍历
    for (int i = 0; i< arr1.count; i ++) {
        XLChannelModel *model = arr1[i];
        //1.与总数据比对
        for (int j = 0; j < arr2.count; j ++) {
            XLChannelModel *model2 = arr2[j];
            //2.如果id相同,说明这个频道本地有缓存
            if (CompareString(model.channelId, model2.channelId)) {
                //直接替换成后台最新的
                if (!CompareString(model.channelName, model2.channelName)) {
                    manager.change1 = YES;   //如果有名称不同的标记为有变化
                }
                [finalArr addObject:model2];
                break;
            }else if (j == arr2.count - 1){ //某个对象在arr2中没有找到相同id的，标记为有变化
                manager.change1 = YES;
            }
        }
        
    }

    GGLog(@"2.关注数组比对完毕~");
    //最后得到的就是比对后的已关注数组了
    return finalArr;
}

//比对未关注数组
+(NSMutableArray *)compareUnattentionArr1:(NSArray <XLChannelModel *>*)arr1
                                     arr2:(NSArray <XLChannelModel *>*)arr2
                                  changed:(UniversalMethod *)manager
{
    NSMutableArray *finalArr = [NSMutableArray new];
    //~~遍历后台的未关注频道
    for (int i = 0; i< arr2.count; i ++) {
        XLChannelModel *model = arr2[i];
        //每次循环，重置标记
        model.isNew = YES;
        manager.change2 = YES;
        //1.与本地数组比对
        for (XLChannelModel *model2 in arr1) {
            //2.如果id相同,说明这个频道本地有缓存
            if (CompareString(model.channelId, model2.channelId)) {
                
                //3.如果名称也未变化，撤销new的记号
                if (CompareString(model.channelName, model2.channelName)) {
                    model.isNew = NO;
                    manager.change2 = NO;    //只有当id和名称都无变化才算
                }
                
                break;
            }
            
        }
        //替换成后台最新的
        [finalArr addObject:model];
        
    }
    //~~还有一种情况，未关注数组只是在个数上减少了
    if (manager.change2 == NO&&arr2.count!=finalArr.count) {
        GGLog(@"未关注频道个数减少了");
        manager.change2 = YES;   //暂时也划定为变化了，提醒用户
    }
    GGLog(@"3.未关注数组比对完毕~");
    return finalArr;
}


+(NSString *)getTopLoadTimeWithData:(NSArray *)data
{
    NSString *loadTime = @"";
    if (data.count>0) {
        int i = 0;
        while (1) {
            id model = data[i];
            //先转换成字典
            NSMutableDictionary *modelDic = [model mj_keyValues];
            //如果是广告、专题、置顶就跳过
            if ([model isKindOfClass:[ADModel class]]||[model isKindOfClass:[TopicModel class]]||CompareString(modelDic[@"labelName"], @"置顶")) {
                //防止越界
                if (i == data.count - 1) {
                    GGLog(@"没有更多数据了");
                    break;
                }else{
                    i ++;
                }
            }else{  //不是广告，则拿到时间节点
                
                loadTime = modelDic[@"createStamp"];
                break;
            }
        }
    }
    return loadTime;
}

+(NSString *)getBottomLoadTimeWithData:(NSArray *)data
{
    NSString *loadTime = @"";
    if (data.count>0) {
        NSUInteger i = data.count - 1;
        while (1) {
            id model = data[i];
            //先转换成字典
            NSMutableDictionary *modelDic = [model mj_keyValues];
            //如果是广告或者专题，就跳过
            if ([model isKindOfClass:[ADModel class]]||[model isKindOfClass:[TopicModel class]]||CompareString(modelDic[@"labelName"], @"置顶")) {
                //防止越界
                if (i == 0) {
                    GGLog(@"没有更多数据了");
                    break;
                }else{
                    i --;
                }
            }else{  //不是广告，则拿到时间节点
                
                loadTime = modelDic[@"createStamp"];
                break;
            }
        }
    }
    return loadTime;
}















@end
