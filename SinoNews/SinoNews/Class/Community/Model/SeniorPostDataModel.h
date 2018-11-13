//
//  SeniorPostDataModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeniorPostDataModel : NSObject
//帖子标题
@property (nonatomic,strong) NSString *postTitle;
//帖子内容
@property (nonatomic,strong) NSString *postContent;
//所包含的子元素数组
@property (nonatomic,strong) NSMutableArray <SeniorPostingAddElementModel *>*dataSource;

@end

NS_ASSUME_NONNULL_END
