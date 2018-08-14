//
//  DraftDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "DraftDetailViewController.h"

@interface DraftDetailViewController ()

@property (nonatomic,strong) UILabel *newsTitle;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation DraftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTopLine];
    [self setNavigation];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setNavigation
{
    UIButton *rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    
    UILabel *editBtn = [UILabel new];
    editBtn.textAlignment = NSTextAlignmentCenter;
    editBtn.userInteractionEnabled = NO;
    editBtn.frame = CGRectMake(0, 10, 40, 20);
    editBtn.font = PFFontL(16);
    editBtn.textColor = RGBA(18, 130, 238, 1);
    editBtn.text = @"发布";
    [rightBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

//发布按钮
-(void)publishAction
{
    GGLog(@"直接发布");
}

-(void)setUI
{
    _bottomView = [UIView new];
    [_bottomView addBakcgroundColorTheme];
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(49)
    ;
    [_bottomView updateLayout];
    [_bottomView addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
    
    UIButton *deleteBtn = [UIButton new];
    UIButton *editBtn = [UIButton new];
    
    [deleteBtn setBtnFont:PFFontL(15)];
    [editBtn setBtnFont:PFFontL(15)];
    
    [_bottomView sd_addSubviews:@[
                                  deleteBtn,
                                  editBtn,
                                  ]];
    deleteBtn.sd_layout
    .leftEqualToView(_bottomView)
    .topEqualToView(_bottomView)
    .bottomEqualToView(_bottomView)
    .widthRatioToView(_bottomView, 0.5)
    ;
    [deleteBtn updateLayout];
    [deleteBtn setNormalTitle:@"删除"];
    deleteBtn.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        UIButton *btn = item;
        [btn setNormalTitleColor:value];
        NSString *iconStr = @"draft_delete";
        [btn addBorderTo:BorderTypeRight borderColor:CutLineColor];
        if (UserGetBool(@"NightMode")) {
            [btn addBorderTo:BorderTypeRight borderColor:CutLineColorNight];
            iconStr = [iconStr stringByAppendingString:@"_night"];
        }
        [btn setNormalImage:UIImageNamed(iconStr)];
    });
    
    editBtn.sd_layout
    .rightEqualToView(_bottomView)
    .topEqualToView(_bottomView)
    .bottomEqualToView(_bottomView)
    .widthRatioToView(_bottomView, 0.5)
    ;
    
    [editBtn setNormalTitle:@"编辑"];
    editBtn.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        UIButton *btn = item;
        [btn setNormalTitleColor:value];
        NSString *iconStr = @"draft_edit";
        if (UserGetBool(@"NightMode")) {
            iconStr = [iconStr stringByAppendingString:@"_night"];
        }
        [btn setNormalImage:UIImageNamed(iconStr)];
    });
    
    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    @weakify(self);
    [deleteBtn whenTap:^{
        @strongify(self);
        [self giveUpEditPop];
    }];
    
    [editBtn whenTap:^{
        GGLog(@"跳转到编辑页面");
    }];
    
    _newsTitle = [UILabel new];
    _newsTitle.font = PFFontM(17);
    [_newsTitle addTitleColorTheme];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [self.webView addBakcgroundColorTheme];
    
    [self.view sd_addSubviews:@[
                                _newsTitle,
                                _webView,
                                ]];
    
    _newsTitle.sd_layout
    .topSpaceToView(self.view, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .autoHeightRatio(0)
    ;
    _newsTitle.text = @"巴勒斯坦总统和是我哄我烦我,烦你按哦到那时 到那时看到你  ";
    
    self.webView.sd_layout
    .topSpaceToView(_newsTitle, 10)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.bottomView, 0)
    ;
    
    NSURL *url = UrlWithStr(@"https://www.taobao.com");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
}

//询问用户是否要删除
-(void)giveUpEditPop
{
    UIAlertController *popVC = [UIAlertController alertControllerWithTitle:@"删除当前草稿?" message:@"当前内容将不再显示在草稿箱" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *giveUp = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestDeleteCurrentDraft];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [popVC addAction:giveUp];
    [popVC addAction:cancel];
    
    [self presentViewController:popVC animated:YES completion:nil];
}

#pragma mark --- 请求
//删除当前草稿
-(void)requestDeleteCurrentDraft
{
    
}




@end
