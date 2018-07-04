//
//  UserInfoViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCommentCell.h"
#import "HomePageFirstKindCell.h"
#import "UserInfoModel.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MLMSegmentHeadDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NSMutableArray *articlesArr;   //文章数组
//用户信息
@property (nonatomic ,strong) UIImageView *userImg;
@property (nonatomic ,strong) UIImageView *isApproved;//是否认证
@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UILabel *integral;
@property (nonatomic ,strong) UIButton *attentionBtn;
@property (nonatomic ,strong) UILabel *publish;     //文章
@property (nonatomic ,strong) UILabel *attention;   //关注
@property (nonatomic ,strong) UILabel *fans;        //粉丝
@property (nonatomic ,strong) UILabel *praise;      //获赞

@property (nonatomic ,strong) UserInfoModel *user;
@property (nonatomic ,assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@end

@implementation UserInfoViewController
-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(NSMutableArray *)_articlesArr
{
    if (!_articlesArr) {
        _articlesArr = [NSMutableArray new];
    }
    return _articlesArr;
}

-(UIView *)getSectionView
{
    if (!self.sectionView) {
        self.sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 34)];
        self.sectionView.backgroundColor = WhiteColor;
        
        self.segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34) titles:@[@"评论",@"文章"] headStyle:1 layoutStyle:1];
        //    _segHead.fontScale = .85;
        self.segHead.lineScale = 0.3;
        self.segHead.fontSize = 15;
        self.segHead.lineHeight = 2;
        self.segHead.lineColor = HexColor(#1282EE);
        self.segHead.selectColor = HexColor(#323232);
        self.segHead.deSelectColor = HexColor(#989898);
        self.segHead.maxTitles = 2;
        self.segHead.bottomLineHeight = 1;
        self.segHead.bottomLineColor = RGBA(227, 227, 227, 1);
        self.segHead.singleW_Add = 90;
        self.segHead.delegate = self;
        @weakify(self)
        [MLMSegmentManager associateHead:self.segHead withScroll:nil completion:^{
            @strongify(self)
            [self.sectionView addSubview:self.segHead];
        }];
    }
    return self.sectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self addTableView];
    [self addHeadView];
    
    [self requestGetUserInfomation];
    [self requestIsAttention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//添加上方的tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UserInfoCommentCell class] forCellReuseIdentifier:UserInfoCommentCellID];
    [self.tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
}

-(void)addHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
    headView.backgroundColor = RGBA(196, 222, 247, 1);
    self.tableView.tableHeaderView = headView;
    
    _userImg = [UIImageView new];
//    _userImg.backgroundColor = Arc4randomColor;
    
    _isApproved = [UIImageView new];
//    _isApproved.backgroundColor = Arc4randomColor;
    
    _userName = [UILabel new];
    _userName.font = PFFontL(18);
    _userName.textColor = RGBA(72, 72, 72, 1);
    
    _integral = [UILabel new];
    _integral.font = PFFontL(14);
    _integral.textColor = RGBA(50, 50, 50, 1);
    
    _attentionBtn = [UIButton new];
    
    _publish = [self getLabel];
    _attention = [self getLabel];
    _fans = [self getLabel];
    _praise = [self getLabel];
    _publish.tag = 0;
    _attention.tag = 1;
    _fans.tag = 2;
    _praise.tag = 3;
    
    //其他控件
    UIButton *closeBtn = [UIButton new];
    UIButton *registBtn = [UIButton new];
    
    [headView sd_addSubviews:@[
                               closeBtn,
                               registBtn,
                               
                               _userImg,
                               _isApproved,
                               _userName,
                               _integral,
                               _attentionBtn,
                               
                               _publish,
                               _attention,
                               _fans,
                               _praise
                               ]];
    @weakify(self)
    closeBtn.sd_layout
    .leftSpaceToView(headView, 15)
    .topSpaceToView(headView, 10)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [closeBtn setImage:UIImageNamed(@"return_left") forState:UIControlStateNormal];
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    registBtn.sd_layout
    .rightSpaceToView(headView, 15)
    .centerYEqualToView(closeBtn)
    .widthIs(32)
    .heightIs(16)
    ;
    [registBtn setImage:UIImageNamed(@"news_more") forState:UIControlStateNormal];
    [[registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        GGLog(@"更多");
    }];
    
    _userImg.sd_layout
    .topSpaceToView(headView, 54)
    .leftSpaceToView(headView, 21)
    .widthIs(63)
    .heightEqualToWidth()
    ;
    [_userImg setSd_cornerRadius:@32];
    _userImg.image = UIImageNamed(@"userIcon");
//    [_userImg creatTapWithSelector:@selector(userTouch)];
    
    _isApproved.sd_layout
    .bottomEqualToView(_userImg)
    .leftSpaceToView(_userImg, -32)
    .widthIs(38)
    .heightIs(15)
    ;
//    _isApproved.image = UIImageNamed(@"userInfo_isApproved");
    
    _userName.sd_layout
    //    .bottomSpaceToView(_userImg, -27)
    .centerYEqualToView(self.userImg)
    .leftSpaceToView(_userImg, 18 * ScaleW)
    .heightIs(20)
    ;
    [_userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    
    _integral.sd_layout
    .topSpaceToView(_userName, 10)
    .leftEqualToView(_userName)
    .heightIs(20)
    ;
    [_integral setSingleLineAutoResizeWithMaxWidth:100];
    
    _attentionBtn.sd_layout
    .rightSpaceToView(headView, 11)
    .centerYEqualToView(_userImg)
    .widthIs(70)
    .heightIs(30)
    ;
    [_attentionBtn setSd_cornerRadius:@15];
    _attentionBtn.titleLabel.font = PFFontR(14);
    [_attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_attentionBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:RGBA(218, 218, 218, 1)forState:UIControlStateSelected];
    [_attentionBtn setBackgroundImage:[UIImage imageWithColor:RGBA(54, 136, 247, 1)] forState:UIControlStateNormal];
    [_attentionBtn setBackgroundImage:[UIImage imageWithColor:RGBA(245, 245, 245, 1)] forState:UIControlStateSelected];
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.hidden = YES;
    
    _publish.sd_layout
    .topSpaceToView(_userImg, 40)
    .leftEqualToView(headView)
    .bottomSpaceToView(headView, 10)
    .widthIs(ScreenW/4)
    ;
    [_publish updateLayout];
    [_publish creatTapWithSelector:@selector(tapView:)];
    [_publish addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
    
    _attention.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_publish, 0)
    //    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_attention updateLayout];
    [_attention creatTapWithSelector:@selector(tapView:)];
    [_attention addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
    
    _fans.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_attention, 0)
    //    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_fans updateLayout];
    [_fans creatTapWithSelector:@selector(tapView:)];
    [_fans addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
    
    _praise.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_fans, 0)
    //    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_praise updateLayout];
    [_praise creatTapWithSelector:@selector(tapView:)];
    
    [self setHeadView];
    
}

//设置头部内容
-(void)setHeadView
{
    NSString *pub = @"0";
    NSString *att = @"0";
    NSString *fan = @"0";
    NSString *pra = @"0";
    _userName.text = @"0";
    _integral.text = @"0积分";
    if (self.user) {
        [_userImg sd_setImageWithURL:UrlWithStr(self.user.avatar)];
        _userName.text = GetSaveString(self.user.username);
        _integral.text = [NSString stringWithFormat:@"%ld 积分",self.user.integral];
        pub = [NSString stringWithFormat:@"%lu",self.user.postCount];
        att = [NSString stringWithFormat:@"%lu",self.user.followCount];
        fan = [NSString stringWithFormat:@"%lu",self.user.fansCount];
        pra = [NSString stringWithFormat:@"%lu",self.user.postCount];
    }
    
    _publish.attributedText = [NSString leadString:pub tailString:@"文章" font:Font(12) color:RGBA(134, 144, 153, 1) lineBreak:YES];
    _attention.attributedText = [NSString leadString:att tailString:@"关注" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _fans.attributedText = [NSString leadString:fan tailString:@"粉丝" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _praise.attributedText = [NSString leadString:pra tailString:@"获赞" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    
}

//获取统一label
-(UILabel *)getLabel
{
    UILabel *label = [UILabel new];
    label.textColor = RGBA(50, 50, 50, 1);
    label.font = PFFontL(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.isAttributedContent = YES;
    return label;
}

-(void)tapView:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

//关注按钮点击事件
-(void)attentionAction:(UIButton *)sender
{
    [self requestAttentionUser];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedIndex == 0) {
//        return self.commentsArr.count;
        return 5;
    }
    if (_selectedIndex == 1) {
//        return self.articlesArr.count;
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_selectedIndex == 0) {
        UserInfoCommentCell *cell0 = (UserInfoCommentCell *)[tableView dequeueReusableCellWithIdentifier:UserInfoCommentCellID];
//        cell0.model = self.commentsArr[indexPath.row];
        cell = (UITableViewCell *)cell0;
    }else if (_selectedIndex == 1){
        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
//        cell1.model = self.articlesArr[indexPath.row];
        cell = (UITableViewCell *)cell1;
    }
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
    return 34;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.segHead.showIndex = self.selectedIndex;
    return [self getSectionView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ----- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [self.tableView reloadData];
//    NSInteger count = self.commentsArr.count;
//    if (index) {
//        index = self.articlesArr.count;
//    }
//    NSRange range = NSMakeRange(0, count);
//
//    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:0];
}

#pragma mark ---- 请求发送
//获取用户信息
-(void)requestGetUserInfomation
{
    @weakify(self)
    [HttpRequest getWithURLString:GetUserInformation parameters:@{@"userId":@(self.userId)} success:^(id responseObject) {
        @strongify(self)
        self.user = [UserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setHeadView];
    } failure:nil];
}

//是否关注此用户
-(void)requestIsAttention
{
    @weakify(self)
    [HttpRequest postWithURLString:IsAttention parameters:@{@"userId":@(self.userId)} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        @strongify(self)
        NSInteger status = [response[@"data"] integerValue];
        self.attentionBtn.hidden = NO;
        self.attentionBtn.selected = status;
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//关注/取消关注
-(void)requestAttentionUser
{
    @weakify(self)
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        NSInteger status = [response[@"data"][@"status"] integerValue];
        self.attentionBtn.selected = status;
        UserModel *user = [UserModel getLocalUserModel];
        if (status) {
            user.followCount ++;
            LRToast(@"关注成功～");
        }else{
            user.followCount --;
            LRToast(@"已取消关注");
        }
        //覆盖之前保存的信息
        [UserModel coverUserData:user];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
