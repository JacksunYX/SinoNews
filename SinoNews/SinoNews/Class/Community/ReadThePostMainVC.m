//
//  ReadThePostMainVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadThePostMainVC.h"

@interface ReadThePostMainVC ()

@end

@implementation ReadThePostMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"读帖";
    [self addNavigationView];
}

//修改导航栏显示
-(void)addNavigationView
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *leftImg = @"return_left";
        if (UserGetBool(@"NightMode")) {
            leftImg = [leftImg stringByAppendingString:@"_night"];
        }
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:leftImg]];
    });
    
}

-(void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
