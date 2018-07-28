//
//  Q&APublishViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "Q_APublishViewController.h"

#import "LMWordViewController.h"
#import "LMWordView.h"
#import "LMTextHTMLParser.h"

@interface Q_APublishViewController ()
@property (nonatomic,strong) UIButton *submit;
@property (nonatomic, strong) LMWordViewController *wordViewController;
@end

@implementation Q_APublishViewController
- (LMWordViewController *)wordViewController {
    
    if (!_wordViewController) {
        _wordViewController = [[LMWordViewController alloc] init];
    }
    return _wordViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBtns];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    //这里给个延时，不然无法正常显示编辑框
    GCDAfterTime(0.5, ^{
        [self.wordViewController.textView becomeFirstResponder];
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    [self addChildViewController:self.wordViewController];
    
    [self.view addSubview:self.wordViewController.view];
    
    self.wordViewController.view.frame = self.view.bounds;
    
}

//设置导航栏按钮
-(void)addNavigationBtns
{
    self.navigationItem.title = @"添加问答";
    UIBarButtonItem *cancel = [UIBarButtonItem itemWithTarget:self Action:@selector(cancelAction) image:nil hightimage:nil andTitle:@"取消"];

    _submit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_submit addButtonTextColorTheme];
    [_submit setBtnFont:PFFontL(16)];
    [_submit setNormalTitle:@"提交"];
    [_submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_submit];
}

//取消
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交
-(void)submitAction
{
    [self.view endEditing:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.news_id);
    parameters[@"content"] = [self.wordViewController exportHTML];
    [HttpRequest postWithURLString:News_answer parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"回答成功");
        if (self.submitBlock) {
            self.submitBlock();
        }
        GCDAfterTime(1, ^{
            [self cancelAction];
        });
    } failure:^(NSError *error) {
//        [self cancelAction];
    } RefreshAction:^{
        
    }];
}






@end
