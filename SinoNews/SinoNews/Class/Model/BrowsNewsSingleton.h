//
//  BrowsNewsSingleton.h
//  SinoNews
//
//  Created by Michael on 2018/7/31.
//  Copyright © 2018年 Sino. All rights reserved.
//
//阅读记录单例

#import <Foundation/Foundation.h>

@interface BrowsNewsSingleton : NSObject<FastSingleton>

@property (nonatomic,strong) NSMutableArray *idsArr;    //保存阅读过的文章id

@property (nonatomic,strong) NSMutableArray *domainsArr;

//比对获取到的新闻模型中是否有已经阅读过的了
-(NSMutableArray *)compareBrowsHistoryWithBackgroundData:(NSMutableArray *)backgroundData;

//添加一个历史
-(void)addBrowHistory:(NSInteger)itemId;

//保存本地历史
-(void)saveBrowHistory;

//清除浏览过的文章id
-(void)clearBrowsNewsIdArr;

@end
