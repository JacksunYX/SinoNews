//
//  UserModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,strong) NSString *user_icon;

@property (nonatomic,strong) NSString *user_name;

@property (nonatomic,assign) NSUInteger user_integer;

@property (nonatomic,assign) NSUInteger user_sex;

@end
