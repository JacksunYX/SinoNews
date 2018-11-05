//
//  RemindOthersToReadViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "RemindOthersToReadViewController.h"

@interface RemindOthersToReadViewController ()

@end

@implementation RemindOthersToReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI
{
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.backgroundColor = HexColor(#A1C5E5);
    [confirmBtn setNormalTitleColor:WhiteColor];
    [confirmBtn setBtnFont:PFFontL(16)];
    [self.view addSubview:confirmBtn];
    confirmBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(46)
    ;
    [confirmBtn setNormalTitle:@"确定"];
    
}

@end
