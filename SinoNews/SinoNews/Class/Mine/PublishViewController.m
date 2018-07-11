//
//  PublishViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishArticleViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    UIButton *firstBtn = [UIButton new];
    [firstBtn setBtnFont:PFFontL(18)];
    [firstBtn setNormalTitleColor:RGBA(50, 50, 50, 1)];
    [firstBtn setNormalTitle:@"发布文章"];
    [firstBtn setNormalImage:UIImageNamed(@"publish_article")];
    [firstBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:35];
    @weakify(self)
    [[firstBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        PublishArticleViewController *paVC = [PublishArticleViewController new];
        [self.navigationController pushViewController:paVC animated:YES];
    }];
    
    UIButton *secondBtn = [UIButton new];
    [secondBtn setBtnFont:PFFontL(18)];
    [secondBtn setNormalTitleColor:RGBA(50, 50, 50, 1)];
    [secondBtn setNormalTitle:@"发布问答"];
    [secondBtn setNormalImage:UIImageNamed(@"publish_answer")];
    [secondBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:35];
    [[secondBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        PublishArticleViewController *paVC = [PublishArticleViewController new];
        paVC.editType = 1;
        [self.navigationController pushViewController:paVC animated:YES];
    }];
    
    UILabel *notice = [UILabel new];
    notice.textColor = RGBA(208, 208, 208, 1);
    notice.font = PFFontL(15);
    
    [self.view sd_addSubviews:@[
                                firstBtn,
                                secondBtn,
                                notice,
                                ]];
    //布局
    firstBtn.sd_layout
    .topSpaceToView(self.view, 86)
    .centerXEqualToView(self.view)
    .widthIs(156)
    .heightIs(50)
    ;
    
    secondBtn.sd_layout
    .topSpaceToView(firstBtn, 35)
    .centerXEqualToView(self.view)
    .widthIs(156)
    .heightIs(50)
    ;
    
    notice.sd_layout
    .topSpaceToView(secondBtn, 46)
    .centerXEqualToView(self.view)
    .heightIs(16)
    ;
    [notice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
    notice.text = @"请选择你要发布的类型";
}






@end
