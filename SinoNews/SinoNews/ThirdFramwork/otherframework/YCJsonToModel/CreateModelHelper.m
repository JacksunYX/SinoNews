//
//  CreateModelHelper.m
//  SinoNews
//
//  Created by Michael on 2018/12/19.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "CreateModelHelper.h"

#import "YCJsonToModelProvider.h"

@implementation CreateModelHelper

+(void)generateModelWithModelName:(NSString *)name json:(id)data
{
    NSString *jsonData;
    if ([data isKindOfClass:[NSDictionary class]]) {
        jsonData = [(NSDictionary *)data mj_JSONString];
    }else if ([data isKindOfClass:[NSArray class]]){
        NSDictionary *dic = @{
                              @"key":(NSArray *)data,
                              };
        jsonData = dic.mj_JSONString;
    }
    NSString*bundel = [[NSBundle mainBundle] resourcePath];
    NSString*deskTopLocation = [[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop"];
    [YCModelFileMgr yc_jsonTomodelWithClassName:name filePath:deskTopLocation jsonData:jsonData mjSupport:YES];
}

@end
