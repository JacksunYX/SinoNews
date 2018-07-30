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
            ndVC.newsId = model.redirectParameter;
            vc = ndVC;
        }
            break;
        case 2: //专题
        {
            TopicViewController *tVC = [TopicViewController new];
            tVC.topicId = model.redirectParameter;
            vc = tVC;
        }
            break;
        case 5: //公司
        {
            RankDetailViewController *rdVC = [RankDetailViewController new];
            rdVC.companyId = [NSString stringWithFormat:@"%ld",model.redirectParameter];
            vc = rdVC;
        }
            break;
        case 6: //app下载地址
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

////获取上拉加载更多的时间节点
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

////获取下拉加载更多的时间节点
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

//将新闻数据处理成为数组并返回
+(NSMutableArray *)getProcessNewsData:(id)response
{
    NSMutableArray *dataArr = [NSMutableArray new];
    for (NSDictionary *dic in response) {
        NSInteger itemType = [dic[@"itemType"] integerValue];
        if (itemType>=100&&itemType<200) {  //新闻
            HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
            [dataArr addObject:model];
        }else if (itemType>=200&&itemType<300) {    //专题
            TopicModel *model = [TopicModel mj_objectWithKeyValues:dic];
            [dataArr addObject:model];
        }else if (itemType>=300&&itemType<400){     //广告
            ADModel *model = [ADModel mj_objectWithKeyValues:dic];
            [dataArr addObject:model];
        }else if (itemType>=400&&itemType<500){     //投票
            HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
            [dataArr addObject:model];
        }else if (itemType>=500&&itemType<600){     //问答
            HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
            [dataArr addObject:model];
        }
    }
    return dataArr;
}

//根据不同的文章模型，跳转到指定的界面
+(NSInteger)pushToAssignVCWithNewmodel:(id)model
{
    UIViewController *pushVC;
    NSInteger itemId = 0;
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = model;
        itemId = model1.itemId;
        if (model1.itemType>=400&&model1.itemType<500) { //投票
            VoteViewController *vVC = [VoteViewController new];
            vVC.newsId = model1.itemId;
            pushVC = vVC;
        }else if (model1.itemType>=500&&model1.itemType<600) { //问答
            CatechismViewController *cVC = [CatechismViewController new];
            cVC.news_id = model1.itemId;
            pushVC = cVC;
        }else{
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = model1.itemId;
            pushVC = ndVC;
        }
        
        
        //        PayNewsViewController *pnVC = [PayNewsViewController new];
        //        [self.navigationController pushViewController:pnVC animated:YES];
        
    }else if ([model isKindOfClass:[TopicModel class]]){
        TopicModel *model2 = model;
        TopicViewController *tVC = [TopicViewController new];
        tVC.topicId = model2.itemId;
        itemId = model2.itemId;
        pushVC = tVC;
    }else if ([model isKindOfClass:[ADModel class]]){
        
    }
    
    [[HttpRequest currentViewController].navigationController pushViewController:pushVC animated:YES];
    
    return itemId;
}

//记录浏览过的文章id
+(void)saveBrowsNewsId:(NSInteger)itemId handle:(void (^)(void))processBlock
{

    GCDAsynGlobal(^{
        NSArray* newsIdArr = [NSArray bg_arrayWithName:@"newsIdArr"];
        NSMutableArray* columnArr;
        if (!kArrayIsEmpty(newsIdArr)) {
            columnArr = [newsIdArr mutableCopy];
        }else{
            columnArr = [NSMutableArray new];
        }
        
        for (int i = 0 ; i < columnArr.count; i ++) {
            NSInteger newid = [columnArr[i] integerValue];
            if (newid == itemId) {  //已经记录过了
                return;
            }
        }
        [columnArr addObject:@(itemId)];
        [columnArr bg_saveArrayWithName:@"newsIdArr"];
        if (processBlock) {
            processBlock();
        }
        
    });
    
}

//处理获取的文章数据
+(void)processNewWithBrowsWithData:(NSArray *)arr handle:(void (^)(NSMutableArray *newArr))processBlock
{
    GCDAsynGlobal(^{
        NSArray* newsIdArr = [NSArray bg_arrayWithName:@"newsIdArr"];
        NSMutableArray *newArr = [NSMutableArray new];
        for (id model in arr) {
            NSMutableDictionary *dic = [model mj_JSONObject];
            NSInteger itemId = [dic[@"itemId"] integerValue];
            
//            if ([model isKindOfClass:[HomePageModel class]]) {
//                HomePageModel *model1 = model;
//                itemId = model1.itemId;
//            }else if ([model isKindOfClass:[TopicModel class]]){
//                itemId = [(TopicModel *)model itemId];
//            }
            
            for (int i = 0 ; i < newsIdArr.count; i ++) {
                NSInteger newid = [newsIdArr[i] integerValue];
                if (newid == itemId) {  //已经记录过了
                    [dic setObject:@(YES) forKey:@"hasBrows"];
                    break;
                }
            }
            [newArr addObject:dic];
        }
        newArr = [self getProcessNewsData:newArr];
        if (processBlock) {
            processBlock(newArr);
        }
    });
}

//清除浏览过的文章id
+(void)clearBrowsNewsIdArr
{
    GCDAsynGlobal(^{
        [NSArray bg_clearArrayWithName:@"newsIdArr"];
    });
}

//判断是否为已浏览过的文章
+(void)isBrowsNewId:(NSInteger)itemId handle:(void (^)(void))processBlock
{
    GCDAsynGlobal(^{
        //先获取浏览过的newid记录
        NSArray* newsIdArr = [NSArray bg_arrayWithName:@"newsIdArr"];
        
        if (!kArrayIsEmpty(newsIdArr)) {
            for (int i = 0; i < newsIdArr.count; i ++) {
                NSInteger newsId = [newsIdArr[i] integerValue];
                //有记录
                if (newsId == itemId) {
                    GGLog(@"已经浏览过的文章");
                    if (processBlock) {
                        processBlock();
                    }
                    break;
                }
            }
        }
        
    });
 
}

//根据传入字符串来给标签设置对应的字体颜色，边框色和背景色
+(void)processLabel:(UILabel *)label top:(BOOL)yesOrNo text:(NSString *)string
{
    //先判断是上还是下
    if (yesOrNo) {
        label.textColor = WhiteColor;
        label.layer.borderColor = ClearColor.CGColor;
        label.layer.borderWidth = 0;
        if (CompareString(string, @"专题")) {
            //蓝色背景，白色字体，无边框色
            label.backgroundColor = HexColor(#1282EE);
            
        }else if (CompareString(string, @"问答")){
            //橘色背景，白色字体，无边框色
            label.backgroundColor = OrangeColor;
            
        }else{
            //白色背景，蓝色字体，蓝色边框
            label.backgroundColor = WhiteColor;
            label.textColor = HexColor(#1282EE);
            label.layer.borderColor = HexColor(#1282EE).CGColor;
            label.layer.borderWidth = 1;
        }
        label.text = string;
    }else{
        //下方的，统一蓝色字体，无边框色
        label.textColor = HexColor(#1282EE);
    }
}

//根据数量来判断具体怎么展示label
+(NSString *)processNumShow:(NSInteger)num insertString:(NSString *)insert
{
    NSString *string = @"";
    if (num > 0) {
        //大于10000
        if (num/10000) {
            string = [[NSString stringWithFormat:@"%.1fw",num/10000.0] stringByAppendingString:[NSString stringWithFormat:@"%@  ",insert]];
        }else{
            string = [[NSString stringWithFormat:@"%ld",num] stringByAppendingString:[NSString stringWithFormat:@"%@  ",insert]];
        }
    }
    return string;
}





@end
