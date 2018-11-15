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

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) UICopyLabel *contentLaebl;
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) UIButton *topAttBtn; //导航栏上的关注按钮

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;

@property (nonatomic,strong) UIView *naviTitle;
//分区0,投票信息相关
@property (nonatomic,strong) UIView *voteDataView;
//参与人数
@property (nonatomic,strong) UILabel *participantNum;
//分区1
@property (nonatomic,strong) UIView *section1View;
@property (nonatomic,strong) UILabel *allComment;
@property (nonatomic,strong) UILabel *ascendingLabel;
@property (nonatomic,strong) UILabel *descendingLabel;

//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;
//评论分页选择页数
@property (nonatomic,assign) NSInteger commentPageSelect;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self setNaviTitle];
    [self setTitle];
    [self setBottomView];
}

- (void)setUI
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#F3F5F4);
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
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
        
        _contentLaebl = [UICopyLabel new];
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
        _titleLabel.text = GetSaveString(self.postModel.postTitle);
        
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
        [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.postModel.avatar))];
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        _authorName.text = GetSaveString(self.postModel.author);
        
        _idView.sd_layout
        .heightIs(20)
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_authorName, 10)
        .widthIs(0)
        ;
        
        _creatTime.sd_layout
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_idView, 5)
        .heightIs(12)
        ;
        [_creatTime setSingleLineAutoResizeWithMaxWidth:150];
        _creatTime.text = GetSaveString(self.postModel.createTime);
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(attentionBtnW)
        .heightIs(attentionBtnH)
        ;
        
        [_attentionBtn setSd_cornerRadius:@(attentionBtnH/2)];
        
        _contentLaebl.sd_layout
        .topSpaceToView(_attentionBtn, 20)
        .leftEqualToView(_titleLabel)
        .rightEqualToView(_titleLabel)
        .autoHeightRatio(0)
        ;
        _contentLaebl.text = GetSaveString(self.postModel.postContent);
        
        [self.titleView setupAutoHeightWithBottomView:_contentLaebl bottomMargin:bottomMargin];
    }
    
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
        UILabel *noticeBottom = [UILabel new];
        
        [backView sd_addSubviews:@[
                                   icon,
                                   noticeTop,
                                   noticeBottom,
                                   _participantNum,
                                   
                                   ]];
        
        icon.sd_layout
        .leftSpaceToView(backView, 11)
        .topSpaceToView(backView, 11)
        .widthIs(24)
        .heightIs(19)
        ;
        icon.image = UIImageNamed(@"voteDetail_icon");
        icon.backgroundColor = Arc4randomColor;
        
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
        
        noticeBottom.sd_layout
        .rightSpaceToView(backView, 10)
        .leftSpaceToView(backView, 10)
        .bottomSpaceToView(backView, 13)
        .heightIs(14)
        ;
        noticeBottom.font = PFFontL(13);
        noticeBottom.textColor = HexColor(#889199);
        noticeBottom.text = @"距离结束还有：6天23小时59分";
        
        _participantNum.sd_layout
        .leftEqualToView(noticeBottom)
        .rightEqualToView(noticeBottom)
        .bottomSpaceToView(noticeBottom, 16)
        .heightIs(16)
        ;
        _participantNum.font = PFFontL(15);
        _participantNum.textColor = HexColor(#161A24);
        
    }
    _participantNum.text = [NSString stringWithFormat:@"共有%ld人参与投票",self.postModel.voteNum];
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
        _allComment.text = @"全部评论（216）";
        
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

//提交投票操作
-(void)voteAction:(UIButton *)sender
{
    if (self.selectChooseArr.count>0) {
        //发出投票请求
        LRToast(@"投票成功");
        [self.selectChooseArr removeAllObjects];
        self.postModel.haveVoted = YES;
        self.postModel.voteNum ++;
        for (VoteChooseInputModel *model in self.postModel.voteSelects) {
            model.isSelected = NO;
            model.hiddenSelectIcon = YES;
        }
        [self.tableView reloadData];
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
        return 2;
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
        if (self.postModel.haveVoted) {
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
            submitBtn.backgroundColor = HexColor(#1282EE);
            [submitBtn setNormalTitle:@"提交"];
            [submitBtn setNormalTitleColor:WhiteColor];
            [submitBtn setBtnFont:PFFontL(16)];
            [submitBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
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
        if (!self.postModel.haveVoted) {
            
            VoteChooseInputModel *model = self.postModel.voteSelects[indexPath.row];
            
            [self processTableViewWithSelectModel:model];
        }
    }else if (indexPath.section == 2) {
        [self clickCommentPopAlert];
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

@end
