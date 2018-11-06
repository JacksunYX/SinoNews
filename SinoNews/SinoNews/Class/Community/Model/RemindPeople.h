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
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) BOOL isSelected;  //是否被选中
@end

NS_ASSUME_NONNULL_END
