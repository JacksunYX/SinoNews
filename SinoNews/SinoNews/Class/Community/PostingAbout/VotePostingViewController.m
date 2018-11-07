//
//  VotePostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VotePostingViewController.h"
#import "SelectPublishChannelViewController.h"

@interface VotePostingViewController ()

@end

@implementation VotePostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"投票发帖";
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
