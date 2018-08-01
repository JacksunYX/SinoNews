//
//  UIScrollView+PullUpOrDown.m
//  SinoNews
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 Sino. All rights reserved.
//
//上下拉分类

#import "UIScrollView+PullUpOrDown.h"

static int maxPerPage = 10; //每页最大数量
@implementation UIScrollView (PullUpOrDown)

-(NSMutableArray *)pullWithPage:(NSInteger)page data:(NSArray *)data dataSource:(NSMutableArray *)dataSource
{
    //区分页码
    if (page == 1) {
        dataSource = [data mutableCopy];
        [self.mj_header endRefreshing];
        //数组元素个数小于10，则代表后面无数据了
        if (data.count<maxPerPage) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.mj_footer endRefreshing];
        }
    }else if (page > 1){
        [dataSource addObjectsFromArray:data];
        if (data.count<maxPerPage) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.mj_footer endRefreshing];
        }
    }else{
        GGLog(@"页码有误!!!");
    }
    return dataSource;
}

//停止所有刷新动作
-(void)endAllRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
