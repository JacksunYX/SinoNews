//
//  AttentionRecommendVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/8.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendVC.h"
#import "SearchViewController.h"    //搜索页面

@interface AttentionRecommendVC ()

@end

@implementation AttentionRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐";
    self.view.backgroundColor = WhiteColor;
    [self addNavigationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(searchAction) image:@"attention_search" hightimage:nil andTitle:@""];
    
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
    [self.navigationController pushViewController:sVC animated:NO];
}







@end
