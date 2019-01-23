//
//  ThePostDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostDetailViewController.h"

#import "ToReportViewController.h"

#import "SharePopCopyView.h"

//未付费标记
#define NoPayedPost (self.postModel.isToll==YES&&self.postModel.hasPaid==NO)

@interface ThePostDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,assign) NSInteger currPage;//评论页码
@property (nonatomic,assign) NSInteger sort;

//帖子中包含的图片数组
@property (nonatomic,strong) NSMutableArray *imagesArr;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic,strong) UILabel *level;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) YXLabel *contentLabel;
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) UIButton *topAttBtn; //导航栏上的关注按钮

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;

@property (nonatomic,strong) UIView *naviTitle;

@property (nonatomic,strong) UIView *section2View;
@property (nonatomic,strong) UILabel *allComment;
@property (nonatomic,strong) UIButton *onlyPoster;
@property (nonatomic,strong) UILabel *ascendingLabel;
@property (nonatomic,strong) UILabel *descendingLabel;
//目录按钮
@property (nonatomic,strong) UIButton *directoryBtn;
//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;
//是否只看楼主
@property (nonatomic,assign) NSInteger isOnlyPost;

@property (nonatomic,strong) LeftPopDirectoryViewController *menu;

@property (nonatomic,strong) UserModel *user;
//保存评论时选取的图片等数据
@property (nonatomic,strong) NSDictionary *lastReplyDic;

@property (nonatomic,strong) CharacterLocationSeeker *locationSeeker;

@end

@implementation ThePostDetailViewController
CGFloat static titleViewHeight = 50;
CGFloat static bottomMargin = 15;
CGFloat static attentionBtnW = 66;
CGFloat static attentionBtnH = 26;

-(UserModel *)user
{
    if (!_user) {
        _user = [UserModel getLocalUserModel];
    }
    return _user;
}

-(SeniorPostDataModel *)postModel
{
    if (!_postModel) {
        _postModel = [SeniorPostDataModel new];
    }
    return _postModel;
}

-(NSMutableArray *)imagesArr
{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray new];
        for (int i = 0; i < _postModel.dataSource.count; i ++) {
            SeniorPostingAddElementModel *model = _postModel.dataSource[i];
            //只过滤图片
            if (model.addType == 2) {
                [_imagesArr addObject:model.imageUrl];
            }else{
                continue;
            }
        }
    }
    return _imagesArr;
}

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(CharacterLocationSeeker *)locationSeeker
{
    if (!_locationSeeker) {
        _locationSeeker = [CharacterLocationSeeker new];
    }
    return _locationSeeker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"帖子加载中...";
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left"]];
    
    [self setBaseUI];
    [self requestPost_browsePost];
}

-(void)back
{
    if (self.postModel&&self.commentBlock) {
        NSInteger count = MAX(self.postModel.commentCount, self.commentsArr.count);
        self.commentBlock(count);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

//添加好文标签
-(void)addGoodPostLabel
{
    NSString *titleString = self.postModel.postTitle;
    //创建  NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:titleString];
    
    if (self.postModel.rate>=1) {
        //创建个空白的标签
        NSMutableAttributedString *space = [NSString getLabelWithString:@"" font:5 textColor:WhiteColor backColor:WhiteColor corner:0];
        [maTitleString appendAttributedString:space];
        //创建标签Label
        NSMutableAttributedString *imageStr = [NSString getLabelWithString:@"好文" font:12 textColor:WhiteColor backColor:HexColor(ffb900) corner:3];
        //加入文字后面
        [maTitleString appendAttributedString:imageStr];
    }
    if (self.postModel.rate>=2) {
        //创建个空白的标签
        NSMutableAttributedString *space = [NSString getLabelWithString:@"" font:5 textColor:WhiteColor backColor:WhiteColor corner:0];
        [maTitleString appendAttributedString:space];
        //创建标签Label
        NSMutableAttributedString *imageStr = [NSString getLabelWithString:@"精" font:12 textColor:WhiteColor backColor:HexColor(ff7d05) corner:3];
        //加入文字后面
        [maTitleString appendAttributedString:imageStr];
    }
    
    _titleLabel.attributedText = maTitleString;
    [self showOrHideLoadView:NO page:0];
}

-(void)setNavigationBtns
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(showToReportView) image:UIImageNamed(@"news_more")];
}

//设置基本视图
- (void)setBaseUI
{
    if (_tableView) {
        return;
    }
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#F3F5F4);
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    
    [_tableView registerClass:[PreviewTextTableViewCell class] forCellReuseIdentifier:PreviewTextTableViewCellID];
    [_tableView registerClass:[PreviewImageTableViewCell class] forCellReuseIdentifier:PreviewImageTableViewCellID];
    [_tableView registerClass:[ThePostCommentTableViewCell class] forCellReuseIdentifier:ThePostCommentTableViewCellID];
    [_tableView registerClass:[ThePostCommentReplyTableViewCell class] forCellReuseIdentifier:ThePostCommentReplyTableViewCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing||NoPayedPost) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.currPage = 1;
        [self requestListPostComments:self.currPage];
    }];
    _tableView.mj_footer = [YXBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing||NoPayedPost) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (self.commentsArr.count<=0) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestListPostComments:self.currPage];
    }];
    
    _directoryBtn = [UIButton new];
    [self.view addSubview:_directoryBtn];
    _directoryBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .widthIs(80)
    .heightIs(60)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN + 20)
    ;
    [_directoryBtn setNormalImage:UIImageNamed(@"directory_icon")];
    [_directoryBtn addTarget:self action:@selector(popDirectoryAction) forControlEvents:UIControlEventTouchUpInside];
    _directoryBtn.hidden = YES;
    
    _commentPagingBtn = [UIButton new];
    [self.view addSubview:_commentPagingBtn];
    _commentPagingBtn.sd_layout
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(28)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN + 20)
    ;
    _commentPagingBtn.hidden = YES;
    [_commentPagingBtn addTarget:self action:@selector(popCommentPagingAction) forControlEvents:UIControlEventTouchUpInside];
    _commentPagingBtn.sd_cornerRadius = @3;
    _commentPagingBtn.backgroundColor = HexColor(#45474A);
}

//设置分页按钮
-(void)setUpPageBtn
{
    NSInteger totalPage = self.postModel.commentCount/10;
    if (self.postModel.commentCount%10>0) {
        //说明有余数
        totalPage ++;
    }
    if (totalPage) {
        _commentPagingBtn.hidden = NO;
        [_commentPagingBtn setNormalTitle:[NSString stringWithFormat:@"%ld/%ld",self.currPage,totalPage]];
    }else{
        _commentPagingBtn.hidden = YES;
    }
}

//弹出选择分页的视图
-(void)popCommentPagingAction
{
    SelectCommentPageView *scPV = [SelectCommentPageView new];
    NSInteger totalPage = self.postModel.commentCount/10;
    if (self.postModel.commentCount%10>0) {
        //说明有余数
        totalPage ++;
    }
    //第二个参数给totalPagew是为了不让它显示选中
    [scPV showAllNum:totalPage defaultSelect:totalPage];
    @weakify(self);
    scPV.clickBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        [self pushToCommentPageWithIndex:selectIndex+1];
    };
}

//评论弹框
-(void)popCommentVCWithParentId:(NSInteger)parentId
{
    PopReplyViewController *prVC = [PopReplyViewController new];
    //    prVC.inputData = self.lastReplyDic.mutableCopy;
    @weakify(self);
    prVC.finishBlock = ^(NSDictionary * _Nonnull inputData) {
        GGLog(@"发布回调:%@",inputData);
        @strongify(self);
        self.lastReplyDic = inputData;
        //这里发布后把该数据清空就行了
        [self requestPostCommentWithParentId:parentId comment:inputData[@"text"]];
    };
    prVC.cancelBlock = ^(NSDictionary * _Nonnull cancelData) {
        GGLog(@"取消回调:%@",cancelData);
        @strongify(self);
        self.lastReplyDic = cancelData;
    };
    
    [prVC showFromVC2:self];
}

//跳转评论分页界面
-(void)pushToCommentPageWithIndex:(NSInteger)index
{
    ThePostCommentPagesViewController *tpcpVC = [ThePostCommentPagesViewController new];
    tpcpVC.currPage = index;
    tpcpVC.postModel = self.postModel;
    tpcpVC.refreshBlock = ^{
        //刷新评论
        [self requestListPostComments:1];
    };
    [self.navigationController pushViewController:tpcpVC animated:YES];
}

//设置导航栏标题
-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//        _naviTitle.alpha = 0;
        
        [_naviTitle addBakcgroundColorTheme];
        
        CGFloat wid = 0;
        if (self.postModel.avatar.length>0) {
            wid = 30;
        }
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.postModel.sectionIcon))];
        username.text = GetSaveString(self.postModel.sectionName);
        [username sizeToFit];
        CGFloat labelW = CGRectGetWidth(username.frame);
        if (labelW>150*ScaleW) {
            labelW = 150*ScaleW;
        }
        username.frame = CGRectMake(CGRectGetMaxX(avatar.frame) + 5, 0, labelW, 30);
        [_naviTitle addSubview:username];
        
        _naviTitle.frame = CGRectMake(0, 0, 5 * 2 + wid + username.width, 30);
        
//        @weakify(self);
//        [self.naviTitle whenTap:^{
//            @strongify(self);
//            [UserModel toUserInforVcOrMine:self.postModel.userId];
//        }];
        
        self.navigationItem.titleView = _naviTitle;
        
    }
}

//设置上部分(帖子标题、发布者等信息)
-(void)setTitle
{
    if (!self.titleView) {
        @weakify(self);
        self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        self.titleView.backgroundColor = WhiteColor;
        _titleLabel = [UILabel new];
        _titleLabel.font = PFFontM(20);
        _titleLabel.numberOfLines = 0;
        _titleLabel.isAttributedContent = YES;
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        
        _avatar = [UIImageView new];
        _avatar.contentMode = 2;
        _avatar.layer.masksToBounds = YES;
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(12);
        _authorName.textColor = HexColor(#889199);
        
        _level = [UILabel new];
        _level.font = PFFontM(12);
        _level.textAlignment = NSTextAlignmentCenter;
        _level.textColor = WhiteColor;
        _level.backgroundColor = HexColor(#1282EE);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(12);
        _creatTime.textColor = HexColor(#889199);
        
        _contentLabel = [YXLabel new];
        _contentLabel.font = PFFontL(16);
        _contentLabel.textColor = HexColor(#1A1A1A);
        _contentLabel.textAlignment = NSTextAlignmentJustified;
        
        _attentionBtn = [UIButton new];
        [_attentionBtn setBtnFont:PFFontR(14)];
        [_attentionBtn setNormalTitleColor:WhiteColor];
        [_attentionBtn setSelectedTitleColor:WhiteColor];
        [_attentionBtn setNormalTitle:@" 关注"];
        [_attentionBtn setSelectedTitle:@"已关注"];
        [_attentionBtn setNormalBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)]];
        [_attentionBtn setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#e3e3e3)]];
        
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestIsAttention];
        }];
        
        [self.titleView sd_addSubviews:@[
                                         _titleLabel,
                                         _avatar,
                                         _authorName,
                                         _level,
                                         _idView,
                                         _creatTime,
                                         _attentionBtn,
                                         _contentLabel,
                                         ]];
        _titleLabel.sd_layout
        .topSpaceToView(self.titleView, 10)
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .autoHeightRatio(0)
        ;
        
        _avatar.sd_layout
        .topSpaceToView(_titleLabel, 20)
        .leftEqualToView(_titleLabel)
        .widthIs(0)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        [_avatar whenTap:^{
            @strongify(self);
            [UserModel toUserInforVcOrMine:self.postModel.userId];
        }];
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        
        [_authorName whenTap:^{
            @strongify(self);
            [UserModel toUserInforVcOrMine:self.postModel.userId];
        }];
        
        _level.sd_layout
        .leftSpaceToView(_authorName, 10)
        .centerYEqualToView(_authorName)
        .widthIs(40)
        .heightIs(18)
        ;
        [_level setSd_cornerRadius:@9];
        
        _idView.sd_layout
        .heightIs(20)
        .centerYEqualToView(_level)
        .leftSpaceToView(_level, 10)
        .widthIs(0)
        ;
        [self setIdViewWithIDs];
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(attentionBtnW)
        .heightIs(attentionBtnH)
        ;
        
        [_attentionBtn setSd_cornerRadius:@(attentionBtnH/2)];
        
        _creatTime.sd_layout
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_idView, 5)
        .rightSpaceToView(_attentionBtn, 10)
        .heightIs(12)
        ;
//        [_creatTime setSingleLineAutoResizeWithMaxWidth:150];
        
        _contentLabel.sd_layout
        .topSpaceToView(_attentionBtn, 20)
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .heightIs(0)
        ;
        
        [self.titleView setupAutoHeightWithBottomView:_contentLabel bottomMargin:bottomMargin];
        
        if (![_contentLabel.text isEqualToString:GetSaveString(self.postModel.postContent)]) {
            _contentLabel.text = GetSaveString(self.postModel.postContent);
            CGFloat h = [_contentLabel getLabelWithLineSpace:3 width:ScreenW - 20];
            _contentLabel.sd_layout
            .heightIs(h)
            ;
            [_contentLabel updateLayout];
        }
    }
    
    //设置标题标签
    [self addGoodPostLabel];

    CGFloat wid = 24;
    if (kStringIsEmpty(self.postModel.avatar)) {
        wid = 0;
    }
    _avatar.sd_layout
    .widthIs(wid)
    ;
    [_avatar updateLayout];
    [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.postModel.avatar))];
    _authorName.text = GetSaveString(self.postModel.author);
    _level.hidden = self.postModel.level?NO:YES;
    _level.text = [NSString stringWithFormat:@"Lv.%ld",self.postModel.level];
    _creatTime.text = GetSaveString(self.postModel.createTime);
    
    _attentionBtn.selected = self.postModel.isAttention;
    if (_attentionBtn.selected) {
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    //如果是用户本人发布的文章，就不显示关注的按钮
    if (![UserModel showAttention:self.postModel.userId]) {
        [_attentionBtn setHidden:YES];
        [self.topAttBtn setHidden:YES];
    }
    
    _tableView.tableHeaderView = self.titleView;
    
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.postModel.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.postModel.identifications.count; i ++) {
            NSDictionary *model = self.postModel.identifications[i];
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
            if (i == self.postModel.identifications.count - 1) {
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
        [self.bottomView addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
        
        UILabel *commentInput = [UILabel new];
        commentInput.font = PFFontL(15);
        commentInput.textColor = HexColor(#949899);
        commentInput.textAlignment = NSTextAlignmentCenter;
        commentInput.backgroundColor = HexColor(#F4F4F4);
        
        _praiseBtn = [UIButton new];
        _collectBtn = [ZXYShineButton new];
        UIButton *shareBtn = [UIButton new];
        
        @weakify(self)
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:9 praiseId:self.postModel.postId commentNum:0];
            }
        }];
        
        [[_collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestCollectNews];
        }];
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self getShareData];
        }];
        
        [commentInput whenTap:^{
            @strongify(self);
            BOOL isLogin = [YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                if (login) {
                    [self requestPost_browsePost];
                }
            }];
            if (isLogin) {
                if (!self.postModel.hasExpired) {
                    [self popCommentVCWithParentId:0];
                }else{
                    LRToast(@"发布时间超过3个月的帖子禁止回复");
                }
            }
            
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          _collectBtn,
                                          _praiseBtn,
                                          commentInput,
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
        
        ZXYShineParams *params = [ZXYShineParams new];
        _collectBtn.norImg = UIImageNamed(@"news_unCollect");
        _collectBtn.selImg = UIImageNamed(@"news_collected");
        _collectBtn.color = HexColor(#1A1A1A);      //未选中时的颜色
        _collectBtn.fillColor = HexColor(#ef9f00);  //选中后的填充色
        params.bigShineColor = HexColor(#ef9f00);
        params.smallShineColor = RedColor;
        _collectBtn.params = params;
        
        _praiseBtn.sd_layout
        .rightSpaceToView(_collectBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn addButtonNormalImage:@"news_unPraise"];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 23)
        .rightSpaceToView(_praiseBtn, 30)
        .centerYEqualToView(self.bottomView)
        .heightIs(34)
        ;
        [commentInput updateLayout];
        [commentInput setSd_cornerRadius:@17];
        commentInput.text = @"有何高见，展开讲讲";
//        if (self.postModel.hasExpired) {
//            commentInput.text = @"帖子失效,不可评论";
//        }
    }
    self.bottomView.hidden = NO;
    self.collectBtn.selected = self.postModel.isCollection;
    self.praiseBtn.selected = self.postModel.hasPraised;
    self.bottomView.hidden = NO;
    if (self.user.userId == self.postModel.userId) {
        self.praiseBtn.enabled = NO;
    }else{
        self.praiseBtn.enabled = YES;
    }
}

//检查是否需要显示目录按钮
-(void)reloadDataWithDataArrUpperCase
{
    int j = 1;//标记有几个小标题分区
    if (self.postModel.dataSource.count>0) {
        //遍历数据源
        for (int i = 0; i < self.postModel.dataSource.count; i ++) {
            SeniorPostingAddElementModel *model = self.postModel.dataSource[i];
            if (model.addType==0) {//说明是小标题
                //标记是第几个小分区标题
                model.sectionNum = j;
                j ++;
            }
        }
    }
    
    if (j == 1) {   //j没有变化，说明没有小标题了，隐藏目录按钮
        _directoryBtn.hidden = YES;
    }else{
        _directoryBtn.hidden = NO;
    }
    [self.tableView reloadData];
}

//弹出目录侧边栏
-(void)popDirectoryAction
{
    self.menu = [LeftPopDirectoryViewController new];
    self.menu.dataSource = self.postModel.dataSource;
    self.menu.view.frame = CGRectMake(0, 0, 260, ScreenH);
    [self.menu initSlideFoundationWithDirection:SlideDirectionFromLeft];
    [self.menu show];
    
    @weakify(self);
    self.menu.clickBlock = ^(NSInteger index) {
        @strongify(self);
        GGLog(@"滚动至下标为:%ld的cell",index);
        [self.tableView scrollToRow:index inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
}

//设置分区2的分区头
-(void)setSecion2
{
    if (!_section2View) {
        _section2View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 48)];
        _section2View.backgroundColor = WhiteColor;
        _allComment = [UILabel new];
        _ascendingLabel = [UILabel new];
        _descendingLabel = [UILabel new];
        UILabel *sepLine = [UILabel new];
        UIView *rightView = [UIView new];
        //只看楼主按钮
        _onlyPoster = [UIButton new];
        [_onlyPoster setNormalImage:UIImageNamed(@"onlyPost_unSelect")];
        [_onlyPoster setSelectedImage:UIImageNamed(@"onlyPost_selected")];
        [_onlyPoster addTarget:self action:@selector(checkPostCommet:) forControlEvents:UIControlEventTouchUpInside];
        
        [_section2View sd_addSubviews:@[
                                        _allComment,
                                        _onlyPoster,
                                        rightView,
                                        
                                        ]];
        _allComment.sd_layout
        .centerYEqualToView(_section2View)
        .leftSpaceToView(_section2View, 10)
        .heightIs(18)
        ;
        [_allComment setSingleLineAutoResizeWithMaxWidth:200];
        _allComment.font = PFFontR(14);
        
        _onlyPoster.sd_layout
        .leftSpaceToView(_allComment, 10)
        .centerYEqualToView(_section2View)
        .widthIs(35)
        .heightIs(19)
        ;
        
        rightView.sd_layout
        .rightSpaceToView(_section2View, 10)
        .centerYEqualToView(_section2View)
        .heightIs(30)
        ;
        
        [rightView sd_addSubviews:@[
                                    _ascendingLabel,
                                    sepLine,
                                    _descendingLabel,
                                    
                                    ]];
        
        _ascendingLabel.sd_layout
        .centerYEqualToView(rightView)
        .leftSpaceToView(rightView, 0)
        .widthIs(25)
        .heightIs(18)
        ;
        _ascendingLabel.font = PFFontL(12);
        _ascendingLabel.textColor = HexColor(#1282EE);
        _ascendingLabel.text = @"正序";
        _ascendingLabel.tag = 10086;
        
        sepLine.sd_layout
        .centerYEqualToView(rightView)
        .leftSpaceToView(_ascendingLabel, 0)
        .widthIs(10)
        .heightIs(18)
        ;
        sepLine.font = PFFontL(11);
        sepLine.textColor = HexColor(#ABB2C3);
        sepLine.text = @"/";
        
        _descendingLabel.sd_layout
        .centerYEqualToView(rightView)
        .leftSpaceToView(sepLine, 0)
        .widthIs(25)
        .heightIs(18)
        ;
        _descendingLabel.font = PFFontL(12);
        _descendingLabel.textColor = HexColor(#ABB2C3);
        _descendingLabel.text = @"倒序";
        
        [rightView setupAutoWidthWithRightView:_descendingLabel rightMargin:0];
        
        @weakify(self);
        [rightView whenTap:^{
            @strongify(self);
            [self sortAction];
        }];
    }
    _onlyPoster.hidden = self.postModel.commentCount>0?NO:YES;
    _allComment.text = [NSString stringWithFormat:@"全部评论（%ld）",self.postModel.commentCount];
}

//排序显示方法
-(void)sortAction
{
    if (self.ascendingLabel.tag == 10086) {
        _sort = 1;
        self.ascendingLabel.tag = 10010;
        self.ascendingLabel.textColor = HexColor(#ABB2C3);
        self.descendingLabel.textColor = HexColor(#1282EE);
    }else{
        _sort = 0;
        self.ascendingLabel.tag = 10086;
        self.ascendingLabel.textColor = HexColor(#1282EE);
        self.descendingLabel.textColor = HexColor(#ABB2C3);
    }
    ShowHudOnly;
    [self requestListPostComments:1];
}

//只看楼主
-(void)checkPostCommet:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _isOnlyPost = YES;
    }else{
        _isOnlyPost = NO;
    }
    self.currPage = 1;
    [self requestListPostComments:self.currPage];
}

//点击评论回复弹框
-(void)clickCommentPopAlertWith:(PostReplyModel *)replyModel
{
    if (self.postModel.hasExpired) {
        LRToast(@"发布时间超过3个月的帖子禁止回复");
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction *reply = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self popCommentVCWithParentId:replyModel.commentId];
    }];
    
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = replyModel.comment;
        LRToast(@"内容已复制");
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:reply];
    [alertVC addAction:copy];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//查看图片的方式
-(void)showImageBrowser:(NSString *)imageUrl
{
    GGLog(@"点击的图片:%@",imageUrl);
    //获取下标
    int i = (int)[self.imagesArr indexOfObject:imageUrl];
    //创建图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = i;
    browser.imageArray = self.imagesArr;
    [browser show];
}

//举报弹框
-(void)showToReportView
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    @weakify(self);
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        ToReportViewController *tpVC = [ToReportViewController new];
        tpVC.postModel = self.postModel;
        [self.navigationController pushViewController:tpVC animated:YES];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:report];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//购买弹框提示
-(void)popBuyNotice
{
    UIAlertController *payPopVc = [UIAlertController alertControllerWithTitle:@"确认购买这篇付费帖子?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestPayForPost];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [payPopVc addAction:confirm];
    [payPopVc addAction:cancel];
    [self presentViewController:payPopVc animated:YES completion:nil];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.postModel.dataSource.count;
    }
    if (section == 2&&!NoPayedPost) {
        return self.commentsArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        SeniorPostingAddElementModel *model = self.postModel.dataSource[indexPath.row];
        //标题、文本
        if(model.addType == 0||model.addType == 1)
        {
            PreviewTextTableViewCell *cell01 = (PreviewTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PreviewTextTableViewCellID];
            cell01.model = model;
            cell = cell01;
        }else{  //图片、视频
            PreviewImageTableViewCell *cell2 = (PreviewImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PreviewImageTableViewCellID];
            cell2.model = model;
            cell = cell2;
        }
        if (NoPayedPost) {
            [cell.contentView removeAllSubviews];
            UILabel *notice = [UILabel new];
            notice.textColor = WhiteColor;
            notice.font = PFFontM(18);
            notice.backgroundColor = LightGrayColor;
            notice.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:notice];
            notice.sd_layout
            .spaceToSuperView(UIEdgeInsetsMake(5, 10, 5, 10))
            ;
            notice.text = @"购买后方可浏览";
        }
        
    }else if (indexPath.section == 2){
        ThePostCommentReplyTableViewCell *cell2 = (ThePostCommentReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentReplyTableViewCellID];
        PostReplyModel *replyModel = self.commentsArr[indexPath.row];
        cell2.tag = indexPath.row;
        cell2.model = replyModel;
        @weakify(self);
        cell2.avatarBlock = ^(NSInteger row) {
            [UserModel toUserInforVcOrMine:replyModel.userId];
        };
        cell2.praiseBlock = ^(NSInteger row) {
            @strongify(self);
            if(self.user.userId == replyModel.userId){
                LRToast(@"不可以点赞自己哟");
            }else if (replyModel.praise) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:10 praiseId:replyModel.commentId commentNum:indexPath.row];
            }
        };
        
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0&&self.postModel.createTime) {
        return 110;
    }else if (section == 1){
        return 10;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    
    if (section == 0&&self.postModel.createTime) {
        footView = [UIView new];
        [footView addBakcgroundColorTheme];
        if (NoPayedPost) {
            //添加文本和提示
            UIImageView *lockImg = [UIImageView new];
            
            UILabel *moreNotice = [UILabel new];
            moreNotice.textColor = HexColor(#1282EE);
            moreNotice.font = PFFontL(16);
            moreNotice.textAlignment = NSTextAlignmentCenter;
            
            [footView sd_addSubviews:@[
                                       moreNotice,
                                       lockImg,
                                       ]];
            moreNotice.sd_layout
            .topSpaceToView(footView, 12)
            .leftSpaceToView(footView, 10)
            .rightSpaceToView(footView, 10)
            .heightIs(14)
            ;
            moreNotice.text = [NSString stringWithFormat:@"余下内容为付费内容，价格为%ld积分",self.postModel.points];
            
            lockImg.sd_layout
            .centerXEqualToView(footView)
            .topSpaceToView(moreNotice, 20)
            .widthIs(54)
            .heightEqualToWidth()
            ;
            [lockImg setSd_cornerRadius:@27];
            lockImg.image = UIImageNamed(@"news_unlock");
            
            //添加点击事件
            @weakify(self);
            [lockImg whenTap:^{
                @strongify(self)
                
                if ([YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                    if (login) {
                        [self requestPost_browsePost];
                    }
                }]) {
                    [self popBuyNotice];
                }
                
            }];
            return footView;
        }
        
        UIButton *praiseBtn = [UIButton new];
        [praiseBtn addButtonTextColorTheme];
        UILabel *notice = [UILabel new];
        notice.font = PFFontL(13);
        [notice addContentColorTheme];
        
        [footView sd_addSubviews:@[
                                   praiseBtn,
                                   notice,
                                   ]];
        praiseBtn.sd_layout
        .topSpaceToView(footView, 10)
        .centerXEqualToView(footView)
        .widthIs(60)
        .heightEqualToWidth()
        ;
        [praiseBtn setSd_cornerRadius:@30];
        [praiseBtn setNormalTitle:[NSString stringWithFormat:@"%ld",self.postModel.praiseCount]];
        praiseBtn.layer.borderWidth = 1;
        [praiseBtn setBtnFont:PFFontL(12)];
        [praiseBtn addButtonNormalImage:@"news_unPraise"];
        [praiseBtn setSelectedImage:UIImageNamed(@"news_praised")];
        [praiseBtn setNormalTitleColor:HexColor(#1A1A1A)];
        [praiseBtn setSelectedTitleColor:HexColor(#1282EE)];
        praiseBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 10, 0, 0);
        praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
        praiseBtn.selected = self.postModel.hasPraised;
        
        if (self.postModel.hasPraised) {
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
                [self requestPraiseWithPraiseType:9 praiseId:self.postModel.postId commentNum:0];
            }
        }];
        //边框色
        if (self.postModel.hasPraised) {
            self.praiseBtn.layer.borderColor = HexColor(#1282EE).CGColor;
        }else{
            self.praiseBtn.layer.borderColor = HexColor(#1A1A1A).CGColor;
        }
        if (self.user.userId == self.postModel.userId) {
            praiseBtn.enabled = NO;
        }else{
            praiseBtn.enabled = YES;
        }
        
        notice.sd_layout
        .centerXEqualToView(footView)
        .heightIs(14)
        .bottomSpaceToView(footView, 10)
        ;
        [notice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
        notice.text = @"名利场好帖子，需要你勤劳的小手指";
        
    }
    
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2&&!NoPayedPost) {
        return 48;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 2&&!NoPayedPost) {
        [self setSecion2];
        headView = self.section2View;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (NoPayedPost) {
            return;
        }
        SeniorPostingAddElementModel *model = self.postModel.dataSource[indexPath.row];
        if (model.addType == 3) {
            //使用AV播放视频(iOS9.0以后适用,支持画中画)
            AVPlayerViewController *avVC = [[AVPlayerViewController alloc]init];
            //本地地址
            NSURL *url = [NSURL fileURLWithPath:model.videoUrl];
            //网络地址
            url = UrlWithStr(model.videoUrl);
            avVC.player = [[AVPlayer alloc]initWithURL:url];
            [self presentViewController:avVC animated:YES completion:^{
                //跳转后自动播放
                [avVC.player play];
            }];
        }else if(model.addType == 2){
            //图片
            if (model.imageUrl) {
               [self showImageBrowser:model.imageUrl];
            }
        }
    }else if (indexPath.section == 2) {
        PostReplyModel *replyModel = self.commentsArr[indexPath.row];
        [self clickCommentPopAlertWith:replyModel];
    }
}

#pragma mark --请求
//获取帖子详情
-(void)requestPost_browsePost
{
    [self showOrHideLoadView:YES page:0];
    [HttpRequest getWithURLString:Post_browsePost parameters:@{@"postId":@(self.postModel.postId)} success:^(id responseObject) {
        self.postModel = [SeniorPostDataModel mj_objectWithKeyValues:responseObject[@"data"]];

        //保存浏览历史
        [PostHistoryModel saveHistory:self.postModel];
        for (int i = 0; i < self.postModel.dataSource.count; i ++) {
            SeniorPostingAddElementModel *element = self.postModel.dataSource[i];
            if (element.addType == 3) {
                //获取视频第一帧保存进模型
                UIImage *cover = [UIImage firstFrameWithVideoURL:UrlWithStr(element.videoUrl) size:CGSizeMake(element.imageW, element.imageH)];
                element.imageData = cover.base64String;
            }
        }
        [self setNavigationBtns];
        [self setTitle];
        [self setNaviTitle];
        if (NoPayedPost) {
            self.bottomView.hidden = YES;
            self.tableView.sd_resetLayout
            .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0))
            ;
            [self.tableView reloadData];
            return ;
        }
        [self setBottomView];
        [self reloadDataWithDataArrUpperCase];
        [self.tableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

//关注/取消关注
-(void)requestIsAttention
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.postModel.userId);
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
        self.postModel.isAttention = status;
        //覆盖之前保存的信息
        //        [UserModel coverUserData:user];
        [self setTitle];
        //发出关注人数变化的通知
        [kNotificationCenter postNotificationName:AttentionPeopleChanged object:nil];
    } failure:nil RefreshAction:^{
        [self requestPost_browsePost];
    }];
}

//点赞帖子/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    //做个判断，如果是作者本人，则无法点赞
    if (self.user.userId == self.postModel.userId&&praiseType == 9) {
        LRToast(@"不可以点赞自己哟");
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if (praiseType == 9) {  //帖子
            LRToast(@"点赞成功");
            self.postModel.hasPraised = !self.postModel.hasPraised;
            self.postModel.praiseCount ++;
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
            [self setBottomView];
        }else if (praiseType == 10) {   //帖子评论
            PostReplyModel *replyModel = self.commentsArr[row];
            replyModel.praise = !replyModel.praise;
            if (replyModel.praise) {
                LRToast(@"点赞成功");
                replyModel.likeNum ++;
            }else{
                LRToast(@"点赞已取消");
                replyModel.likeNum --;
            }
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } failure:nil RefreshAction:^{
        [self requestPost_browsePost];
    }];
}

//收藏/取消收藏帖子
-(void)requestCollectNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"postId"] = @(self.postModel.postId);
    [HttpRequest postWithTokenURLString:Post_favor parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        NSInteger status = [res[@"data"][@"status"] integerValue];
        //        if (status == 1) {
        //            LRToast(@"收藏成功");
        //        }else{
        //            LRToast(@"已取消收藏");
        //        }
        self.postModel.isCollection = status;
        [self setBottomView];
        
    } failure:nil RefreshAction:^{
        [self requestPost_browsePost];
    }];
}

//帖子评论列表
-(void)requestListPostComments:(NSInteger)page
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"postId"] = @(self.postModel.postId);
    parameters[@"currPage"] = @(page);
    parameters[@"sort"] = @(self.sort);
    parameters[@"author"] = @(self.isOnlyPost);
    
    [HttpRequest getWithURLString:ListPostComments parameters:parameters success:^(id responseObject) {
        HiddenHudOnly;
        NSArray *commentArr = [PostReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        self.commentsArr = [self.tableView pullWithPage:page data:commentArr dataSource:self.commentsArr];
        self.currPage = page;
        [self setUpPageBtn];
        //直接刷新分区会出现高度错误的bug
//        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.tableView endAllRefresh];
    }];
}

//发送评论、回复
-(void)requestPostCommentWithParentId:(NSInteger)parentId comment:(NSString *)comment
{
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"postId"] = @(self.postModel.postId);
    parameters[@"comment"] = comment;
    if (parentId!=0) {
        parameters[@"parentId"] = @(parentId);
    }
    
    [HttpRequest postWithURLString:PostComment parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        self.lastReplyDic = nil;
        self.postModel.commentCount ++;
        if (self.commentBlock) {
            self.commentBlock(self.postModel.commentCount);
        }
        [self requestListPostComments:1];
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
}

//获取分享链接
-(void)getShareData
{
    ShowHudOnly;
    [HttpRequest getWithURLString:GetShareText parameters:nil success:^(id responseObject) {
        
        HiddenHudOnly;
        
        [SharePopCopyView showWithData:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
    }];
    
}

//购买帖子
-(void)requestPayForPost
{
    [HttpRequest postWithURLString:PostPurchasePost parameters:@{@"postId":@(self.postModel.postId)} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"支付成功");
        //直接重新拉一遍详情
        [self requestPost_browsePost];
    } failure:nil RefreshAction:^{
        [self requestPost_browsePost];
    }];
}

@end
