//
//  UniversalMethod.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADModel,TopicModel;

@interface UniversalMethod : NSObject

/**
 根据广告模型跳转到不同界面

 @param model 模型
 */
+(void)jumpWithADModel:(ADModel *)model;


/**
 拿本地缓存的频道数据与后台数据进行比对

 @param serverData  后台频道数组
 @param reason      回调block
 */
+(void)compareChannels:(NSArray *)serverData
          reasonAction:(void (^)(BOOL changed1 ,BOOL changed2 , NSArray *attentionArr, NSArray *unAttentionArr))reason;

//获取上拉加载更多的时间节点
+(NSString *)getTopLoadTimeWithData:(NSArray *)data;

//获取下拉加载更多的时间节点
+(NSString *)getBottomLoadTimeWithData:(NSArray *)data;


/**
 将新闻数据处理成为数组并返回

 @param response 需要处理的数据
 @return 返回的数据数组
 */
+(NSMutableArray *)getProcessNewsData:(id)response;


/**
 根据不同的文章模型，跳转到指定的界面

 @param model 文章模型
 */
+(void)pushToAssignVCWithNewmodel:(id)model;



/**
 根据传入字符串来给标签设置对应的字体颜色，边框色和背景色

 @param label 标签
 @param yesOrNo 是否是上部分的标签
 @param string 字符串
 */
+(void)processLabel:(UILabel *)label top:(BOOL)yesOrNo text:(NSString *)string;


/**
 根据数量来判断具体怎么展示label

 @param num 数量
 @return 返回的字符串
 */
+(NSString *)processNumShow:(NSInteger)num insertString:(NSString *)insert;


/**
 判断是否为已浏览过的文章

 @param itemId 文章id
 @return 是或否
 */
+(BOOL)isBrowsNewId:(NSInteger)itemId;


/**
 清除浏览过的文章id
 */
+(void)clearBrowsNewsIdArr;

/**
 记录浏览过的文章id

 @param itemId 文章id
 */
+(void)saveBrowsNewsId:(NSInteger)itemId;


@end
