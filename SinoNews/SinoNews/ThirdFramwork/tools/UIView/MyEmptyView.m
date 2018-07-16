//
//  MyEmptyView.m
//  SinoNews
//
//  Created by Michael on 2018/7/16.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyEmptyView.h"

@implementation MyEmptyView

-(void)prepare
{
    [super prepare];
    //关闭自动显隐
    self.autoShowEmptyView = NO;
    
    self.titleLabFont = PFFontL(14);
    self.titleLabTextColor = HexColor(#B2B2B2);
    
//    self.detailLabFont = [UIFont systemFontOfSize:17];
//    self.detailLabTextColor = HexColor(#B2B2B2);
//    self.detailLabMaxLines = 5;
    
//    self.actionBtnBackGroundColor = HexColor(#B2B2B2);
//    self.actionBtnTitleColor = [UIColor whiteColor];
}

//无数据空白
+ (instancetype)noDataEmptyWithImage:(NSString *)imgStr refreshBlock:(void(^)(void))block
{
    return [MyEmptyView emptyActionViewWithImageStr:imgStr titleStr:@"无数据" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:block];
}

//无网络空白
+ (instancetype)noNetEmpty
{
    return [MyEmptyView emptyViewWithImageStr:@"noNet"
                                    titleStr:@"暂无数据"
                                   detailStr:@"请检查您的网络连接是否正确!"];
}

+ (instancetype)noDataEmptyWithImage:(NSString *)imgStr title:(NSString *)title
{
    return [MyEmptyView emptyViewWithImageStr:imgStr
                                     titleStr:title
                                    detailStr:@""];
}

@end
