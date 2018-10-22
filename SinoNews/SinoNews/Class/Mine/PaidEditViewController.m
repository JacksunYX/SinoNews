//
//  PaidEditViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/22.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PaidEditViewController.h"
#import "WGRichTextEditorVC.h"

@interface PaidEditViewController ()
{
    WGRichTextEditorVC *wgrteVC;
}
@end

@implementation PaidEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = @"编辑免费内容";
    if (self.type==1) {
        title = @"编辑付费内容";
    }
    self.navigationItem.title = title;
    
    [self setNavigation];
    
    [self setUI];
}

-(void)setNavigation
{
    UIButton *rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    
    UILabel *editBtn = [UILabel new];
    editBtn.textAlignment = NSTextAlignmentCenter;
    editBtn.userInteractionEnabled = NO;
    editBtn.frame = CGRectMake(0, 10, 40, 20);
    editBtn.font = PFFontL(15);
    editBtn.textColor = RGBA(18, 130, 238, 1);
    editBtn.text = @"完成";
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    editBtn.layer.borderWidth = 1;
    @weakify(self);
    [rightBtn whenTap:^{
        @strongify(self);
        if ([NSString isEmpty:[self->wgrteVC contentH5]]) {
            LRToast(@"必须要有文字内容哦");
            return ;
        }else{
            if (self.editBlock) {
                self.editBlock([self->wgrteVC contentH5]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [rightBtn addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)setUI
{
    wgrteVC = [WGRichTextEditorVC new];
    
    wgrteVC.hiddenSettingBtn = YES;
    
    wgrteVC.hiddenTitle = YES;
    
    [self addChildViewController:wgrteVC];
    
    [self.view addSubview:wgrteVC.view];
    
    wgrteVC.view.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    ;
    
    wgrteVC.content = self.content;
}


@end
