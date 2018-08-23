//
//  VersionCheckHelper.m
//  SinoNews
//
//  Created by Michael on 2018/8/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "VersionCheckHelper.h"
#import "UpdatePopView.h"

@implementation VersionCheckHelper

//检查版本
+(void)requestToCheckVersion:(success)successBlock popUpdateView:(BOOL)pop
{
    NSMutableDictionary *param = [NSMutableDictionary new];

    param[@"platform"] = @(1);
    
    [HttpRequest getWithURLString:CurrentVersion parameters:param success:^(id response) {
        //后台返回的最新版本号
        NSString *versionName = response[@"data"][@"versionName"];
        //0位为非强制更新，1为强制更新
        NSInteger type = [response[@"data"][@"type"] integerValue];
        //先跟当前app版本比对是否有出入
        if (CompareString([UIDevice appVersion], versionName)) {
            if (successBlock) {
                successBlock(@"1");
            }
            return ;
        }else{
            switch (type) {
                case 0:
                {
                    //是否有最新版本弹框的标记
                    NSString *version = [NSString stringWithFormat:@"Version_%@",versionName];
                    BOOL updateMark = UserGetBool(version);
                    
                    //弹窗过了
                    if (updateMark&&!pop) {
                        return;
                    }
                    //没有则标记,下次就不主动弹出了
                    UserSetBool(YES, version);
                    
                    [UpdatePopView showWithData:response[@"data"]];
                }
                    break;
                case 1:
                    //这里强制弹框
                    [UpdatePopView showWithData:response[@"data"]];
                    break;
                default:
                    break;
            }
        }
    } failure:nil];
    
}




@end
