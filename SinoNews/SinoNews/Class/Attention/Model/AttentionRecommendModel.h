//
//  AttentionRecommendModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionRecommendModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,assign) NSInteger fansNum;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,assign) BOOL isAttention;

@end
