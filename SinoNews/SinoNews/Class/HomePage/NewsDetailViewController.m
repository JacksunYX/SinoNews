//
//  NewsDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//


#import "NewsDetailViewController.h"
#import "CommentDetailViewController.h"

#import "HomePageFirstKindCell.h"
#import "NormalNewsModel.h"
#import "CommentCell.h"
#import "HomePageFourthCell.h"
#import "HomePageThirdKindCell.h"

#import "HomePageModel.h"
#import "FontAndNightModeView.h"
#import "ShareAndFunctionView.h"

#import <SDWebImageManager.h>
#import <CommonCrypto/CommonDigest.h>

//未付费标记
#define NoPayedNews (self.newsModel.isToll&&self.newsModel.hasPaid==0)

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *allUrlArray;
    
    CGFloat currentScrollY; //记录当前滚动的y轴偏移量
    BOOL firstLoadWeb;      //是否是第一次加载网页
    
    NSMutableArray *allImagesOfThisArticle;
    NSMutableArray *imgUrls;
}

@property (nonatomic,strong) UITextField *commentInput;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@property (nonatomic,strong) WKWebView *webView;        //文章内容
@property (nonatomic,strong) WKWebView *voteWebView;    //投票内容
@property (nonatomic,assign) NSInteger currPage;            //页面(起始为1)
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) UIButton *attentionBtn;


@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;

@property (nonatomic,strong) UIView *bottomView2;

@property (nonatomic,assign) NSInteger parentId;

@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;

@property (nonatomic,strong) UIView *naviTitle;

@property (nonatomic,strong) UIButton *topAttBtn; //导航栏上的关注按钮

@property (nonatomic,strong) UserModel *user;

@property WebViewJavascriptBridge* bridge;

//新增，封装头部
@property (nonatomic , strong) NewsDetailsHeaderView *headerView;
@end

@implementation NewsDetailViewController

CGFloat static titleViewHeight = 150;
CGFloat static bottomMargin = 25;
CGFloat static attentionBtnW = 66;
CGFloat static attentionBtnH = 26;
-(UserModel *)user
{
    if (!_user) {
        _user = [UserModel getLocalUserModel];
    }
    return _user;
}

-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(UIButton *)topAttBtn
{
    if (!_topAttBtn) {
        _topAttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topAttBtn.frame = CGRectMake(0, 10, 40, 20);
        [_topAttBtn setBtnFont:PFFontM(20)];
        [_topAttBtn setNormalTitleColor:WhiteColor];
        _topAttBtn.backgroundColor = HexColor(#1282EE);
        //        [_topAttBtn setNormalTitle:@"+"];
        _topAttBtn.layer.cornerRadius = 10;
        _topAttBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_topAttBtn addTarget:self action:@selector(requestIsAttention) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topAttBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self configBlock];
    
    [self hiddenTopLine];
    
    [self requestNewData];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.headerView updateHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBtns
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self action:@selector(moreSelect) image:UIImageNamed(@"news_more_night")];
            //            UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts_night" hightimage:nil andTitle:@""];
            UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [topBtnView addSubview:self.topAttBtn];
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:topBtnView];
            
            self.navigationItem.rightBarButtonItems = @[more,barbtn];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self action:@selector(moreSelect) image:UIImageNamed(@"news_more")];
            //            UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts" hightimage:nil andTitle:@""];
            
            UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [topBtnView addSubview:self.topAttBtn];
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:topBtnView];
            
            self.navigationItem.rightBarButtonItems = @[more,barbtn];
        }
    });
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
//        _titleLabel.font = PFFontM(19);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:ScaleWidth(20)];
        _titleLabel.numberOfLines = 0;
        [_titleLabel addTitleColorTheme];
        
        _avatar = [UIImageView new];
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(12);
        _authorName.textColor = HexColor(#889199);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(12);
        _creatTime.textColor = HexColor(#889199);
        
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
                                         _authorName,
                                         _idView,
                                         _creatTime,
                                         _attentionBtn,
                                         ]];
        _titleLabel.sd_layout
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .topEqualToView(self.titleView)
        //    .heightIs(50)
        .autoHeightRatio(0)
        ;
        _titleLabel.text = GetSaveString(self.newsModel.newsTitle);
        
        CGFloat wid = 24;
        if (kStringIsEmpty(self.newsModel.avatar)) {
            wid = 0;
        }
        _avatar.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel, 7)
        .widthIs(wid)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.newsModel.avatar))];
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        _authorName.text = GetSaveString(self.newsModel.author);
        
        _idView.sd_layout
        .heightIs(20)
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_authorName, 10)
        .widthIs(0)
        ;
        
        [self setIdViewWithIDs];
        
        _creatTime.sd_layout
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_idView, 5)
        .heightIs(12)
        ;
        [_creatTime setSingleLineAutoResizeWithMaxWidth:150];
        _creatTime.text = GetSaveString(self.newsModel.createTime);
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(attentionBtnW)
        .heightIs(attentionBtnH)
        ;
        
        [_attentionBtn setSd_cornerRadius:@(attentionBtnH/2)];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:bottomMargin];
    }
    
    _attentionBtn.selected = self.newsModel.isAttention;
    if (_attentionBtn.selected) {
        [self.topAttBtn setNormalTitle:@"-"];
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [self.topAttBtn setNormalTitle:@"+"];
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    //如果是用户本人发布的文章，就不显示关注的按钮
    if (![UserModel showAttention:self.newsModel.userId]) {
        [_attentionBtn removeFromSuperview];
        [self.topAttBtn removeFromSuperview];
    }
    
    //    _titleLabel.font = [GetCurrentFont titleFont];
    
    //获取上部分的高度
    [self.titleView updateLayout];
    //向下取整
    titleViewHeight = floorf(self.titleView.height);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
//    GGLog(@"titleView自适应高度为：%lf",self.titleView.height);
    //向下滚动一个像素点防止titleview不显示
    //    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - 1) animated:YES];
}

-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _naviTitle.alpha = 0;
        
        [_naviTitle addBakcgroundColorTheme];
        
        CGFloat wid = 0;
        if (self.newsModel.avatar.length>0) {
            wid = 30;
        }
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.newsModel.avatar))];
        
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        username.text = GetSaveString(self.newsModel.author);
        [username sizeToFit];
        CGFloat labelW = CGRectGetWidth(username.frame);
        if (labelW>150*ScaleW) {
            labelW = 150*ScaleW;
        }
        username.frame = CGRectMake(CGRectGetMaxX(avatar.frame) + 5, 0, labelW, 30);
        [_naviTitle addSubview:username];
        
        _naviTitle.frame = CGRectMake(0, 0, 5 * 2 + wid + username.width, 30);
        
        @weakify(self);
        [self.naviTitle whenTap:^{
            @strongify(self);
            [UserModel toUserInforVcOrMine:self.newsModel.userId];
        }];
        
        self.navigationItem.titleView = _naviTitle;
        
    }
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.newsModel.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.newsModel.identifications.count; i ++) {
            NSDictionary *model = self.newsModel.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            approveView.contentMode = 1;
            approveView.sd_layout
            .centerYEqualToView(_idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
            //            [approveView setSd_cornerRadius:@(wid/2)];
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            
            lastView = approveView;
            if (i == self.newsModel.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:lastView rightMargin:0];
            }
        }
    }else{
        
    }
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
        
        self.commentInput = [UITextField new];
        self.commentInput.delegate = self;
        self.commentInput.returnKeyType = UIReturnKeySend;
        @weakify(self)
        //        [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        //            @strongify(self)
        //            GGLog(@"完成编辑");
        //            UITextField *field = x.first;
        //            GGLog(@"-----%@",field.text);
        //            [field resignFirstResponder];
        //            if ([NSString isEmpty:field.text]) {
        //                LRToast(@"评论不能为空哦~");
        //            }else{
        //                [self requestCommentWithComment:field.text];
        //                field.text = @"";
        //            }
        //        }];
        //        [self.commentInput whenTap:^{
        //            @strongify(self)
        //
        //        }];
        
        //        [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        //            GGLog(@"结束编辑");
        //            @strongify(self)
        //
        //        }];
        
        _praiseBtn = [UIButton new];
        _collectBtn = [ZXYShineButton new];
        UIButton *shareBtn = [UIButton new];
        
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:3 praiseId:self.newsId commentNum:0];
            }
        }];
        
        [[_collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestCollectNews];
        }];
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self moreSelect];
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          _collectBtn,
                                          _praiseBtn,
                                          self.commentInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 16)
        .centerYEqualToView(self.bottomView)
        .widthIs(28)
        .heightIs(28)
        ;
        [shareBtn updateLayout];
        [shareBtn addButtonNormalImage:@"news_share"];
        
        _collectBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(25)
        .heightIs(25)
        ;
        [_collectBtn updateLayout];
        
        _collectBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            ZXYShineButton *btn = item;
            ZXYShineParams *params = [ZXYShineParams new];
            if (UserGetBool(@"NightMode")) {
                btn.norImg = UIImageNamed(@"news_unCollect_night");
                btn.selImg = UIImageNamed(@"news_collected_night");
                btn.color = HexColor(#cfd3d6);
                btn.fillColor = HexColor(#1282ee);
                params.bigShineColor = HexColor(#1282ee);
                params.smallShineColor = BlueColor;
            }else{
                btn.norImg = UIImageNamed(@"news_unCollect");
                btn.selImg = UIImageNamed(@"news_collected");
                btn.color = HexColor(#1A1A1A);      //未选中时的颜色
                btn.fillColor = HexColor(#ef9f00);  //选中后的填充色
                params.bigShineColor = HexColor(#ef9f00);
                params.smallShineColor = RedColor;
            }
            btn.params = params;
        });
        
        _praiseBtn.sd_layout
        .rightSpaceToView(_collectBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn addButtonNormalImage:@"news_unPraise"];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        self.commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 23)
        .rightSpaceToView(_praiseBtn, 30)
        .centerYEqualToView(self.bottomView)
        .heightIs(34)
        ;
        [self.commentInput updateLayout];
        self.commentInput.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            if (UserGetBool(@"NightMode")) {
                [(UITextField *)item setBackgroundColor:HexColor(#292D30)];
            }else{
                [(UITextField *)item setBackgroundColor:RGBA(244, 244, 244, 1)];
            }
        });
        [self.commentInput setSd_cornerRadius:@17];
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:@"有何高见，展开讲讲"];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontL(15),
                              NSForegroundColorAttributeName : RGBA(148, 152, 153, 1),
                              };
        [placeholder addAttributes:dic range:NSMakeRange(0, placeholder.length)];
        self.commentInput.attributedPlaceholder = placeholder;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 34)];
        //        UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 21)];
        //        [leftView addSubview:leftImg];
        //        leftImg.center = leftView.center;s
        //        leftImg.image = UIImageNamed(@"news_comment");
        self.commentInput.leftViewMode = UITextFieldViewModeAlways;
        self.commentInput.leftView = leftView;
        
        [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
            @strongify(self);
            [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.bottomView, nil];
        }];
    }
    self.collectBtn.selected = self.newsModel.isCollection;
    self.praiseBtn.selected = self.newsModel.hasPraised;
    self.bottomView.hidden = NO;
    if (self.user.userId == self.newsModel.userId) {
        self.praiseBtn.enabled = NO;
    }else{
        self.praiseBtn.enabled = YES;
    }
}

-(void)setBottomView2
{
    if (!self.bottomView2) {
        self.bottomView2 = [UIView new];
        self.bottomView2.backgroundColor = WhiteColor;
        [self.view addSubview:self.bottomView2];
        self.bottomView2.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        .heightIs(49)
        ;
        [self.bottomView2 updateLayout];
        
        UIButton *payBtn = [UIButton new];
        payBtn.backgroundColor = RGBA(18, 130, 238, 1);
        payBtn.titleLabel.font = PFFontL(15);
        [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [payBtn setTitle:@"购买" forState:UIControlStateNormal];
        @weakify(self)
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self requestPayForNews];
        }];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.font = PFFontR(16);
        priceLabel.textColor = RGBA(18, 130, 238, 1);
        priceLabel.text = [NSString stringWithFormat:@"  %ld积分",self.newsModel.points];
        
        [self.bottomView2 sd_addSubviews:@[
                                           payBtn,
                                           priceLabel,
                                           ]];
        payBtn.sd_layout
        .topEqualToView(self.bottomView2)
        .rightEqualToView(self.bottomView2)
        .bottomEqualToView(self.bottomView2)
        .widthIs(95)
        ;
        [payBtn updateLayout];
        
        priceLabel.sd_layout
        .topEqualToView(self.bottomView2)
        .leftEqualToView(self.bottomView2)
        .rightSpaceToView(payBtn, 0)
        .bottomEqualToView(self.bottomView2)
        ;
        [priceLabel updateLayout];
        [priceLabel addBorderTo:BorderTypeTop borderColor:RGBA(227, 227, 227, 1)];
    }
    //    self.bottomView2.hidden = NO;
    self.bottomView2.hidden = YES;  //当前不显示此种购买ui
}

//下方视图具体显示哪一个
-(void)showBottomView
{
    //收费文章，但是未付费时不显示评论
    if (NoPayedNews) {
        [self setBottomView2];
        self.bottomView.hidden = YES;
        _tableView.mj_footer = nil;
    }else{
        [self setBottomView];
        self.bottomView2.hidden = YES;
        
        @weakify(self);
        _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if (self.webView.loading) {
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (!self.commentsArr.count) {
                self.currPage = 1;
            }else{
                self.currPage++;
            }
            [self requestComments];
        }];
        
        [self refreshComments];
    }
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
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    _headerView = [[NewsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];

    self.tableView.tableHeaderView = _headerView;

    self.headerView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self.tableView, 1.0f);
}

#pragma mark - 设置Block
- (void)configBlock{
    
    @weakify(self);
    
    self.headerView.loadedFinishBlock = ^(BOOL result) {
        @strongify(self);
        if (!self) return ;
        
        if (result) {
            
            self.tableView.hidden = NO;
            
            self.tableView.alpha = 0.0f;
            
            [self setUpOtherViews];
            
            CGFloat y = -titleViewHeight;
            if (self->firstLoadWeb) {
                y = self->currentScrollY;
            }
            //滚到标题偏移坐标
//            self.tableView.contentOffset = CGPointMake(0, y);
            [self.tableView setContentOffset:CGPointMake(0, y+0.5) animated:NO];
            self->firstLoadWeb = YES;
            
            [UIView animateWithDuration:0.5f animations:^{
                
                self.tableView.alpha = 1.0f;
                [self showOrHideLoadView:NO page:2];
            }];
            
        } else {
            
            // 加载失败 提示用户
        }
        
    };
    
    self.headerView.updateHeightBlock = ^(NewsDetailsHeaderView *view) {
        @strongify(self);
        if (!self) return ;
        
        self.tableView.tableHeaderView = view;
    };
    
}

//设置其他视图
-(void)setUpOtherViews
{
    [self showBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 1;
    [self requestComments];
}

//字体
-(void)fontsSelect
{
    @weakify(self)
    [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
        @strongify(self)
        if (self.isVote) {
            [self setWebViewLoad];
        }else{
            [self.headerView configFontLevel:fontIndex];
        }
    }];
}

//更多
-(void)moreSelect
{
    if (!self.newsModel) {
        return;
    }
    @weakify(self)
    [ShareAndFunctionView showWithCollect:self.newsModel.isCollection returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
#ifdef JoinThirdShare
            [self shareToPlatform:sharePlateform];
#endif
        }else if (section==1) {
            if (row == 0) {
                [self fontsSelect];
            }else if (row == 1) {
                if (self.isVote) {
                   [self newLoadWeb];
                }
            }else if (row == 2) {
                [self requestCollectNews];
            }else if (row == 3) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = AppendingString(DomainString, self.newsModel.freeContentUrl);
                LRToast(@"链接已复制");
            }
            
        }
    }];
    
}

//设置网页
-(void)setWebViewLoad
{
    if (self.isVote) {
        NSString *jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = wkUController;
        
        // 设置字体大小(最小的字体大小)
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = [GetCurrentFont contentFont].pointSize;
        // 设置偏好设置对象
        config.preferences = preference;
        
        //默认高度给1，防止网页是纯图片时无法撑开
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
        self.webView.navigationDelegate = self;
        [self.webView addBakcgroundColorTheme];
        self.webView.scrollView.delegate = self;
        
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
                //            [self.tableView beginUpdates];
                self.tableView.tableHeaderView = self.webView;
                //            [self.tableView endUpdates];
            }
        }];
    }
    
    
    [self newLoadWeb];
    [self showOrHideLoadView:YES page:2];
}

//另一种加载页面的方式
-(void)newLoadWeb
{
    if (self.isVote) {
        //投票比较特殊
        //        NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@?id=%ld&userId=%ld",DomainString,VersionNum, News_iosContent,self.newsId,self.user.userId];
        GGLog(@"加载网址:%@",urlStr);
        NSString *result = [urlStr getUTF8String];
        NSURL *url = UrlWithStr(result);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [self.webView loadRequest:request];
    }else{
        
        [self theThirdLoadWebView];

    }
}

//直接加载content(暂不使用)
-(void)normalLoadWbeView
{
    NSString *color = @"color: #161a24;";
    if (UserGetBool(@"NightMode")) {
        color = @"color: #cfd3d6;";
    }
    
    NSString *styleStr = [NSString stringWithFormat:@"%@line-height:32px;letter-spacing: 0.8px;",color];
    //调整文字左右对齐
    NSString *styleStr2 = @"text-align:justify; text-justify:inter-ideograph;";
    
    //拼接样式
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-family:PingFangSC-Regular;font-size:%.fpx;%@%@}\n"
                       //                           "a {font-weight: 600 !important;}\n"
                       //                           "p {margin: 10px 10px 10px 10px;}"
                       "</style> \n"
                       "</head> \n"
                       "<body >"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       //追加定位标签,获取真实高度需要用到
                       "<div id=\"test-div\">"
                       "</div>"
                       "</body>"
                       "</html>",[GetCurrentFont contentFont].pointSize,styleStr,styleStr2,GetSaveString(self.newsModel.fullContent)];
    
    [self.webView loadHTMLString:htmls baseURL:nil];
    
    [self anotherLazyLoadWebView];
}

//使用懒加载的方式处理
-(void)anotherLazyLoadWebView
{
    // 标签替换
    NSString *originalStr = [GetSaveString(self.newsModel.fullContent) stringByReplacingOccurrencesOfString:@"src" withString:@"data-original"];
    //获取temp文件的路径
    NSString *tempPath = [[NSBundle mainBundle]pathForResource:@"temp" ofType:@"html"];
    
    //加载temp内容为字符串
    NSString *tempHtml = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
    
    //替换temp内的占位符{{Content_holder}}为需要加载的HTML代码
    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{Content_holder}}" withString:originalStr];
    //替换文字样式
    NSString *color = @"color: #161a24;";
    if (UserGetBool(@"NightMode")) {
        color = @"color: #cfd3d6;";
    }
    
    NSString *styleStr = [NSString stringWithFormat:@"%@line-height:32px;letter-spacing: 0.8px;",color];
    //调整文字左右对齐
    NSString *styleStr2 = @"text-align:justify; text-justify:inter-ideograph;";
    NSString *bodyCss = [NSString stringWithFormat:@"body {font-family:PingFangSC-Regular;font-size:%.fpx;%@%@}\n",[GetCurrentFont contentFont].pointSize,styleStr,styleStr2];
    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{bodyCss}}" withString:bodyCss];
    
    //Temp目录下的js文件在根路径，因此需要在加载HTMLString时指定根路径
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    //加载HTMLString
    [self.webView loadHTMLString:tempHtml baseURL:baseURL];
}

//第三种加载方式
-(void)theThirdLoadWebView
{
    NewsDetailsModel *headModel = [NewsDetailsModel new];
    headModel.newsHtml = self.newsModel.fullContent;
    self.headerView.model = headModel;
}

//下载图片
- (void)downloadImageWithUrl:(NSString *)src {
    
    [[SDWebImageManager sharedManager] loadImageWithURL:UrlWithStr(src) options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) {
            GGLog(@"下载图片失败 url: %@", src);
        }else{
            NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
            
            if (![data writeToFile:localPath atomically:NO]) {
                GGLog(@"写入本地失败 url：%@", src);
            }
        }
    }];
}

//md5处理
- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

#pragma mark - 获取HTML元素属性值

- (NSString *)getElementAttributeValueWithElement:(NSString *)element Attribute:(NSString *)attribute{
    
    NSString *value = nil;
    
    if (element && element.length && attribute && attribute.length) {
        
        // 去除空格
        
        element = [element stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSArray *array = nil;
        
        if ([element rangeOfString:[NSString stringWithFormat:@"%@=\"" , attribute]].location != NSNotFound) {
            
            array = [element componentsSeparatedByString:[NSString stringWithFormat:@"%@=\"" , attribute]];
            
        } else if ([element rangeOfString:[NSString stringWithFormat:@"%@=" , attribute]].location != NSNotFound) {
            
            array = [element componentsSeparatedByString:[NSString stringWithFormat:@"%@=" , attribute]];
        }
        
        if (array.count >= 2) {
            
            NSString *temp = array[1];
            
            NSUInteger loc = [temp rangeOfString:@"\""].location;
            
            if (loc != NSNotFound) {
                
                temp = [temp substringToIndex:loc];
                
                if (temp.length > 0) value = temp;
            }
            
        }
        
    }
    
    return value;
}

//购买弹框提示
-(void)popBuyNotice
{
    UIAlertController *payPopVc = [UIAlertController alertControllerWithTitle:@"确认购买这篇付费文章?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestPayForNews];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [payPopVc addAction:confirm];
    [payPopVc addAction:cancel];
    [self presentViewController:payPopVc animated:YES completion:nil];
}

//让输入框无法进入编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [QACommentInputView showAndSendHandle:^(NSString *inputText) {
        if (![NSString isEmpty:inputText]) {
            [self requestCommentWithComment:inputText];
        }else{
            LRToast(@"请输入有效的内容");
        }
    }];
    
    return NO;
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    GGLog(@"加载完成1");
    [self showBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    //不是投票时才使用这种方法获取真实高度
//    if (!self.isVote) {
//        //获取在html里注入的锚点，得到准确的高度
//        [webView evaluateJavaScript:@"document.getElementById(\"test-div\").offsetTop" completionHandler:^(id data, NSError * _Nullable error) {
//            CGFloat height = [data floatValue];
//            //            GGLog(@"height:%lf",height);
//            //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
//            //设置通知或者代理来传高度
//            //        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
//            self.topWebHeight = height + 10;
//            self.webView.frame = CGRectMake(0, 0, ScreenW, self.topWebHeight);
//            self.tableView.tableHeaderView = self.webView;
//            if (!UserGetBool(@"HaveLoadedWeb")) {
//                [self newLoadWeb];
//                UserSetBool(YES, @"HaveLoadedWeb");
//            }
//        }];
//    }
    
    
    
    
    //修改字体大小 300%
    //    NSString *fontStr = @"100%";
    //    if ([GetCurrentFont contentFont].pointSize == 12) {
    //        fontStr = @"80%";
    //    }else if ([GetCurrentFont contentFont].pointSize == 13){
    //        fontStr = @"90%";
    //    }else if ([GetCurrentFont contentFont].pointSize == 14){
    //        fontStr = @"100%";
    //    }else if ([GetCurrentFont contentFont].pointSize == 15){
    //        fontStr = @"120%";
    //    }else if ([GetCurrentFont contentFont].pointSize == 16){
    //        fontStr = @"150%";
    //    }
    //
    //    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontStr] completionHandler:nil];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        if (self.isVote) {
            [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#cfd3d6'"completionHandler:nil];
        }
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }else{
        //修改字体颜色  #9098b8
        //        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#1a1a1a'"completionHandler:nil];
        //修改背景色
        //        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#ffffff'" completionHandler:nil];
    }
    
    CGFloat y = -titleViewHeight;
    if (firstLoadWeb) {
        y = currentScrollY;
    }
    //滚到标题偏移坐标
    _tableView.contentOffset = CGPointMake(0, y);
    firstLoadWeb = YES;
    
    [self showOrHideLoadView:NO page:2];
    
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.letter-spacing:25px" completionHandler:nil];
    
    //js方法遍历图片添加点击事件 返回图片个数
    /*这块我着重说几句
     逻辑:
     1.遍历获取全部的图片;
     2.生成一个Srting为所有图片的拼接,拼接时拿到所处数组下标;
     3.为图片添加点击事件,并添加数组所处下标
     注意点:
     1.如果仅仅拿到url而无下标的话,网页中如果有多张相同地址的图片 则会发生位置错乱
     2.声明时不要用 var yong let  不然方法添加的i 永远是length的值
     */
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(let i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src +'LQXindex'+ i +'L+Q+X';\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src + 'LQXindex' + i;\
    };\
    };\
    return imgScr;\
    };";
    //注入js方法
    [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    
    @weakify(self);
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        @strongify(self);
        NSString *urlResurlt = result;
        self->allUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"L+Q+X"]];
        if (self->allUrlArray.count >= 2) {
            [self->allUrlArray removeLastObject];// 此时数组为每一个图片的url
        }
    }];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    GGLog(@"加载完成2");

    NSString *requestString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    //    GGLog(@"requestString:%@",requestString);
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]&&!self.webView.loading) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        [self anotherImageBrowser:imageUrl];
        
    }else if ([requestString hasPrefix:@"http"]&&!self.webView.loading) {
        // 拦截点击链接
        [[UIApplication sharedApplication] openURL:UrlWithStr(requestString)];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

//第二种查看图片的方式
-(void)anotherImageBrowser:(NSString *)imageUrl
{
    GGLog(@"点击的图片:%@",imageUrl);
    //获取下标
    NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
    int i = [imageIndex.lastObject intValue];
    
    NSMutableArray *images = [NSMutableArray new];
    for (int j = 0; j < allUrlArray.count; j ++) {
        NSArray *imageArr = [NSMutableArray arrayWithArray:[allUrlArray[j] componentsSeparatedByString:@"LQXindex"]];
        [images addObject:imageArr.firstObject];
    }
    //创建图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = i;
    browser.imageArray = images;
    [browser show];
}

#pragma mark - 图片下载完成通知
-(void)imageDownloadSuccess:(NSNotification *)notify{
    NSString *imgPath = [NSString stringWithFormat:@"%@",notify.object];
    imgPath = [NSString stringWithFormat:@"�file://%@", imgPath];
    NSString *imgName = [imgPath lastPathComponent];
    if (imgPath) {
        [self.bridge callHandler:@"imagesDownloadCompleteHandler" data:@[imgName,imgPath] responseCallback:^(id responseData) {

            NSLog(@"调用完JS后的回调：%@",responseData);
        }];
        
    }
}

#pragma mark -- 下载全部图片
-(void)downloadAllImagesInNative:(NSMutableArray *)imageUrls{
    imgUrls = imageUrls;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //初始化一个置空元素数组
    if (!allImagesOfThisArticle) {
        allImagesOfThisArticle = [[NSMutableArray alloc]init];//本地的一个用于保存所有图片的数组
    }
    
    for (NSUInteger i = 0; i < imageUrls.count; i++) {
        NSString *_url = imageUrls[i];
        
        [manager loadImageWithURL:UrlWithStr(_url) options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) {
                GGLog(@"图片下载完成");
                [self->allImagesOfThisArticle addObject:image];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *imgB64 = [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    
                    //把图片在磁盘中的地址传回给JS
                    NSString *key = [manager cacheKeyForURL:imageURL];
                    NSString *source = [NSString stringWithFormat:@"data:image/png;base64,%@", imgB64];
                    [self.bridge callHandler:@"imagesDownloadComplete" data:@[key,source]];
                });
            }
        }];
    }
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0&&!NoPayedNews) {
        return self.newsModel.advertisements.count;
    }else if (section == 1&&!NoPayedNews) {
        return self.newsModel.relatedNews.count;
    }else if (section == 2){
        return self.commentsArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0&&!NoPayedNews) {
        ADModel *model = self.newsModel.advertisements[indexPath.row];
        HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
        cell3.type = 1;
        cell3.model = model;
        cell = (UITableViewCell *)cell3;
    }else if (indexPath.section == 1&&!NoPayedNews) {
        //        HomePageFirstKindCell *cell0 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        //        cell0.model = self.newsModel.relatedNews[indexPath.row];
        //        cell0.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        //        cell = (UITableViewCell *)cell0;
        id model = self.newsModel.relatedNews[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = (HomePageModel *)model;
            //暂时只分2种
            if (model1.itemType == 100) {//无图
                HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }else{//1图
                HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
        }
        
    }else if (indexPath.section == 2){
        CommentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CommentCellID];
        cell2.tag = indexPath.row;
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        cell2.model = model;
        @weakify(self)
        //点赞
        cell2.praiseBlock = ^(NSInteger row) {
            GGLog(@"点赞的commendId:%@",model.commentId);
            @strongify(self)
            if (model.isPraise) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:2 praiseId:[model.commentId integerValue] commentNum:row];
            }
        };
        //点击头像
        cell2.avatarBlock = ^(NSInteger row) {
            [UserModel toUserInforVcOrMine:[model.userId integerValue]];
        };
        //回复TA
        //        cell2.replayBlock = ^(NSInteger row) {
        //            @strongify(self)
        //            self.parentId = [model.commentId integerValue];
        //            [self.commentInput becomeFirstResponder];
        //        };
        //点击回复
        //        cell2.clickReplay = ^(NSInteger row,NSInteger index) {
        //            GGLog(@"点击了第%ld条回复",index);
        //        };
        //查看全部评论
        //        cell2.checkAllReplay = ^(NSInteger row) {
        //            GGLog(@"点击了查看全部回复");
        //        };
        
        cell = (CommentCell *)cell2;
    }
    [cell addBakcgroundColorTheme];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2&&self.commentsArr.count<=0&&!NoPayedNews){
        return 120;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0&&!NoPayedNews) {
        return 110;
    }else if (section == 1&&self.newsModel.relatedNews.count&&!NoPayedNews) {
        return 40;
    }else if (section == 2){
        if (NoPayedNews) {
            return 230;
        }
        return 40;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0&&!NoPayedNews) {
        headView = [UIView new];
        [headView addBakcgroundColorTheme];
        UIButton *praiseBtn = [UIButton new];
        [praiseBtn addButtonTextColorTheme];
        UILabel *notice = [UILabel new];
        notice.font = PFFontL(13);
        [notice addContentColorTheme];
        
        [headView sd_addSubviews:@[
                                   praiseBtn,
                                   notice,
                                   ]];
        praiseBtn.sd_layout
        .topSpaceToView(headView, 10)
        .centerXEqualToView(headView)
        .widthIs(60)
        .heightEqualToWidth()
        ;
        [praiseBtn setSd_cornerRadius:@30];
        [praiseBtn setNormalTitle:[NSString stringWithFormat:@"%ld",self.newsModel.praiseCount]];
        praiseBtn.layer.borderWidth = 1;
        [praiseBtn setBtnFont:PFFontL(12)];
        [praiseBtn addButtonNormalImage:@"news_unPraise"];
        [praiseBtn setSelectedImage:UIImageNamed(@"news_praised")];
        [praiseBtn setNormalTitleColor:HexColor(#1A1A1A)];
        [praiseBtn setSelectedTitleColor:HexColor(#1282EE)];
        praiseBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 10, 0, 0);
        praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
        praiseBtn.selected = self.newsModel.hasPraised;
        
        if (self.newsModel.hasPraised) {
            praiseBtn.selected = YES;
            praiseBtn.layer.borderColor = HexColor(#1282EE).CGColor;
        }else{
            praiseBtn.selected = NO;
            praiseBtn.layer.borderColor = HexColor(#1A1A1A).CGColor;
        }
        @weakify(self);
        [[praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:3 praiseId:self.newsId commentNum:0];
            }
        }];
        //边框色
        praiseBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            @strongify(self);
            UIButton *btn = item;
            if (self.newsModel.hasPraised) {
                btn.layer.borderColor = HexColor(#1282EE).CGColor;
            }else{
                if (UserGetBool(@"NightMode")) {
                    btn.layer.borderColor = HexColor(#cfd3d6).CGColor;
                }else{
                    btn.layer.borderColor = HexColor(#1A1A1A).CGColor;
                }
            }
        });
        if (self.user.userId == self.newsModel.userId) {
            praiseBtn.enabled = NO;
        }else{
            praiseBtn.enabled = YES;
        }
        
        notice.sd_layout
        .centerXEqualToView(headView)
        .heightIs(14)
        .bottomSpaceToView(headView, 10)
        ;
        [notice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
        notice.text = @"启世录好文章，需要你勤劳的小手指";
        
    }else if (section == 1&&self.newsModel.relatedNews.count&&!NoPayedNews) {
        headView = [UIView new];
        [headView addBakcgroundColorTheme];
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        title.textAlignment = NSTextAlignmentCenter;
        [title addBakcgroundColorTheme];
        
        UIView *line = [UIView new];
        line.backgroundColor = HexColor(#BCD5EE);
        
        [headView sd_addSubviews:@[
                                   title,
                                   line,
                                   ]];
        title.sd_layout
        .centerXEqualToView(headView)
        .centerYEqualToView(headView)
        .heightIs(18)
        ;
        [title setSingleLineAutoResizeWithMaxWidth:100];
        title.text = @"推荐阅读";
        
        line.sd_layout
        .centerXEqualToView(headView)
        .bottomEqualToView(headView)
        .heightIs(4)
        .widthIs(14)
        ;
        [line setSd_cornerRadius:@1];
    }else if (section == 2){
        headView = [UIView new];
        if (NoPayedNews) {
            //添加文本和提示
            UILabel *noticeLabel = [UILabel new];
            noticeLabel.font = PFFontL(16);
            noticeLabel.textColor = HexColor(#1282EE);
            //            [noticeLabel addTitleColorTheme];
            noticeLabel.numberOfLines = 0;
            
            UIImageView *lockImg = [UIImageView new];
            
            UILabel *moreNotice = [UILabel new];
            moreNotice.textColor = HexColor(#1282EE);
            moreNotice.font = PFFontL(16);
            moreNotice.textAlignment = NSTextAlignmentCenter;
            
            [headView sd_addSubviews:@[
                                       //                                       noticeLabel,
                                       moreNotice,
                                       lockImg,
                                       ]];
            noticeLabel.sd_layout
            .leftSpaceToView(headView, 10)
            .rightSpaceToView(headView, 10)
            .topSpaceToView(headView, 10)
            .autoHeightRatio(0)
            ;
            [noticeLabel setMaxNumberOfLinesToShow:4];
            //            noticeLabel.text = @"余下内容为付费内容，价格为199.00积分";
            
            moreNotice.sd_layout
            //            .bottomSpaceToView(headView, 50)
            .topSpaceToView(headView, 12)
            .leftSpaceToView(headView, 10)
            .rightSpaceToView(headView, 10)
            .heightIs(14)
            ;
            moreNotice.text = [NSString stringWithFormat:@"余下内容为付费内容，价格为%ld积分",self.newsModel.points];
            
            lockImg.sd_layout
            .centerXEqualToView(headView)
            //            .bottomSpaceToView(moreNotice, 10)
            .topSpaceToView(moreNotice, 20)
            .widthIs(54)
            .heightEqualToWidth()
            ;
            [lockImg setSd_cornerRadius:@27];
            //            lockImg.image = UIImageNamed(@"new_locked");
            lockImg.image = UIImageNamed(@"news_unlock");
            
            //添加点击事件
            @weakify(self);
            [lockImg whenTap:^{
                @strongify(self)

                if ([YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                    if (login) {
                        [self requestNewData];
                    }
                }]) {
                    [self popBuyNotice];
                }
                
            }];
            
        }else if(self.newsModel){
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
            NSInteger count = MAX(self.newsModel.commentCount, self.commentsArr.count);
            if (count) {
                title.text = [NSString stringWithFormat:@"全部评论(%ld)",(long)count];
            }else{
                title.text = @"全部评论";
            }
        }
        
    }
    
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 2&&self.commentsArr.count<=0&&!NoPayedNews) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        footView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        
        UIImageView *imgV = [UIImageView new];
        [footView addSubview:imgV];
        imgV.sd_layout
        .centerXEqualToView(footView)
        .centerYEqualToView(footView)
        .widthIs(156)
        .heightIs(90)
        ;
        imgV.lee_theme.LeeConfigImage(@"noCommentFoot");
        
    }
    
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GGLog(@"tableView点击了");
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        ADModel *model = self.newsModel.advertisements[indexPath.row];
        [UniversalMethod jumpWithADModel:model];
    }else if (indexPath.section == 1) {
        HomePageModel *model = self.newsModel.relatedNews[indexPath.row];
        if (model.itemType>=400&&model.itemType<500) { //投票
            VoteViewController *vVC = [VoteViewController new];
            vVC.newsId = model.itemId;
            [self.navigationController pushViewController:vVC animated:YES];
        }else if (model.itemType>=500&&model.itemType<600) { //问答
            CatechismViewController *cVC = [CatechismViewController new];
            cVC.news_id = model.itemId;
            [self.navigationController pushViewController:cVC animated:YES];
        }else if (model.itemType>=200&&model.itemType<300) {    //专题
            TopicViewController *tVC = [TopicViewController new];
            tVC.topicId = model.topicId;
            [self.navigationController pushViewController:tVC animated:YES];
        }else{
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = model.itemId;
            [self.navigationController pushViewController:ndVC animated:YES];
        }
    }else if (indexPath.section == 2) {
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        CommentDetailViewController *cdVC = [CommentDetailViewController new];
        cdVC.model = model;
        [self.navigationController pushViewController:cdVC animated:YES];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    GGLog(@"touchesBegan点击了");
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    //    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    //    GGLog(@"y：%lf",self.tableView.contentOffset.y);
    //    GGLog(@"-titleViewHeight：%lf",-titleViewHeight);
    
    if (self.attentionBtn.enabled) {
        //如果大于，说明tableView偏移量已经看不到头像等信息了
        if (self.tableView.contentOffset.y + titleViewHeight >=bottomMargin + 24) {
            GGLog(@"不能点击");
        }else{
            
            if (x >= ScreenW - (attentionBtnW+10)&&x<= ScreenW - 10 && y >= titleViewHeight - bottomMargin - 24/2 - attentionBtnH/2 && y <= titleViewHeight - bottomMargin - 24/2 + attentionBtnH/2) {
                GGLog(@"点击了关注");
                [self requestIsAttention];
            }else if (x >= 10&&x<= (100+10) && y >= titleViewHeight - bottomMargin - 24 && y <= titleViewHeight - bottomMargin) {
                GGLog(@"点击用户部分");
                
                [UserModel toUserInforVcOrMine:self.newsModel.userId];
            }
        }
    }
    
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self processViewAlphaWithView:scrollView];
    // 传递滑动
    
    [self.headerView scroll:scrollView.contentOffset];
}

//处理滚动视图时其他视图的显隐
-(void)processViewAlphaWithView:(UIScrollView *)scrollView
{
//    GGLog(@"scrollViewY:%lf",scrollView.contentOffset.y);
//    GGLog(@"scrollViewY2:%lf",-titleViewHeight);
    CGFloat offsetY = scrollView.contentOffset.y;
    currentScrollY = offsetY;
    
    if (offsetY >= - titleViewHeight&&offsetY < 0) {
        //计算透明度比例
        CGFloat alpha = MAX(0, (titleViewHeight - fabs(offsetY)) / titleViewHeight);
        NSString *process = [NSString stringWithFormat:@"%.1lf",alpha];
//        GGLog(@"process:%@",process);
        self.titleView.alpha = 1 - [process floatValue];
        
        self.attentionBtn.enabled = 1 - [process floatValue];
        self.naviTitle.alpha = [process floatValue];
        self.topAttBtn.alpha = 0;
        
        [self hiddenTopLine];
        
    }else{
//        GGLog(@"process2");
        if (offsetY>0) {
            [self showTopLine];
            self.naviTitle.alpha = 1;
            self.titleView.alpha = 0;
            self.topAttBtn.alpha = 1;
            self.attentionBtn.enabled = NO;
        }else{
            [self hiddenTopLine];
            self.naviTitle.alpha = 0;
            self.titleView.alpha = 1;
            self.topAttBtn.alpha = 0;
            self.attentionBtn.enabled = YES;
        }
    }
}

#pragma mark ----- 发送请求
//获取文章详情
-(void)requestNewData
{
    [self showOrHideLoadView:YES page:2];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self setWebViewLoad];
        
        [self.tableView reloadData];
        
        [HomePageModel saveWithNewsModel:self.newsModel];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取评论列表
-(void)requestComments
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest getWithURLString:ShowComment parameters:parameters success:^(id responseObject) {
        NSArray *arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        self.commentsArr = [self.tableView pullWithPage:self.currPage data:arr dataSource:self.commentsArr];
        
        //        if (self.currPage == 1) {
        //            //            [self.tableView.mj_header endRefreshing];
        //            if (arr.count) {
        //                self.commentsArr = [arr mutableCopy];
        //                [self.tableView.mj_footer endRefreshing];
        //            }else{
        //                [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //            }
        //        }else{
        //            if (arr.count) {
        //                [self.commentsArr addObjectsFromArray:arr];
        //                [self.tableView.mj_footer endRefreshing];
        //            }else{
        //                [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //            }
        //        }
        //
        [self setBottomView];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//回复评论
-(void)requestCommentWithComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    parameters[@"comment"] = comment;
    parameters[@"parentId"] = @(self.parentId);
    
    [HttpRequest postWithTokenURLString:Comments parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        LRToast(@"评论已发送");
        //        self.parentId = 0;
        [self refreshComments];
        //        [self requestNewData];
        //        CompanyCommentModel *commentModel = [CompanyCommentModel new];
        //        commentModel.avatar = UserGet(@"avatar");
        //        commentModel.username = UserGet(@"username");
        //        commentModel.comment = comment;
        //        [self.commentsArr
        //         insertObject:commentModel atIndex:0];
        //        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//点赞文章/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    //做个判断，如果是作者本人，则无法点赞
    if (self.user.userId == self.newsModel.userId) {
        LRToast(@"不可以点赞自己哟");
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if (praiseType == 3) {  //新闻
            LRToast(@"点赞成功");
            self.newsModel.hasPraised = !self.newsModel.hasPraised;
            self.newsModel.praiseCount ++;
            [self setBottomView];
        }else if (praiseType == 2) {
            CompanyCommentModel *model = self.commentsArr[row];
            model.isPraise = !model.isPraise;
            
            if (model.isPraise) {
                LRToast(@"点赞成功");
                model.likeNum ++;
            }else{
                LRToast(@"点赞已取消");
                model.likeNum --;
            }
        }
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//收藏/取消收藏文章
-(void)requestCollectNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:Favor parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        NSInteger status = [res[@"data"][@"status"] integerValue];
        //        if (status == 1) {
        //            LRToast(@"收藏成功");
        //        }else{
        //            LRToast(@"已取消收藏");
        //        }
        self.newsModel.isCollection = status;
        [self setBottomView];
        
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//关注/取消关注
-(void)requestIsAttention
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.newsModel.userId);
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
        self.newsModel.isAttention = status;
        //覆盖之前保存的信息
        //        [UserModel coverUserData:user];
        [self setTitle];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

-(void)getIsFavorAndIsPraise
{
    [self requestIsFavor];
    [self requestIsPraise];
}

//新闻是否被收藏
-(void)requestIsFavor
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:IsFavor parameters:parameters isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
    } failure:nil RefreshAction:^{
        
    }];
}

//新闻是否被点赞
-(void)requestIsPraise
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(3);
    parameters[@"id"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:IsPraise parameters:parameters isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
    } failure:nil RefreshAction:^{
        
    }];
}


//分享方法
-(void)shareToPlatform:(MGShareToPlateform)type
{
#ifdef JoinThirdShare
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DomainString, self.newsModel.freeContentUrl);
    if (self.isVote) {
        urlStr = [NSString stringWithFormat:@"%@%@%@?id=%ld&userId=%ld",DomainString,VersionNum, News_iosContent,self.newsId,self.user.userId];
    }
    if (type == MGShareToSina) {
        //如果分享类型是图文，就一定要给图片或者图片链接，无效或为空都是无法分享的
        shareModel.contentType = MGShareContentTypeText;
        shareModel.content = AppendingString(self.newsModel.newsTitle, urlStr);
        //        shareModel.thumbImage = [UIImage imageNamed:@""];
        //        shareModel.image = @"xxx";
    }else{
        shareModel.contentType = MGShareContentTypeWebPage;
        shareModel.title = self.newsModel.newsTitle;
        shareModel.url = urlStr;
        shareModel.content = self.newsModel.author;
        shareModel.thumbImage = UIImageNamed(@"AppIcon");
        
        if (self.newsModel.images.count>0) {
            shareModel.image = self.newsModel.images[0];
        }
        
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        LRToast(@"分享成功");
        [RequestGather shareWithNewsId:self.newsId Success:nil failure:nil];
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        GGLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
    }];
#endif
}


//支付一篇付费文章
-(void)requestPayForNews
{
    [HttpRequest postWithURLString:PayForNews parameters:@{@"newsId":@(self.newsId)} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"支付成功");
        UserModel *user = [UserModel getLocalUserModel];
        user.integral = [response[@"data"][@"remainPoints"] longValue];
        [UserModel coverUserData:user];
        //        self.newsModel.hasPaid = YES;
        //        [self setWebViewLoad];
        //直接重新拉一遍详情
        [self requestNewData];
    } failure:^(NSError *error) {
        
    } RefreshAction:^{
        [self requestNewData];
    }];
}



@end
