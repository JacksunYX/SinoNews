//
//  TheVotePostDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//


#import "TheVotePostDetailViewController.h"

#import "VoteDetailChooseTableViewCell.h"

@interface TheVotePostDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,assign) NSInteger currPage;//评论页码
@property (nonatomic,assign) NSInteger sort;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *oliver;        //好文
@property (nonatomic,strong) UILabel *highQuality;   //精品
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) YXLabel *contentLaebl;
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) UIButton *topAttBtn; //导航栏上的关注按钮

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;

@property (nonatomic,strong) UIView *naviTitle;
//分区0,投票信息相关
@property (nonatomic,strong) UIView *voteDataView;
//投票截止日期
@property (nonatomic,strong) UILabel *asOftheDateLabel;
//时间记录
@property (strong, nonatomic) CountDown *countDown;
//参与人数
@property (nonatomic,strong) UILabel *participantNum;
//分区1
@property (nonatomic,strong) UIView *section1View;
@property (nonatomic,strong) UILabel *allComment;
@property (nonatomic,strong) UILabel *ascendingLabel;
@property (nonatomic,strong) UILabel *descendingLabel;

//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;

@property (nonatomic,strong) UserModel *user;
//保存评论时选取的图片等数据
@property (nonatomic,strong) NSDictionary *lastReplyDic;
//多选时保存的已选项数组
@property (nonatomic,strong) NSMutableArray *selectChooseArr;

@end

@implementation TheVotePostDetailViewController
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

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(NSMutableArray *)selectChooseArr
{
    if (!_selectChooseArr) {
        _selectChooseArr = [NSMutableArray new];
    }
    return _selectChooseArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"帖子加载中...";
    
    [self requestPost_browsePost];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //必须在加载完毕时再计算
    if (self.titleLabel.text.length>0) {
        CGPoint lastPoint = [self.titleLabel getLastCharacterFrame];
        
        CGFloat totalW = 0;
        
        if (self.postModel.rate == 1) {
            //好文
            totalW = 45;
            _oliver.hidden = NO;
            _highQuality.hidden = YES;
            //如果不越行，直接拼接在后面
            if (ScreenW - lastPoint.x - 5 - 20 > totalW) {
                _oliver.sd_resetLayout
                .leftSpaceToView(_titleView,lastPoint.x + 5)
                .topSpaceToView(_titleLabel, -23)
                .widthIs(40)
                .heightIs(18)
                ;
            }else{
                //换行
                _oliver.sd_resetLayout
                .leftSpaceToView(_titleView, 10)
                .topSpaceToView(_titleLabel, 5)
                .widthIs(40)
                .heightIs(18)
                ;
            }
            _oliver.text = @"好文";
            
        }else if (self.postModel.rate == 2) {
            //好文+精
            _oliver.hidden = NO;
            _highQuality.hidden = NO;
            totalW = 75;
            if (ScreenW - lastPoint.x - 10 - 20 > totalW) {
                //直接拼在后面
                _oliver.sd_resetLayout
                .leftSpaceToView(_titleView,lastPoint.x + 5)
                .topSpaceToView(_titleLabel, -23)
                .widthIs(40)
                .heightIs(18)
                ;
            }else{
                //换行拼接
                _oliver.sd_resetLayout
                .leftSpaceToView(_titleView, 10)
                .topSpaceToView(_titleLabel, 5)
                .widthIs(40)
                .heightIs(18)
                ;
            }
            
            _highQuality.sd_resetLayout
            .leftSpaceToView(_oliver, 5)
            .topEqualToView(_oliver)
            .widthIs(25)
            .heightIs(18)
            ;
            
            _oliver.text = @"好文";
            _highQuality.text = @"精";
        }else{
            _oliver.sd_resetLayout
            .leftEqualToView(_titleLabel)
            .topSpaceToView(_titleLabel, 0)
            .widthIs(40)
            .heightIs(0)
            ;
            _oliver.text = @"";
            
            _highQuality.sd_resetLayout
            .leftSpaceToView(_oliver, 5)
            .topSpaceToView(_titleLabel, 0)
            .widthIs(25)
            .heightIs(0)
            ;
            _highQuality.text = @"";
            
            _oliver.hidden = YES;
            _highQuality.hidden = YES;
        }
        
    }
    
}

//设置基本视图
- (void)setBaseUI
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#F3F5F4);
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = HexColor(#E3E3E3);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    
    [_tableView registerClass:[VoteDetailChooseTableViewCell class] forCellReuseIdentifier:VoteDetailChooseTableViewCellID];
    [_tableView registerClass:[ThePostCommentTableViewCell class] forCellReuseIdentifier:ThePostCommentTableViewCellID];
    [_tableView registerClass:[ThePostCommentReplyTableViewCell class] forCellReuseIdentifier:ThePostCommentReplyTableViewCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.currPage = 1;
        [self requestListPostComments:self.currPage];
    }];
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
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
    [_tableView.mj_header beginRefreshing];
    
    _commentPagingBtn = [UIButton new];
    [self.view addSubview:_commentPagingBtn];
    _commentPagingBtn.sd_layout
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(28)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN + 20)
    ;
    _commentPagingBtn.hidden = YES;
    _commentPagingBtn.sd_cornerRadius = @3;
    _commentPagingBtn.backgroundColor = HexColor(#45474A);
    [_commentPagingBtn addTarget:self action:@selector(popCommentPagingAction) forControlEvents:UIControlEventTouchUpInside];
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
//        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:tpcpVC animated:YES];
}

//设置倒计时
-(void)setUpCutdown
{
    //判断是否显示结束
    if (self.postModel.isoVerdue) {
        [self setUpExpired];
        return;
    }
    
    self.countDown = [[CountDown alloc] init];
    @weakify(self);
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        @strongify(self);
        //获取时差
        NSString *jetLag = [NSString getNowTimeWithString:self.postModel.expiredTime];
        if (jetLag) {
            //字符串分割
            NSArray *arr = [jetLag componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"天时分秒"]];
//            GGLog(@"%@", arr);
            //拼接成需要的富文本字符串
            UIColor *labelColor = HexColor(#161A24);
            NSMutableAttributedString *attText1 = [NSString leadString:@"距离结束还有：" tailString:@"" font:PFFontR(13) color:labelColor lineBreak:NO];
            NSMutableAttributedString *attText2 = [NSString leadString:@"" tailString:arr[0] font:PFFontR(13) color:labelColor lineBreak:NO];
            NSMutableAttributedString *attText3 = [NSString leadString:@"天" tailString:arr[1] font:PFFontR(13) color:labelColor lineBreak:NO];
            NSMutableAttributedString *attText4 = [NSString leadString:@"小时" tailString:arr[2] font:PFFontR(13) color:labelColor lineBreak:NO];
            NSMutableAttributedString *attText5 = [NSString leadString:@"分" tailString:arr[3] font:PFFontR(13) color:labelColor lineBreak:NO];
            NSMutableAttributedString *attText6 = [NSString leadString:@"秒" tailString:@"" font:PFFontR(13) color:labelColor lineBreak:NO];
            [attText2 appendAttributedString:attText3];
            [attText2 appendAttributedString:attText4];
            [attText2 appendAttributedString:attText5];
            [attText2 appendAttributedString:attText6];
            [attText1 appendAttributedString:attText2];
            self.asOftheDateLabel.attributedText = attText1;
        }else{
            [self setUpExpired];
            //停止计时器
            [self.countDown destoryTimer];
        }
        
    }];
}

//设置投票已结束
-(void)setUpExpired
{
    self.asOftheDateLabel.text = @"投票已结束";
    //别忘了清空这个数组，以免造成数据错乱
    [self.selectChooseArr removeAllObjects];
    //标记投票已过期
    self.postModel.isoVerdue = YES;
    for (VoteChooseInputModel *model in self.postModel.voteSelects) {
        //不显示可选按钮图标
        model.hiddenSelectIcon = YES;
    }
    //刷新分区0
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

//设置导航栏标题
-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _naviTitle.alpha = 0;
        
        [_naviTitle addBakcgroundColorTheme];
        
        CGFloat wid = 0;
        if (self.postModel.avatar.length>0) {
            wid = 30;
        }
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.postModel.avatar))];
        
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        username.text = GetSaveString(self.postModel.author);
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
            [UserModel toUserInforVcOrMine:self.postModel.userId];
        }];
        
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
        
        _oliver = [UILabel new];
        _oliver.textColor = WhiteColor;
        _oliver.font = PFFontL(16);
        _oliver.backgroundColor = OrangeColor;
        _oliver.textAlignment = NSTextAlignmentCenter;
        
        _highQuality = [UILabel new];
        _highQuality.textColor = WhiteColor;
        _highQuality.font = PFFontL(16);
        _highQuality.backgroundColor = RedColor;
        _highQuality.textAlignment = NSTextAlignmentCenter;
        
        _avatar = [UIImageView new];
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(12);
        _authorName.textColor = HexColor(#889199);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(12);
        _creatTime.textColor = HexColor(#889199);
        _creatTime.numberOfLines = 0;
        
        _contentLaebl = [YXLabel new];
        _contentLaebl.font = PFFontL(15);
        _contentLaebl.textColor = HexColor(#1A1A1A);
        
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
                                         _oliver,
                                         _highQuality,
                                         _avatar,
                                         _authorName,
                                         _idView,
                                         _creatTime,
                                         _attentionBtn,
                                         _contentLaebl,
                                         ]];
        _titleLabel.sd_layout
        .topSpaceToView(self.titleView, 10)
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .autoHeightRatio(0)
        ;
        _titleLabel.text = GetSaveString(self.postModel.postTitle);
        
        _oliver.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel, 0)
        .widthIs(40)
        .heightIs(0)
        ;
        _oliver.text = @"";
        _oliver.sd_cornerRadius = @3;
        
        _highQuality.sd_layout
        .leftSpaceToView(_oliver, 5)
        .topSpaceToView(_titleLabel, 0)
        .widthIs(25)
        .heightIs(0)
        ;
        _highQuality.text = @"";
        _highQuality.sd_cornerRadius = @3;
        
        _avatar.sd_layout
        .topSpaceToView(_titleLabel, 7)
        .leftEqualToView(_titleLabel)
        .widthIs(0)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        
        _idView.sd_layout
        .heightIs(20)
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_authorName, 10)
        .widthIs(0)
        ;
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(attentionBtnW)
        .heightIs(attentionBtnH)
        ;
        
        [_attentionBtn setSd_cornerRadius:@(attentionBtnH/2)];
        
        _creatTime.sd_layout
        .centerYEqualToView(_authorName)
        //        .leftSpaceToView(_idView, 5)
        .rightSpaceToView(_attentionBtn, 10)
        .heightIs(12)
        ;
        [_creatTime setSingleLineAutoResizeWithMaxWidth:150];
        
        _contentLaebl.sd_layout
        .topSpaceToView(_attentionBtn, 20)
        .leftEqualToView(_titleLabel)
        .rightEqualToView(_titleLabel)
        .heightIs(0)
        ;
        
        [self.titleView setupAutoHeightWithBottomView:_contentLaebl bottomMargin:bottomMargin];
    }
    
    _titleLabel.text = GetSaveString(self.postModel.postTitle);
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
    _creatTime.text = GetSaveString(self.postModel.createTime);
    _contentLaebl.text = GetSaveString(self.postModel.postContent);
    CGFloat h = [_contentLaebl getLabelWithLineSpace:3 width:ScreenW - 20];
    _contentLaebl.sd_layout
    .heightIs(h)
    ;
    [_contentLaebl updateLayout];
    
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
            [self moreSelect];
        }];
        
        [commentInput whenTap:^{
            @strongify(self);
            [self popCommentVCWithParentId:0];
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
        
    }
    self.collectBtn.selected = self.postModel.isCollection;
    self.praiseBtn.selected = self.postModel.hasPraised;
    self.bottomView.hidden = NO;
    if (self.user.userId == self.postModel.userId) {
        self.praiseBtn.enabled = NO;
    }else{
        self.praiseBtn.enabled = YES;
    }
}

//更多
-(void)moreSelect
{
    if (!self.postModel) {
        return;
    }
    @weakify(self)
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"复制链接" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = AppendingString(DomainString, self.postModel.postTitle);
        LRToast(@"链接已复制");
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//投票信息视图
-(void)setVoteDataView
{
    if (!_voteDataView) {
        _voteDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
        _voteDataView.backgroundColor = WhiteColor;
        UIView *backView = [UIView new];
        backView.backgroundColor = HexColor(#DEECFA);
        [_voteDataView addSubview:backView];
        backView.sd_layout
        .topEqualToView(_voteDataView)
        .bottomEqualToView(_voteDataView)
        .leftSpaceToView(_voteDataView, 10)
        .rightSpaceToView(_voteDataView, 10)
        ;
        
        UIImageView *icon = [UIImageView new];
        UILabel *noticeTop = [UILabel new];
        _participantNum = [UILabel new];
        _asOftheDateLabel = [UILabel new];
        _asOftheDateLabel.isAttributedContent = YES;
        
        [backView sd_addSubviews:@[
                                   icon,
                                   noticeTop,
                                   _asOftheDateLabel,
                                   _participantNum,
                                   
                                   ]];
        
        icon.sd_layout
        .leftSpaceToView(backView, 11)
        .topSpaceToView(backView, 11)
        .widthIs(24)
        .heightIs(19)
        ;
        icon.image = UIImageNamed(@"voteDetail_icon");
        
        noticeTop.sd_layout
        .centerYEqualToView(icon)
        .leftSpaceToView(icon, 20)
        .rightSpaceToView(backView, 20)
        .heightIs(16)
        ;
        noticeTop.font = PFFontR(16);
        noticeTop.textColor = HexColor(#161A24);
        NSString *noticeTopString = @"单选投票";
        if (self.postModel.choosableNum>1) {
            noticeTopString = [NSString stringWithFormat:@"多选投票(最多可选%ld项)",self.postModel.choosableNum];
        }
        noticeTop.text = noticeTopString;
        
        _asOftheDateLabel.sd_layout
        .rightSpaceToView(backView, 10)
        .leftSpaceToView(backView, 10)
        .bottomSpaceToView(backView, 13)
        .heightIs(14)
        ;
        _asOftheDateLabel.font = PFFontL(13);
        _asOftheDateLabel.textColor = HexColor(#889199);
        
        _participantNum.sd_layout
        .leftEqualToView(_asOftheDateLabel)
        .rightEqualToView(_asOftheDateLabel)
        .bottomSpaceToView(_asOftheDateLabel, 16)
        .heightIs(16)
        ;
        _participantNum.font = PFFontL(15);
        _participantNum.textColor = HexColor(#161A24);
        
    }
    _participantNum.text = [NSString stringWithFormat:@"共有%ld人参与投票",self.postModel.votePeople];
}

//设置分区1的分区头
-(void)setSecion1
{
    if (!_section1View) {
        _section1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 48)];
        _section1View.backgroundColor = WhiteColor;
        _allComment = [UILabel new];
        _ascendingLabel = [UILabel new];
        _descendingLabel = [UILabel new];
        UILabel *sepLine = [UILabel new];
        UIView *rightView = [UIView new];
        
        [_section1View sd_addSubviews:@[
                                        _allComment,
                                        rightView,
                                        
                                        ]];
        _allComment.sd_layout
        .centerYEqualToView(_section1View)
        .leftSpaceToView(_section1View, 10)
        .heightIs(18)
        ;
        [_allComment setSingleLineAutoResizeWithMaxWidth:200];
        _allComment.font = PFFontR(14);
        
        rightView.sd_layout
        .rightSpaceToView(_section1View, 10)
        .centerYEqualToView(_section1View)
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
        .widthIs(22)
        .heightIs(18)
        ;
        _ascendingLabel.font = PFFontL(11);
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
        .widthIs(22)
        .heightIs(18)
        ;
        _descendingLabel.font = PFFontL(11);
        _descendingLabel.textColor = HexColor(#ABB2C3);
        _descendingLabel.text = @"倒序";
        
        [rightView setupAutoWidthWithRightView:_descendingLabel rightMargin:0];
        
        
        @weakify(self);
        [rightView whenTap:^{
            @strongify(self);
            [self sortAction];
        }];
    }
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

//点击评论回复弹框
-(void)clickCommentPopAlertWith:(PostReplyModel *)replyModel
{
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

//提交投票操作
-(void)voteAction:(UIButton *)sender
{
    if (self.selectChooseArr.count>0) {
        //发出投票请求
        [self requestPost_doVote];
    }else{
        LRToast(@"您还未选择投票选项哦");
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.postModel.voteSelects.count;
    }
    if (section == 2) {
        return self.commentsArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        VoteDetailChooseTableViewCell *cell0 = (VoteDetailChooseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VoteDetailChooseTableViewCellID];
        cell0.tag = indexPath.row;
        VoteChooseInputModel *model = self.postModel.voteSelects[indexPath.row];
        cell0.model = model;
        cell = cell0;
    }else if (indexPath.section == 2){
        ThePostCommentReplyTableViewCell *cell2 = (ThePostCommentReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentReplyTableViewCellID];
        PostReplyModel *replyModel = self.commentsArr[indexPath.row];
        cell2.tag = indexPath.row;
        cell2.model = replyModel;
        cell2.avatarBlock = ^(NSInteger row) {
            GGLog(@"查看用户");
        };
        cell2.praiseBlock = ^(NSInteger row) {
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
    if (section == 0) {
        return 115;
    }else if (section == 1){
        return 0.01;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 115)];
        
        footView.backgroundColor = WhiteColor;
        if (self.postModel.haveVoted||self.postModel.isoVerdue||self.postModel.postAuthor) {
            UILabel *noticeLabel = [UILabel new];
            [footView addSubview:noticeLabel];
            noticeLabel.sd_layout
            .centerYEqualToView(footView)
            .centerXEqualToView(footView)
            .heightIs(18)
            ;
            noticeLabel.font = PFFontL(16);
            [noticeLabel setSingleLineAutoResizeWithMaxWidth:200];
            noticeLabel.text = @"投票完成，谢谢参与";
            if (self.postModel.isoVerdue) {
                noticeLabel.font = PFFontM(18);
                noticeLabel.text = @"投票已结束";
            }
            if (self.postModel.postAuthor){
                noticeLabel.font = PFFontM(18);
                noticeLabel.text = @"作者不能参与投票哟";
            }
        }else{
            UIButton *submitBtn = [UIButton new];
            [footView addSubview:submitBtn];
            submitBtn.sd_layout
            .centerYEqualToView(footView)
            .leftSpaceToView(footView, 10)
            .rightSpaceToView(footView, 10)
            .heightIs(46)
            ;
            submitBtn.sd_cornerRadius = @23;
//            submitBtn.backgroundColor = HexColor(#1282EE);
            [submitBtn setNormalTitle:@"提交"];
            [submitBtn setNormalTitleColor:WhiteColor];
            [submitBtn setBtnFont:PFFontL(16)];
            [submitBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
            submitBtn.enabled = self.selectChooseArr.count?YES:NO;
            if (self.selectChooseArr.count) {
                submitBtn.backgroundColor = HexColor(#1282EE);
            }else{
                submitBtn.backgroundColor = HexColor(#cccccc);
            }
        }
    }
    
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 110;
    }else
    if (section == 2) {
        return 48;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0) {
        [self setVoteDataView];
        headView = self.voteDataView;
    }else
    if (section == 2) {
        [self setSecion1];
        headView = self.section1View;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //没有投票才能响应点击事件
        if (!self.postModel.haveVoted&&!self.postModel.isoVerdue) {
            
            VoteChooseInputModel *model = self.postModel.voteSelects[indexPath.row];
            
            [self processTableViewWithSelectModel:model];
        }
    }else if (indexPath.section == 2) {
        PostReplyModel *replyModel = self.commentsArr[indexPath.row];
        [self clickCommentPopAlertWith:replyModel];
    }
}

//单选和多选时的处理
-(void)processTableViewWithSelectModel:(VoteChooseInputModel *)model
{
    //单选,选择不同项时做切换处理，同一选项点击2次时做反选处理
    if (self.postModel.choosableNum<=1) {
        //未选择任何选项时
        if (self.selectChooseArr.count<=0) {
            model.isSelected = YES;
            [self.selectChooseArr addObject:model];
        }else{  //已选1项，直接先移除
            [self.selectChooseArr removeAllObjects];
            if (model.isSelected) {
                model.isSelected = NO;
            }else{
                //先要把之前选中的取消选中，再把当前这个选中
                for (VoteChooseInputModel *model2 in self.postModel.voteSelects) {
                    if (model2.isSelected) {
                        model2.isSelected = NO;
                        break;
                    }else{
                        continue;
                    }
                }
                model.isSelected = YES;
                [self.selectChooseArr addObject:model];
            }
        }
        
    }else{
        //多选,只要未达到最大可选数，可一直累加，达到后只提示，同一选项点击2次时也做反选处理
        if (model.isSelected) { //先判断是否是已选
            model.isSelected = NO;
            [self.selectChooseArr removeObject:model];
        }else{
            //如果不是已选,先判断是否小于最大可选数
            if (self.selectChooseArr.count<self.postModel.choosableNum) {
                model.isSelected = YES;
                [self.selectChooseArr addObject:model];
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"已达到最大可选数了" message:[NSString stringWithFormat:@"该投票最多可选择%ld项",self.postModel.choosableNum] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertVC addAction:confirm];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    }
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --请求
//获取帖子详情
-(void)requestPost_browsePost
{
    [HttpRequest getWithURLString:Post_browsePost parameters:@{@"postId":@(self.postModel.postId)} success:^(id responseObject) {
        self.postModel = [SeniorPostDataModel mj_objectWithKeyValues:responseObject[@"data"]];
        //保存浏览历史
        [PostHistoryModel saveHistory:self.postModel];
        for (VoteChooseInputModel *model in self.postModel.voteSelects) {
            model.totalPolls = self.postModel.totalPolls;
            //如果是作者本人或者已经投过票的状态，需要标记选项不能交互
            if (self.postModel.postAuthor||self.postModel.haveVoted) {
                model.isSelected = NO;
                model.hiddenSelectIcon = YES;
            }
        }
        [self setBaseUI];
        [self setNaviTitle];
        [self setTitle];
        [self setBottomView];
        [self setUpCutdown];
        [self.tableView reloadData];
    } failure:nil];
}

//关注/取消关注
-(void)requestIsAttention
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.postModel.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        NSInteger status = [res[@"data"][@"status"] integerValue];
        if (status == 1) {
            //            user.followCount ++;
            LRToast(@"关注成功");
        }else{
            //            user.followCount --;
            LRToast(@"已取消关注");
        }
        self.postModel.isAttention = status;
        
        [self setTitle];
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
        }
        [self.tableView reloadData];
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
        self.postModel.isCollection = status;
        [self setBottomView];
        
    } failure:nil RefreshAction:^{
        [self requestPost_browsePost];
    }];
}

//投票
-(void)requestPost_doVote
{
    NSMutableString *chooseId = @"".mutableCopy;
    for (int i = 0; i < self.selectChooseArr.count; i ++) {
        VoteChooseInputModel *model = self.selectChooseArr[i];
        [chooseId appendString:[NSString stringWithFormat:@"%ld,",model.chooseId]];
        if (i == self.selectChooseArr.count-1) {
            //移除尾部逗号
            [chooseId replaceCharactersInRange:NSMakeRange(chooseId.length - 1, 1) withString:@""];
        }
    }
    
    [HttpRequest getWithURLString:Post_doVote parameters:@{@"chooseId":chooseId} success:^(id responseObject) {
        for (VoteChooseInputModel *chooseModel in self.selectChooseArr) {
            //总票数自增，单项票数自增
            chooseModel.havePolls ++;
            self.postModel.totalPolls ++;
        }
        //参与投票的人数加1
        self.postModel.votePeople ++;
        [self.selectChooseArr removeAllObjects];
        //标记为已投票
        self.postModel.haveVoted = YES;
        //标记选项不可交互
        for (VoteChooseInputModel *model in self.postModel.voteSelects) {
            model.totalPolls = self.postModel.totalPolls;
            model.isSelected = NO;
            model.hiddenSelectIcon = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//帖子评论列表
-(void)requestListPostComments:(NSInteger)page
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"postId"] = @(self.postModel.postId);
    parameters[@"currPage"] = @(page);
    parameters[@"sort"] = @(self.sort);
    
    [HttpRequest getWithURLString:ListPostComments parameters:parameters success:^(id responseObject) {
        HiddenHudOnly;
        NSArray *commentArr = [PostReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        self.commentsArr = [self.tableView pullWithPage:page data:commentArr dataSource:self.commentsArr];
        for (int i = 0; i < self.commentsArr.count; i ++) {
            PostReplyModel *model = self.commentsArr[i];
            if (model.userId == self.user.userId) {
                model.isAuthor = YES;
            }
        }
        self.currPage = page;
        [self setUpPageBtn];
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
        [self requestListPostComments:1];
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
}

@end
