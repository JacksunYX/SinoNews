//
//  EditSelectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditSelectViewController.h"

@interface EditSelectViewController ()

@end

@implementation EditSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //必须这么写，不然推出时导航栏会出现
    self.navigationController.navigationBar.hidden = YES;
}

-(void)setUI
{
    UIButton *closeBtn = [UIButton new];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeBtn];
    closeBtn.sd_layout
    .bottomSpaceToView(self.view, BOTTOM_MARGIN+20)
    .centerXEqualToView(self.view)
    .widthIs(50)
    .heightIs(50)
    ;
    closeBtn.sd_cornerRadius = @25;
    [closeBtn setNormalTitleColor:BlackColor];
    [closeBtn setNormalTitle:@"X"];
    [closeBtn setBtnFont:PFFontL(18)];
    
    closeBtn.layer.borderColor = UIColor.grayColor.CGColor;
    closeBtn.layer.borderWidth = 1;
}

-(void)close:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
