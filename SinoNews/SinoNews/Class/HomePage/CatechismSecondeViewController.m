//
//  CatechismSecondeViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CatechismSecondeViewController.h"
#import "CommentDetailViewController.h"
#import "AnswerDetailModel.h"

#import "QACommentInputView.h"
#import "ShareAndFunctionView.h"
#import "FontAndNightModeView.h"

#import "CommentCell.h"

@interface CatechismSecondeViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentArr;    //回答数组
@property (nonatomic,assign) NSInteger currPage;            //页面(起始为1)

@property (nonatomic,strong) AnswerDetailModel *answerModel;//回答模型

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorAndTime;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;

@property (nonatomic,strong) UIView *naviTitle;

@end

@implementation CatechismSecondeViewController
CGFloat static titleViewHeight = 91;
-(NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [NSMutableArray new];
    }
    return _commentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];
    
    [self hiddenTopLine];
    
    [self requestNews_browseAnswer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    _tableView.backgroundColor = ClearColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    @weakify(self);
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.webView.loading) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.commentArr.count) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestShowAnswerComment];
    }];
    
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 1;
    [self requestShowAnswerComment];
}

-(void)setTitle
{
    if (!self.titleView) {
        self.titleView = [UIView new];
        [self.titleView addBakcgroundColorTheme];
        [self.view insertSubview:self.titleView belowSubview:self.tableView];
        self.titleView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        //        .heightIs(titleViewHeight)
        
        ;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = PFFontM(22);
        _titleLabel.numberOfLines = 0;
        [_titleLabel addTitleColorTheme];
        
        _avatar = [UIImageView new];
        
        _authorAndTime = [UILabel new];
        _authorAndTime.font = PFFontR(11);
        _authorAndTime.textColor = RGBA(152, 152, 152, 1);
        
        @weakify(self);
        _attentionBtn = [UIButton new];
        [_attentionBtn setNormalTitleColor:WhiteColor];
        
        [_attentionBtn setNormalTitle:@" 关注"];
        [_attentionBtn setSelectedTitle:@"已关注"];
        
        [_attentionBtn setNormalBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)]];
        
        _attentionBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            
            if (UserGetBool(@"NightMode")) {
                [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#1C1F2C)]];
                [(UIButton *)item setSelectedTitleColor:HexColor(#4E4F53)];
            }else{
                [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#e3e3e3)]];
                [(UIButton *)item setSelectedTitleColor:WhiteColor];
            }
        });
        
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestIsAttention];
        }];
        
        [_attentionBtn setBtnFont:PFFontR(14)];
        
        [self.titleView sd_addSubviews:@[
                                         _titleLabel,
                                         _avatar,
                                         _authorAndTime,
                                         _attentionBtn,
                                         ]];
        _titleLabel.sd_layout
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .topEqualToView(self.titleView)
        //    .heightIs(50)
        .autoHeightRatio(0)
        ;
        _titleLabel.text = GetSaveString(self.answerModel.newsTitle);
        
        CGFloat wid = 24;
        if (kStringIsEmpty(self.answerModel.avatar)) {
            wid = 0;
        }
        _avatar.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel, 7)
        .widthIs(wid)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.answerModel.avatar))];
        
        _authorAndTime.sd_layout
        .leftSpaceToView(_avatar, 3)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorAndTime setSingleLineAutoResizeWithMaxWidth:200];
        _authorAndTime.text = [NSString stringWithFormat:@"%@    %@",GetSaveString(self.answerModel.username),GetSaveString(self.answerModel.createTime)];
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(58)
        .heightIs(20)
        ;
        
        [_attentionBtn setSd_cornerRadius:@8];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:10];
    }
    
    _attentionBtn.selected = self.answerModel.hasFollow;
    if (_attentionBtn.selected) {
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    
    //如果是用户本人发布的文章，就不显示关注的按钮
    if (![UserModel showAttention:self.answerModel.userId]) {
        [_attentionBtn removeFromSuperview];
//        [self.topAttBtn removeFromSuperview];
    }
    
    _titleLabel.font = [GetCurrentFont titleFont];
    
    //获取上部分的高度
    [self.titleView updateLayout];
    titleViewHeight = self.titleView.height;
    
    GGLog(@"titleViewHeight:%f",titleViewHeight);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
    
//    _tableView.contentOffset = CGPointMake(0, -titleViewHeight + 1);
}

-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [UIView new];
        _naviTitle.alpha = 0;
        self.navigationItem.titleView = _naviTitle;
        [_naviTitle addBakcgroundColorTheme];
        
        _naviTitle.sd_layout
        .heightIs(30)
        ;
        
        UIImageView *avatar = [UIImageView new];
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        
        [_naviTitle sd_addSubviews:@[
                                     avatar,
                                     username,
                                     ]];
        CGFloat wid = 0;
        if (self.answerModel.avatar.length>0) {
            wid = 30;
        }
        avatar.sd_layout
        .leftEqualToView(_naviTitle)
        .centerYEqualToView(_naviTitle)
        .widthIs(wid)
        .heightIs(30)
        ;
        [avatar setSd_cornerRadius:@(wid/2)];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.answerModel.avatar))];
        
        username.sd_layout
        .leftSpaceToView(avatar, 5)
        .centerYEqualToView(_naviTitle)
        .heightIs(30)
        ;
        [username setSingleLineAutoResizeWithMaxWidth:150];
        username.text = GetSaveString(self.answerModel.username);
        
        [_naviTitle setupAutoWidthWithRightView:username rightMargin:5];
        
    }
}

-(void)setNavigationBtns
{
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more_night" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }
    });
}

//设置网页
-(void)setWebViewLoad
{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0]. appendChild(meta);";
    
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
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
    self.webView.navigationDelegate = self;
    [self.webView addBakcgroundColorTheme];
    self.webView.scrollView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    [self.view addSubview:self.webView];
    
    //KVO监听web的高度变化
    @weakify(self)
    [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //        GGLog(@"x:%@",x);
        CGFloat newHeight = self.webView.scrollView.contentSize.height;
        if (newHeight != self.topWebHeight) {
            self.topWebHeight = newHeight;
            self.webView.frame = CGRectMake(0, 0, ScreenW, self.topWebHeight);
            //            GGLog(@"topWebHeight:%lf",topWebHeight);
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView endUpdates];
        }
    }];
    
    //加载页面
    NSString *urlStr = AppendingString(DefaultDomainName, self.answerModel.contentUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
}

-(void)setBottomView
{
    if (!self.bottomView) {
        self.bottomView = [UIView new];
        [self.view addSubview:self.bottomView];
        
        self.bottomView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        .heightIs(49)
        ;
        [self.bottomView updateLayout];
        self.bottomView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            
            if (UserGetBool(@"NightMode")) {
                [(UIView *)item addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
            }else{
                [(UIView *)item addBorderTo:BorderTypeTop borderColor:CutLineColor];
            }
        });
        
        _praiseBtn = [UIButton new];
        
        UIButton *shareBtn = [UIButton new];
        UIButton *answerInput = [UIButton new];
        
        @weakify(self)
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:4 praiseId:self.answer_id commentNum:0];
            }
        }];
        
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self moreSelect];
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          
                                          _praiseBtn,
                                          answerInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 16)
        .centerYEqualToView(self.bottomView)
        .widthIs(21)
        .heightIs(21)
        ;
        [shareBtn updateLayout];
        [shareBtn addButtonNormalImage:@"news_share"];
        
        _praiseBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn addButtonNormalImage:@"news_unPraise"];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        answerInput.sd_layout
        .leftSpaceToView(self.bottomView, 40)
        .centerYEqualToView(self.bottomView)
        .widthIs(100)
        .heightIs(20)
        ;
        [answerInput updateLayout];
        
        [answerInput setNormalImage:UIImageNamed(@"news_comment")];
        [answerInput setNormalTitle:@"回复答主..."];
        [answerInput setBtnFont:PFFontL(15)];
        [answerInput setNormalTitleColor:HexColor(#323232)];
        [answerInput layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        
        [answerInput whenTap:^{
            @strongify(self)
            [QACommentInputView showAndSendHandle:^(NSString *inputText) {
                if (![NSString isEmpty:inputText]) {
                    [self requestAnswerCommentWithComment:inputText];
                }else{
                    LRToast(@"请输入有效的内容");
                }
            }];
        }];
    }
    
    self.praiseBtn.selected = self.answerModel.hasPraise;
    
}

//更多
-(void)moreSelect
{
    @weakify(self)
    [ShareAndFunctionView showWithCollect:YES returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
            [self shareToPlatform:sharePlateform];
        }else if (section==1) {
            if (row == 0) {
                [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
                    @strongify(self)
                    [self setWebViewLoad];
                }];
            }else if (row == 1) {
                [self.webView reload];
            }else if (row == 2) {
                
            }
            
        }
    }];
}

//分享方法
-(void)shareToPlatform:(MGShareToPlateform)type
{
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DefaultDomainName, @"");
    if (type == MGShareToSina) {
        //如果分享类型是图文，就一定要给图片或者图片链接，无效或为空都是无法分享的
        shareModel.contentType = MGShareContentTypeText;
        shareModel.content = AppendingString(@"测试标题", urlStr);
        //        shareModel.thumbImage = [UIImage imageNamed:@""];
        //        shareModel.image = @"xxx";
    }else{
        shareModel.contentType = MGShareContentTypeWebPage;
        shareModel.title = @"测试标题";
        shareModel.url = urlStr;
        shareModel.content = @"";
        shareModel.thumbImage = [UIImage imageNamed:@""];
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        GGLog(@"分享成功");
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        GGLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
        
    }];
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self setBottomView];
    
//    [self setNavigationBtns];
    
    [self refreshComments];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    [self.tableView setContentOffset:CGPointMake(0, -titleViewHeight + 1) animated:YES];
    
    [self showOrHideLoadView:NO page:2];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CommentCellID];
    CompanyCommentModel *model = self.commentArr[indexPath.row];
    cell.model = model;
    @weakify(self)
    //点赞
    cell.praiseBlock = ^(NSInteger row) {
        @strongify(self)
        if (model.isPraise) {
            LRToast(@"已经点过赞啦");
        }else{
            [self requestPraiseWithPraiseType:7 praiseId:[model.commentId integerValue] commentNum:indexPath.row];
        }
    };
    //头像
    cell.avatarBlock = ^(NSInteger row) {
        [UserModel toUserInforVcOrMine:[model.userId integerValue]];
    };
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 42)];
        UILabel *title = [UILabel new];
        title.font = PFFontR(13);
        title.lee_theme.LeeConfigTextColor(@"titleColor");
        [headView addSubview:title];
        //布局
        title.sd_layout
        .centerYEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        if (self.answerModel) {
            NSInteger count = MAX(self.answerModel.commentCount, self.commentArr.count);
            if (count) {
                title.text = [NSString stringWithFormat:@"全部评论(%ld)",count];
            }else{
                title.text = @"全部评论";
            }
        }
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentDetailViewController *cdVC = [CommentDetailViewController new];
    cdVC.model = self.commentArr[indexPath.row];
    cdVC.pushType = 2;
    cdVC.answerId = self.answer_id;
    [self.navigationController pushViewController:cdVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    GGLog(@"touchesBegan点击了");
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    
    if (self.attentionBtn.enabled) {
        //如果大于，说明tableView便宜量已经看不到头像等信息了
        if (self.tableView.contentOffset.y + titleViewHeight >=10 + 24) {
            GGLog(@"不能点击");
        }else{
            
            if (x >= ScreenW - (58+10)&&x<= ScreenW - 10 && y >= titleViewHeight - 10 - 24/2 - 20/2 && y <= titleViewHeight - 10 - 24/2 + 20/2) {
                GGLog(@"点击了关注");
                [self requestIsAttention];
            }else if (x >= 10&&x<= (100+10) && y >= titleViewHeight - 10 - 24 && y <= titleViewHeight - 10) {
                GGLog(@"点击用户部分");
                [UserModel toUserInforVcOrMine:self.answerModel.userId];
            }
        }
    }
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    GGLog(@"contentOffset.y:%f",offsetY);
    if (offsetY >= - titleViewHeight - 1&&offsetY <= 0) {
        //计算透明度比例
        CGFloat alpha = MAX(0, (titleViewHeight - fabs(offsetY)) / titleViewHeight);
        NSString *process = [NSString stringWithFormat:@"%.1lf",alpha];
//        GGLog(@"min:%@",process);
        self.titleView.alpha = 1 - [process floatValue];
        self.attentionBtn.enabled = 1 - [process floatValue];
        self.naviTitle.alpha = [process floatValue];
        
        [self hiddenTopLine];
        
    }else{
        if (offsetY>0) {
            [self showTopLine];
            self.naviTitle.alpha = 1;
            self.titleView.alpha = 0;
            self.attentionBtn.enabled = NO;
        }
    }
    
}


#pragma mark ---- 请求发送
//查看回答
-(void)requestNews_browseAnswer
{
    [HttpRequest postWithURLString:News_browseAnswer parameters:@{@"answerId":@(self.answer_id)} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.answerModel = [AnswerDetailModel mj_objectWithKeyValues:response[@"data"]];
        self.commentArr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:self.answerModel.comments];
        self.currPage = 1;
        [self setWebViewLoad];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } RefreshAction:nil];
}

//关注/取关
-(void)requestIsAttention
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.answerModel.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
//        UserModel *user = [UserModel getLocalUserModel];
        NSInteger status = [res[@"data"][@"status"] integerValue];
        if (status == 1) {
//            user.followCount ++;
            LRToast(@"关注成功");
        }else{
//            user.followCount --;
            LRToast(@"已取消关注");
        }
        self.answerModel.hasFollow = status;
        //覆盖之前保存的信息
//        [UserModel coverUserData:user];
        [self setTitle];
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
    
}

//点赞文章/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if (praiseType == 7) {
            CompanyCommentModel *model = self.commentArr[row];
            
            NSInteger status = [res[@"data"][@"success"] integerValue];
            if (status) {
                LRToast(@"点赞成功");
                model.isPraise = YES;
                model.likeNum ++;
            }
            [self.tableView reloadData];
        }
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
    
}

//评论列表
-(void)requestShowAnswerComment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"answerId"] = @(self.answer_id);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest postWithURLString:ShowAnswerComment parameters:parameters isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSArray *data = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        
        self.commentArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.commentArr];

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    } RefreshAction:nil];
}

//添加回答评论
-(void)requestAnswerCommentWithComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"comment"] = comment;
    parameters[@"answerId"] = @(self.answer_id);
    parameters[@"parentId"] = @(0);
    [HttpRequest postWithTokenURLString:AnswerComment parameters:parameters isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        CompanyCommentModel *addComment = [CompanyCommentModel mj_objectWithKeyValues:res[@"data"]];
        [self.commentArr insertObject:addComment atIndex:0];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
}


@end
