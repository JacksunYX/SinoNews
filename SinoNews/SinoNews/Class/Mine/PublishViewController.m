//
//  PublishViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishArticleViewController.h"
#import "PubLishChannelSelectVC.h"
#import "ZSSCustomButtonsViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
//    [firstBtn setNormalTitleColor:RGBA(50, 50, 50, 1)];
    [firstBtn addButtonTextColorTheme];
    [firstBtn setNormalTitle:@"发布文章"];
    [firstBtn setNormalImage:UIImageNamed(@"publish_article")];
    [firstBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:35];
    @weakify(self)
    [[firstBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
//        PubLishChannelSelectVC *pcsVC = [PubLishChannelSelectVC new];
//        [self.navigationController pushViewController:pcsVC animated:YES];
        
        [self selectArticleType];
    }];
    
    UIButton *secondBtn = [UIButton new];
    [secondBtn setBtnFont:PFFontL(18)];
    [secondBtn addButtonTextColorTheme];
//    [secondBtn setNormalTitleColor:RGBA(50, 50, 50, 1)];
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

-(void)selectArticleType
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择发布新闻类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"普通新闻" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PublishArticleViewController *paVC = [PublishArticleViewController new];
        [self.navigationController pushViewController:paVC animated:YES];
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"付费新闻" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PublishArticleViewController *paVC = [PublishArticleViewController new];
        paVC.isPayArticle = YES;
        [self.navigationController pushViewController:paVC animated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:confirm];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}




@end
