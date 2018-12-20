//
//  AutoModelHelper.m
//  SinoNews
//
//  Created by Michael on 2018/12/20.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "AutoModelHelper.h"

#import "ZZJsonToModel.h"

@implementation AutoModelHelper

+(void)generateModelWithJsonData:(id)json modelName:(NSString *)name
{
    if (!json) {
        NSLog(@"模型数据为空！");
    }
    NSDictionary *jsonDic = @{};
    if ([json isKindOfClass:[NSArray class]]) {
        jsonDic = @{
                    @"key":json,
                    };
    }else if ([json isKindOfClass:[NSDictionary class]]){
        jsonDic = (NSDictionary *)json;
    }
    NSURL *path = [NSURL URLWithString:@"/Users/Michael/Desktop/"];
    __block BOOL isSuccess = NO;
    double times = [ZZJsonToModel modelWithSpendTime:^{ // 计算代码耗时
        isSuccess = [ZZJsonToModel zz_createMJModelWithJson:jsonDic fileName:name extensionName:@"Model" fileURL:path error:^(NSError *error) {
            NSLog(@"自动生成模型出错：%@",error);
        }];
    }];
    NSLog(@"自动生成模型耗时 %f 秒",times);
}

@end
