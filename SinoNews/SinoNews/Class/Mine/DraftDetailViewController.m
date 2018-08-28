//
//  DraftDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "DraftDetailViewController.h"
#import "PublishArticleViewController.h"
#import "NewPublishModel.h"

@interface DraftDetailViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) NewPublishModel *draftModel;
@property (nonatomic,strong) UILabel *newsTitle;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation DraftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTopLine];
    //不是待审核的文章或问答才能使用发布
    if (!self.isToAudit) {
        [self setNavigation];
    }
    [self requestBrowseNewsDraft];
    
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
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (self.isToAudit) {
        parameters[@"newsId"] = @(self.newsId);
    }else{
        parameters[@"draftId"] = @(self.newsId);
    }
    ShowHudOnly;
    [HttpRequest getWithURLString:PublishNewsDraft parameters:parameters success:^(id responseObject) {
        HiddenHudOnly;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        HiddenHudOnly;
    }];
}

-(void)setUI
{
    _bottomView = [UIView new];
    
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(49)
    ;
    [_bottomView updateLayout];
    _bottomView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        UIView *view = item;
        [view setBackgroundColor:value];
        if (UserGetBool(@"NightMode")) {
            [view addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
//            [view addBorderTo:BorderTypeBottom borderColor:CutLineColorNight];
        }else{
            [view addBorderTo:BorderTypeTop borderColor:CutLineColor];
//            [view addBorderTo:BorderTypeBottom borderColor:CutLineColor];
        }
        
    });
    
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
        
        if (UserGetBool(@"NightMode")) {
            [btn addBorderTo:BorderTypeRight borderColor:CutLineColorNight];
            iconStr = [iconStr stringByAppendingString:@"_night"];
        }else{
            [btn addBorderTo:BorderTypeRight borderColor:CutLineColor];
        }
        [btn setNormalImage:UIImageNamed(iconStr)];
    });
    
    editBtn.sd_layout
    .rightEqualToView(_bottomView)
    .topEqualToView(_bottomView)
    .bottomEqualToView(_bottomView)
    .widthRatioToView(_bottomView, 0.5)
    ;
    [editBtn updateLayout];
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
        @strongify(self);
        PublishArticleViewController *paVC = [PublishArticleViewController new];
        if (self.type == 0||self.type == 1) {
            paVC.editType = 0;
        }else{
            paVC.editType = 1;
        }
        paVC.isToAudit = self.isToAudit;
        paVC.draftModel = self.draftModel;
        [self.navigationController pushViewController:paVC animated:YES];
    }];
    
    _newsTitle = [UILabel new];
    _newsTitle.font = PFFontM(17);
    [_newsTitle addTitleColorTheme];
    
    //加载之前就注入适应屏幕及防止及禁止缩放的js代码
    NSString *jScript = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    // 设置字体大小(最小的字体大小)
    preference.minimumFontSize = [GetCurrentFont contentFont].pointSize;
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
    // 设置偏好设置对象
    config.preferences = preference;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
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
    _newsTitle.text = GetSaveString(self.draftModel.title);
    
    self.webView.sd_layout
    .topSpaceToView(_newsTitle, 10)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.bottomView, 0)
    ;
    //加载页面
    //拼接代码，使图片自适应屏幕宽度
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",GetSaveString(self.draftModel.content)];
    [self.webView loadHTMLString:GetSaveString(htmls) baseURL:nil];
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

#pragma mark ---- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#cfd3d6'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
}

#pragma mark --- 请求
//查看草稿
-(void)requestBrowseNewsDraft
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (self.isToAudit) {
        parameters[@"newsId"] = @(self.newsId);
    }else{
        parameters[@"draftId"] = @(self.newsId);
    }
    [HttpRequest getWithURLString:BrowseNewsDraft parameters:parameters success:^(id responseObject) {
        self.draftModel = [NewPublishModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setUI];
    } failure:nil];
}

//删除当前草稿
-(void)requestDeleteCurrentDraft
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (self.isToAudit) {
        parameters[@"newsId"] = @(self.newsId);
    }else{
        parameters[@"draftId"] = @(self.newsId);
    }
    [HttpRequest postWithURLString:RemoveArticle parameters:parameters isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id response) {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:nil RefreshAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}




@end
