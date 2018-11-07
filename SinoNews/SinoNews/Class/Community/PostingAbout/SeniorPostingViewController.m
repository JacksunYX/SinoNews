//
//  SeniorPostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingViewController.h"
#import "SelectPublishChannelViewController.h"

@interface SeniorPostingViewController ()

@end

@implementation SeniorPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"高级发帖";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUI
{
    
}

@end
