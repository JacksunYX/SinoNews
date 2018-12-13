//
//  RemindPeople.h
//  SinoNews
//
//  Created by Michael on 2018/11/6.
//  Copyright © 2018 Sino. All rights reserved.
//
//@的用户模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemindPeople : NSObject

@property(nonatomic,assign)NSInteger isFollow;  //是否相互已关注(1:是,0:否)

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) BOOL isSelected;  //是否被选中
@end

NS_ASSUME_NONNULL_END
