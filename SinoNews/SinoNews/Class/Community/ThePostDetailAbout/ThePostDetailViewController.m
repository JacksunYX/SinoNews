//
//  ThePostDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostDetailViewController.h"



@interface ThePostDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
//帖子中包含的图片数组
@property (nonatomic,strong) NSMutableArray *imagesArr;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
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

@property (nonatomic,strong) UIView *section2View;
@property (nonatomic,strong) UILabel *allComment;
@property (nonatomic,strong) UILabel *ascendingLabel;
@property (nonatomic,strong) UILabel *descendingLabel;
//目录按钮
@property (nonatomic,strong) UIButton *directoryBtn;
//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;
//评论分页选择页数
@property (nonatomic,assign) NSInteger commentPageSelect;
@property (nonatomic,strong) LeftPopDirectoryViewController *menu;

@property (nonatomic,strong) UserModel *user;
//保存评论时选取的图片等数据
@property (nonatomic,strong) NSDictionary *lastReplyDic;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帖子详情";
    
    [self setUI];
    
    [self setNaviTitle];
    [self setTitle];
    [self setBottomView];
    [self reloadDataWithDataArrUpperCase];
    
    [self requestPost_browsePost];
}

- (void)setUI
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#F3F5F4);
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
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
    
    _commentPagingBtn = [UIButton new];
    [self.view addSubview:_commentPagingBtn];
    _commentPagingBtn.sd_layout
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(28)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN + 20)
    ;
    [_commentPagingBtn setNormalTitle:@"2/3"];
    _commentPagingBtn.sd_cornerRadius = @3;
    _commentPagingBtn.backgroundColor = HexColor(#45474A);
    [_commentPagingBtn addTarget:self action:@selector(popCommentPagingAction) forControlEvents:UIControlEventTouchUpInside];
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
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:ScaleWidth(20)];
        _titleLabel.numberOfLines = 0;
        
        _avatar = [UIImageView new];
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(12);
        _authorName.textColor = HexColor(#889199);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(12);
        _creatTime.textColor = HexColor(#889199);
        
        _contentLaebl = [YXLabel new];
        _contentLaebl.font = PFFontL(15);
        _contentLaebl.textColor = HexColor(#1A1A1A);
        _contentLaebl.numberOfLines = 0;
        
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
            
        }];
        
        [self.titleView sd_addSubviews:@[
                                         _titleLabel,
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
        
        CGFloat wid = 24;
        if (kStringIsEmpty(self.postModel.avatar)) {
            wid = 0;
        }
        _avatar.sd_layout
        .topSpaceToView(_titleLabel, 7)
        .leftEqualToView(_titleLabel)
        .widthIs(wid)
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
        [_attentionBtn removeFromSuperview];
        [self.topAttBtn removeFromSuperview];
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
                
            }
        }];
        
        [[_collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            
        }];
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self moreSelect];
        }];
        
        [commentInput whenTap:^{
            @strongify(self);
            [self popCommentVC];
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

//弹出选择分页的视图
-(void)popCommentPagingAction
{
    SelectCommentPageView *scPV = [SelectCommentPageView new];
    [scPV showAllNum:10 defaultSelect:self.commentPageSelect];
    @weakify(self);
    scPV.clickBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        self.commentPageSelect = selectIndex;
        
        [self pushToCommentPageWithIndex:selectIndex];
    };
}

//跳转评论分页界面
-(void)pushToCommentPageWithIndex:(NSInteger)index
{
    ThePostCommentPagesViewController *tpcpVC = [ThePostCommentPagesViewController new];
    tpcpVC.selectIndex = index;
    [self.navigationController pushViewController:tpcpVC animated:YES];
}

//更多
-(void)moreSelect
{
    if (!self.postModel) {
        return;
    }
    @weakify(self)
    [ShareAndFunctionView showWithCollect:self.postModel.isCollection returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
#ifdef JoinThirdShare
            [self shareToPlatform:sharePlateform];
#endif
        }else if (section==1) {
            if (row == 0) {
                
            }else if (row == 1) {
                
            }else if (row == 2) {
                
            }else if (row == 3) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"";
                LRToast(@"链接已复制");
            }
            
        }
    }];
    
}

//评论弹框
-(void)popCommentVC
{
    PopReplyViewController *prVC = [PopReplyViewController new];
    prVC.inputData = self.lastReplyDic.mutableCopy;
    @weakify(self);
    prVC.finishBlock = ^(NSDictionary * _Nonnull inputData) {
        GGLog(@"发布回调:%@",inputData);
        @strongify(self);
        self.lastReplyDic = inputData;
        //这里发布后把该数据清空就行了
    };
    prVC.cancelBlock = ^(NSDictionary * _Nonnull cancelData) {
        GGLog(@"取消回调:%@",cancelData);
        @strongify(self);
        self.lastReplyDic = cancelData;
    };
    [self.navigationController pushViewController:prVC animated:NO];
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
        
        [_section2View sd_addSubviews:@[
                                        _allComment,
                                        rightView,
                                        
                                        ]];
        _allComment.sd_layout
        .centerYEqualToView(_section2View)
        .leftSpaceToView(_section2View, 10)
        .heightIs(18)
        ;
        [_allComment setSingleLineAutoResizeWithMaxWidth:200];
        _allComment.font = PFFontR(14);
        _allComment.text = @"全部评论（216）";
        
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
}

//排序显示方法
-(void)sortAction
{
    if (self.ascendingLabel.tag == 10086) {
        self.ascendingLabel.tag = 10010;
        self.ascendingLabel.textColor = HexColor(#ABB2C3);
        self.descendingLabel.textColor = HexColor(#1282EE);
    }else{
        self.ascendingLabel.tag = 10086;
        self.ascendingLabel.textColor = HexColor(#1282EE);
        self.descendingLabel.textColor = HexColor(#ABB2C3);
    }
}

//点击评论弹框
-(void)clickCommentPopAlert
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reply = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
    if (section == 2) {
        return 2;
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
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            ThePostCommentTableViewCell *cell20 = (ThePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentTableViewCellID];
            cell20.model = @{};
            cell = cell20;
        }else{
            ThePostCommentReplyTableViewCell *cell21 = (ThePostCommentReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentReplyTableViewCellID];
            cell21.model = @{};
            cell = cell21;
        }
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
        return 110;
    }else if (section == 1){
        return 10;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        footView = [UIView new];
        [footView addBakcgroundColorTheme];
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
        notice.text = @"启世录好文章，需要你勤劳的小手指";
        
    }
    
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 48;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 2) {
        [self setSecion2];
        headView = self.section2View;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SeniorPostingAddElementModel *model = self.postModel.dataSource[indexPath.row];
        if (model.addType == 3) {
            //使用AV播放视频(iOS9.0以后适用,支持画中画)
            AVPlayerViewController *avVC = [[AVPlayerViewController alloc]init];
            //本地地址
            NSURL *url = [NSURL fileURLWithPath:model.videoUrl];
            //网络地址
//            url = UrlWithStr(model.videoUrl);
            avVC.player = [[AVPlayer alloc]initWithURL:url];
            [self presentViewController:avVC animated:YES completion:^{
                //跳转后自动播放
                [avVC.player play];
            }];
        }else if(model.addType == 2){
            //图片
            [self showImageBrowser:model.imageUrl];
        }
    }else if (indexPath.section == 2) {
        [self clickCommentPopAlert];
    }
}

#pragma mark --请求
-(void)requestPost_browsePost
{
    [HttpRequest getWithURLString:Post_browsePost parameters:@{@"postId":@(self.postModel.postId)} success:^(id responseObject) {
        self.postModel = [SeniorPostDataModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setTitle];
        [self.tableView reloadData];
    } failure:nil];
}

@end
