//
//  PostListSearchModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/20.
//  Copyright © 2018 Sino. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//搜索帖子相关版块的模型
@interface SearchSectionsModel : NSObject
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) NSString *sectionName;
@end

//搜索帖子列表模型
@interface PostListSearchModel : NSObject
//帖子列表
@property (nonatomic,strong) NSMutableArray <SeniorPostDataModel *> *models;
//相关帖子数量
@property (nonatomic,assign) NSInteger total;
@end

NS_ASSUME_NONNULL_END
