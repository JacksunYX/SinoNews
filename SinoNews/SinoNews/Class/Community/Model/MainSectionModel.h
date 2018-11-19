//
//  MainSectionModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/19.
//  Copyright © 2018 Sino. All rights reserved.
//
//主/子版块模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainSectionModel : NSObject
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger postCount;//发帖数
@property (nonatomic,assign) NSInteger sectionId;//id
@property (nonatomic,strong) NSMutableArray <MainSectionModel *>*subSections;//包含的子版块数组

@end

NS_ASSUME_NONNULL_END
