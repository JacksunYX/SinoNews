//
//  UniversalMethod.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//通用方法总和


#import "UniversalMethod.h"

#import "NewsDetailViewController.h"
#import "TopicViewController.h"
#import "RankDetailViewController.h"


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


@end
