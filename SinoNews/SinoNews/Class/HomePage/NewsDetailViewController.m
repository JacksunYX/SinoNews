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

#import "HomePageModel.h"
#import "FontAndNightModeView.h"
#import "ShareAndFunctionView.h"


//未付费标记
#define NoPayedNews (self.newsModel.isToll&&self.newsModel.hasPaid==0)

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *allUrlArray;
    UIScrollView *bgView;
}

@property (nonatomic,strong) UITextField *commentInput;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@property (nonatomic,strong) WKWebView *webView;
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

@end

@implementation NewsDetailViewController

CGFloat static titleViewHeight = 91;
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
        _topAttBtn.layer.cornerRadius = 5;
        _topAttBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_topAttBtn addTarget:self action:@selector(requestIsAttention) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topAttBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];

    [self hiddenTopLine];

    [self requestNewData];
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
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more_night" hightimage:nil andTitle:@""];
//            UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts_night" hightimage:nil andTitle:@""];
            UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [topBtnView addSubview:self.topAttBtn];
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:topBtnView];
            
            self.navigationItem.rightBarButtonItems = @[more,barbtn];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
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
        _titleLabel.font = PFFontM(22);
        _titleLabel.numberOfLines = 0;
        [_titleLabel addTitleColorTheme];
        
        _avatar = [UIImageView new];
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(11);
        _authorName.textColor = RGBA(152, 152, 152, 1);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(11);
        _creatTime.textColor = RGBA(152, 152, 152, 1);
        
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
        .widthIs(58)
        .heightIs(20)
        ;
        
        [_attentionBtn setSd_cornerRadius:@8];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:10];
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
    titleViewHeight = self.titleView.height;
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
//    GGLog(@"titleView自适应高度为：%lf",self.titleView.height);
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
        CGFloat wid = 20;
        CGFloat hei = 20;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.newsModel.identifications.count; i ++) {
            NSDictionary *model = self.newsModel.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            
            approveView.sd_layout
            .centerYEqualToView(_idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
            [approveView setSd_cornerRadius:@(wid/2)];
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            
            lastView = approveView;
            if (i == self.newsModel.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:approveView rightMargin:0];
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
        [_tableView.mj_footer beginRefreshing];
//        [self refreshComments];
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
//    [_tableView updateLayout];
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
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
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
        [self setWebViewLoad];
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
            [self shareToPlatform:sharePlateform];
        }else if (section==1) {
            if (row == 0) {
                [self fontsSelect];
            }else if (row == 1) {
                [self.webView reload];
            }else if (row == 2) {
                [self requestCollectNews];
            }else if (row == 3) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
                LRToast(@"链接已复制");
            }
            
        }
    }];
    
}

//设置网页
-(void)setWebViewLoad
{
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
    //默认高度给1，防止网页是纯图片时无法撑开
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
    self.webView.navigationDelegate = self;
    [self.webView addBakcgroundColorTheme];
    self.webView.scrollView.delegate = self;
//    self.webView.userInteractionEnabled = NO;
    
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
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);

    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
//    [self.webView loadHTMLString:GetSaveString(self.newsModel.fullContent) baseURL:nil];
    [self showOrHideLoadView:YES page:2];
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
    
    [self showBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    //向上滚动一个像素点防止titleview不显示
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + 1) animated:YES];
    
    [self showOrHideLoadView:NO page:2];
    
    
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
//        CGFloat height = [data floatValue];
//        GGLog(@"height:%lf",height);
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        //设置通知或者代理来传高度
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
//    }];
    
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
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#cfd3d6'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
    
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
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        if (bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            bgView.alpha = 1;
//            NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
//            int i = [imageIndex.lastObject intValue];
//            [bgView setContentOffset:CGPointMake(ScreenW *i, 0)];
//        }else{
            [self showBigImage:imageUrl];//创建视图并显示图片
//        }
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark 显示大图片
-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    bgView.contentSize = CGSizeMake(ScreenW *allUrlArray.count, bgView.bounds.size.height);
    bgView.pagingEnabled = YES;
    [self.view addSubview:bgView];
    
    //创建显示图像视图
    for (int i = 0; i < allUrlArray.count; i++) {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW *i, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        [bgView addSubview:borderView];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
        imgView.contentMode = 1;
        @weakify(self);
        [imgView whenTap:^{
            @strongify(self);
            [self hiddenBigImage];
        }];
        
        NSArray *imageIndex = [NSMutableArray arrayWithArray:[allUrlArray[i] componentsSeparatedByString:@"LQXindex"]];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageIndex.firstObject] placeholderImage:nil];
        
        [borderView addSubview:imgView];
        
    }
    NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
    
    
    int i = [imageIndex.lastObject intValue];
    [bgView setContentOffset:CGPointMake(ScreenW *i, 0)];
    
}

//隐藏图片浏览
-(void)hiddenBigImage
{
    [UIView animateWithDuration:0.5 animations:^{
        self->bgView.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *subview in self->bgView.subviews) {
            [subview removeFromSuperview];
        }
    }];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1&&!NoPayedNews) {
        return self.newsModel.relatedNews.count;
    }else if (section == 2){
        return self.commentsArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 1&&!NoPayedNews) {
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
        return 30;
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
        headView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
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
        .widthIs(60)
        .heightEqualToWidth()
        .centerXEqualToView(headView)
        .topSpaceToView(headView, 10)
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
        .bottomSpaceToView(headView, 17)
        ;
        [notice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
        notice.text = @"启世录好文章，需要你勤劳的小手指";
        
    }else if (section == 1&&self.newsModel.relatedNews.count&&!NoPayedNews) {
        headView = [UIView new];
        headView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        title.textAlignment = NSTextAlignmentCenter;
        title.lee_theme.LeeConfigTextColor(@"titleColor");
        UIView *line = [UIView new];
//        line.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
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
            noticeLabel.text = @"余下内容为付费内容，价格为199.00积分";
            
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
                [self requestPayForNews];
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
//        .topEqualToView(footView)
//        .bottomEqualToView(footView)
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
    if (indexPath.section == 1) {
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
        //如果大于，说明tableView便宜量已经看不到头像等信息了
        if (self.tableView.contentOffset.y + titleViewHeight >=10 + 24) {
            GGLog(@"不能点击");
        }else{

            if (x >= ScreenW - (58+10)&&x<= ScreenW - 10 && y >= titleViewHeight - 10 - 24/2 - 20/2 && y <= titleViewHeight - 10 - 24/2 + 20/2) {
                GGLog(@"点击了关注");
                [self requestIsAttention];
            }else if (x >= 10&&x<= (100+10) && y >= titleViewHeight - 10 - 24 && y <= titleViewHeight - 10) {
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
    
}

//处理滚动视图时其他视图的显隐
-(void)processViewAlphaWithView:(UIScrollView *)scrollView
{
//    GGLog(@"y:%lf",scrollView.contentOffset.y);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= - titleViewHeight - 1&&offsetY <= 0) {
        //计算透明度比例
        CGFloat alpha = MAX(0, (titleViewHeight - fabs(offsetY)) / titleViewHeight);
        NSString *process = [NSString stringWithFormat:@"%.1lf",alpha];
//        GGLog(@"min:%@",process);
        self.titleView.alpha = 1 - [process floatValue];
        
        self.attentionBtn.enabled = 1 - [process floatValue];
        self.naviTitle.alpha = [process floatValue];
        self.topAttBtn.alpha = 0;
        
        [self hiddenTopLine];
        
    }else{
        if (offsetY>0) {
            [self showTopLine];
            self.naviTitle.alpha = 1;
            self.titleView.alpha = 0;
            self.topAttBtn.alpha = 1;
            self.attentionBtn.enabled = NO;
        }
    }
}

#pragma mark ----- 发送请求
//获取文章详情
-(void)requestNewData
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
        [self setWebViewLoad];
        
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
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
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
}

//支付一篇付费文章
-(void)requestPayForNews
{
    [HttpRequest postWithURLString:PayForNews parameters:@{@"newsId":@(self.newsId)} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"支付成功");
        self.newsModel.hasPaid = YES;
        [self setWebViewLoad];
    } failure:^(NSError *error) {
        
    } RefreshAction:^{
        [self requestNewData];
    }];
}



@end
