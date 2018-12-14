//
//  UserInfoViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NewsDetailViewController.h"
#import "PayNewsViewController.h"
#import "UserAttentionOrFansVC.h"
#import "PraisePopView.h"

#import "UserInfoCommentCell.h"
#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"
#import "HomePageFourthCell.h"
#import "UserInfoModel.h"

#import "PostDraftTableViewCell.h"
#import "ReadPostListTableViewCell.h"


@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MLMSegmentHeadDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NSMutableArray *articlesArr;   //文章数组
@property (nonatomic,strong) NSMutableArray *postsArr;  //帖子数组
@property (nonatomic,strong) NSMutableArray *replysArr; //回复数组
//用户信息
@property (nonatomic ,strong) UIImageView *userImg;
@property (nonatomic ,strong) UIImageView *isApproved;//是否认证
@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic ,strong) UILabel *integral;
@property (nonatomic ,strong) UILabel *level;   //等级
@property (nonatomic ,strong) UIButton *attentionBtn;
@property (nonatomic ,strong) UILabel *publish;     //文章
@property (nonatomic ,strong) UILabel *attention;   //关注
@property (nonatomic ,strong) UILabel *fans;        //粉丝
@property (nonatomic ,strong) UILabel *praise;      //获赞

@property (nonatomic ,strong) UserInfoModel *user;
@property (nonatomic ,assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic ,assign) NSInteger currPage0;   //页码0
@property (nonatomic ,assign) NSInteger currPage1;   //页码1
//新增帖子、回复
@property (nonatomic ,assign) NSInteger currPage2;   //页码2
@property (nonatomic ,assign) NSInteger currPage3;   //页码3

@property (nonatomic, strong) CAGradientLayer *gradient;
@end

@implementation UserInfoViewController
-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(NSMutableArray *)articlesArr
{
    if (!_articlesArr) {
        _articlesArr = [NSMutableArray new];
    }
    return _articlesArr;
}

-(NSMutableArray *)postsArr
{
    if (!_postsArr) {
        _postsArr = [NSMutableArray new];
    }
    return _postsArr;
}

-(NSMutableArray *)replysArr
{
    if (!_replysArr) {
        _replysArr = [NSMutableArray new];
    }
    return _replysArr;
}

-(UIView *)getSectionView
{
    if (!self.sectionView) {
        self.sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 34)];
        [self.sectionView addBakcgroundColorTheme];
        
        self.segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34) titles:@[@"文章",@"评论",@"帖子",@"回复"] headStyle:1 layoutStyle:1];
        //    _segHead.fontScale = .85;
        self.segHead.lineScale = 0.3;
        self.segHead.fontSize = 15;
        self.segHead.lineHeight = 2;
        self.segHead.lineColor = HexColor(#1282EE);
//        self.segHead.selectColor = HexColor(#323232);
        _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
            [(MLMSegmentHead *)item setSelectColor:value];
            if (UserGetBool(@"NightMode")) {
                [(MLMSegmentHead *)item setBottomLineColor:CutLineColorNight];
            }else{
                [(MLMSegmentHead *)item setBottomLineColor:CutLineColor];
            }
        });
        self.segHead.deSelectColor = HexColor(#989898);
        self.segHead.maxTitles = 4;
        self.segHead.bottomLineHeight = 1;
//        self.segHead.bottomLineColor = RGBA(227, 227, 227, 1);
        self.segHead.singleW_Add = 60;
        self.segHead.delegate = self;
        @weakify(self)
        [MLMSegmentManager associateHead:self.segHead withScroll:nil completion:^{
            @strongify(self)
            [self.sectionView addSubview:self.segHead];
        }];
        [_segHead.titlesScroll addBakcgroundColorTheme];
        
    }
    return self.sectionView;
}

- (CAGradientLayer *)gradient
{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, ScreenW, 50);
        //渐变色
        _gradient.colors = @[
                             (__bridge id)[UIColor colorWithRed:11/255.0 green:146/255.0 blue:208/255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:1/255.0 green:84/255.0 blue:177/255.0 alpha:1].CGColor,
                             ];
        //分界
        _gradient.startPoint = CGPointMake(0, 0);
        _gradient.endPoint = CGPointMake(1, 1);
        _gradient.locations = @[@(0.0),@(1.0f)];
    }
    return _gradient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self addTableView];
    [self addHeadView];
    
    [self requestGetUserInfomation];
    [self requestIsAttention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UserInfoCommentCell class] forCellReuseIdentifier:UserInfoCommentCellID];
    [self.tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
    [_tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    //新增
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
    
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        if (self.selectedIndex == 0) {
            self.currPage0 = 1;
            [self requestUserPushNews];
        }else if(self.selectedIndex ==1) {
            self.currPage1 = 1;
            [self requestUserComments];
        }else if (self.selectedIndex ==2){
            self.currPage2 = 1;
            [self requestListPostForUser];
        }else if (self.selectedIndex ==3){
            self.currPage3 = 1;
            [self requestListPostCommentsForUser];
        }
        
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (self.selectedIndex == 0) {
            if (!self.articlesArr.count) {
                self.currPage0 = 1;
            }else{
                self.currPage0 ++;
            }
            [self requestUserPushNews];
        }else if(self.selectedIndex == 1){
            if (!self.commentsArr.count) {
                self.currPage1 = 1;
            }else{
                self.currPage1 ++;
            }
            [self requestUserComments];
        }else if (self.selectedIndex ==2){
            if (!self.postsArr.count) {
                self.currPage2 = 1;
            }else{
                self.currPage2 ++;
            }
            [self requestListPostForUser];
        }else if (self.selectedIndex ==3){
            if (!self.replysArr.count) {
                self.currPage3 = 1;
            }else{
                self.currPage3 ++;
            }
            [self requestListPostCommentsForUser];
        }
        
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

-(void)addHeadView
{
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
//    headView.backgroundColor = RGBA(196, 222, 247, 1);
    headView.userInteractionEnabled = YES;
//    headView.image = UIImageNamed(@"mine_topBackImg");
    headView.lee_theme.LeeConfigImage(@"mineBackImg");
    self.tableView.tableHeaderView = headView;
    
    self.gradient.frame = CGRectMake(0, CGRectGetHeight(headView.frame) - 50, ScreenW, 50);
    [headView.layer addSublayer:self.gradient];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = ClearColor;
    
    _userImg = [UIImageView new];
    _userImg.contentMode = 2;
    _userImg.layer.masksToBounds = YES;
    //    _userImg.backgroundColor = Arc4randomColor;
    
    _isApproved = [UIImageView new];
    //    _isApproved.backgroundColor = Arc4randomColor;
    
    _userName = [UILabel new];
    _userName.font = PFFontL(18);
//    _userName.textColor = RGBA(72, 72, 72, 1);
//    [_userName addTitleColorTheme];
    _userName.textColor = WhiteColor;
    
    _idView = [UIView new];
    _idView.backgroundColor = ClearColor;
    
    _integral = [UILabel new];
    _integral.font = PFFontL(14);
//    _integral.textColor = RGBA(50, 50, 50, 1);
//    [_integral addTitleColorTheme];
    _integral.textColor = WhiteColor;
    
    _level = [UILabel new];
    _level.font = PFFontM(12);
    _level.textAlignment = NSTextAlignmentCenter;
    _level.textColor = WhiteColor;
    _level.backgroundColor = HexColor(#1282EE);
    _level.hidden = YES;
    
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
//                               registBtn,
                               
                               _userImg,
                               
                               _attentionBtn,
                               backView,
                               _isApproved,
//                               _userName,
//                               _integral,
                               
                               
                               _publish,
                               _attention,
                               _fans,
                               _praise
                               ]];
    @weakify(self)
    closeBtn.sd_layout
    .leftSpaceToView(headView, 0)
    .topSpaceToView(headView, 10)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    
    @weakify(closeBtn);
    closeBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(closeBtn)
        if (UserGetBool(@"NightMode")) {
            [closeBtn setNormalImage:UIImageNamed(@"return_left_night")];
        }else{
            [closeBtn setNormalImage:UIImageNamed(@"return_left")];
        }
    });
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
    
    _attentionBtn.sd_layout
    .rightSpaceToView(headView, 11)
    .centerYEqualToView(_userImg)
    .widthIs(70)
    .heightIs(30)
    ;
    [_attentionBtn setSd_cornerRadius:@15];
    _attentionBtn.titleLabel.font = PFFontR(14);
    [_attentionBtn setNormalTitleColor:WhiteColor];
    
    [_attentionBtn setNormalTitle:@" 关注"];
    [_attentionBtn setSelectedTitle:@"已关注"];
    
    [_attentionBtn setNormalBackgroundImage:[UIImage imageWithColor:HexColor(#3688F7)]];
    [_attentionBtn setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#3688F7)]];
   /* _attentionBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        
        if (UserGetBool(@"NightMode")) {
            [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#1C1F2C)]];
            [(UIButton *)item setSelectedTitleColor:HexColor(#4E4F53)];
        }else{
            [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#f2f6f7)]];
            [(UIButton *)item setSelectedTitleColor:HexColor(#aeb6b8)];
        }
    });
    */
    
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.hidden = YES;
    
    backView.sd_layout
    .leftSpaceToView(_userImg, 15)
    .rightSpaceToView(_attentionBtn, 10)
    .centerYEqualToView(_userImg)
    .heightIs(40)
    ;
    [backView sd_addSubviews:@[
                               _userName,
                               
                               _integral,
                               _level,
                               _idView,
                               ]];
    
    _userName.sd_layout
    //    .bottomSpaceToView(_userImg, -27)
//    .centerYEqualToView(self.userImg)
//    .leftSpaceToView(_userImg, 18 * ScaleW)
//    .heightIs(20)
    .topEqualToView(backView)
    .leftEqualToView(backView)
    .heightIs(20)
    ;
    [_userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    
    
    
    _integral.sd_layout
//    .topSpaceToView(_userName, 10)
//    .leftEqualToView(_userName)
    .leftEqualToView(backView)
    .bottomEqualToView(backView)
    .heightIs(14)
    ;
    [_integral setSingleLineAutoResizeWithMaxWidth:100];
    
    _level.sd_layout
    .leftSpaceToView(_integral, 10)
    .centerYEqualToView(_integral)
    .widthIs(40)
    .heightIs(18)
    ;
    [_level setSd_cornerRadius:@9];
//    _level.text = @"Lv.15";
    
    _idView.sd_layout
    .heightIs(20)
    .centerYEqualToView(_integral)
    .leftSpaceToView(_level, 10)
    ;
    
//    [backView setupAutoWidthWithRightView:_userName rightMargin:10];
    
    _publish.sd_layout
    .topSpaceToView(_userImg, 40)
    .leftEqualToView(headView)
    .bottomSpaceToView(headView, 0)
    .widthIs(ScreenW/4)
    ;
    [_publish updateLayout];
    [_publish whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:0];
    }];
    _publish.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.publish addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.publish addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    _attention.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_publish, 0)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_attention updateLayout];
    [_attention whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:1];
    }];
    _attention.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.attention addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.attention addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    _fans.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_attention, 0)
    //    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_fans updateLayout];
    [_fans whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:2];
    }];
    _fans.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.fans addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.fans addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    _praise.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_fans, 0)
    //    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_praise updateLayout];
    [_praise whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:3];
    }];
    
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
    _level.hidden = YES;
    _level.text = @"";
    _idView.hidden = YES;
    if (self.user) {
        [_userImg sd_setImageWithURL:UrlWithStr(self.user.avatar)];
        @weakify(self);
        [self.userImg whenTap:^{
            @strongify(self);
            [self clickUser:self.user.avatar];
        }];
        _userName.text = GetSaveString(self.user.username);
        _integral.text = [NSString stringWithFormat:@"%ld 积分",self.user.integral];
        pub = [NSString stringWithFormat:@"%lu",self.user.postCount];
        att = [NSString stringWithFormat:@"%lu",self.user.followCount];
        fan = [NSString stringWithFormat:@"%lu",self.user.fansCount];
        pra = [NSString stringWithFormat:@"%lu",self.user.postCount];
        _idView.hidden = NO;
        _level.hidden = self.user.level?NO:YES;
        _level.text = [NSString stringWithFormat:@"Lv.%lu",self.user.level];
        _level.hidden = YES;
        _level.sd_layout
        .widthIs(0)
        ;
    }
    [self setIdViewWithIDs];
    
    _publish.attributedText = [NSString leadString:pub tailString:@"发表" font:Font(12) color:WhiteColor lineBreak:YES];
    _attention.attributedText = [NSString leadString:att tailString:@"关注" font:Font(12) color:WhiteColor  lineBreak:YES];
    _fans.attributedText = [NSString leadString:fan tailString:@"粉丝" font:Font(12) color:WhiteColor  lineBreak:YES];
    _praise.attributedText = [NSString leadString:pra tailString:@"获赞" font:Font(12) color:WhiteColor  lineBreak:YES];
    
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.user.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.user.identifications.count; i ++) {
            NSDictionary *model = self.user.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            
            approveView.sd_layout
            //            .topEqualToView(lastView)
            .centerYEqualToView(_idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
//            [approveView setSd_cornerRadius:@(wid/2)];
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            approveView.contentMode = 1;
            
            //现在要加一个label
            UILabel *label = [UILabel new];
            label.font = PFFontR(12);
            [label addTitleColorTheme];
            [_idView addSubview:label];
            label.sd_layout
            //            .topEqualToView(_idView)
            .centerYEqualToView(_idView)
            .leftSpaceToView(approveView, 6)
            .heightIs(hei)
            ;
            [label setSingleLineAutoResizeWithMaxWidth:50];
//            label.text = GetSaveString(model[@"text"]);
            
            lastView = label;
            if (i == self.user.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:lastView rightMargin:0];
            }
        }
    }
}

//获取统一label
-(UILabel *)getLabel
{
    UILabel *label = [UILabel new];
    label.textColor = WhiteColor;
//    [label addTitleColorTheme];
    
    label.font = PFFontL(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.isAttributedContent = YES;
    return label;
}

-(void)tapViewWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            UserAttentionOrFansVC *uarfVC = [UserAttentionOrFansVC new];
            uarfVC.userId = self.userId;
            uarfVC.type = 0;
            [self.navigationController pushViewController:uarfVC animated:YES];
        }
            break;
        case 2:
        {
            UserAttentionOrFansVC *uarfVC = [UserAttentionOrFansVC new];
            uarfVC.userId = self.userId;
            uarfVC.type = 1;
            [self.navigationController pushViewController:uarfVC animated:YES];
        }
            break;
        case 3:
        {
            [PraisePopView showWithData:@{@"username":self.user.username,@"praisedCount":@(self.user.praisedCount)}];
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

//点击头像
-(void)clickUser:(NSString *)userUrl
{
    //创建图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = NO;
    browser.isNeedLandscape = NO;
    browser.imageArray = @[userUrl];
    [browser show];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedIndex == 0) {
        return self.articlesArr.count;
    }
    if (_selectedIndex == 1) {
        return self.commentsArr.count;
    }
    if (_selectedIndex == 2) {
        return self.postsArr.count;
    }
    if (_selectedIndex == 3) {
        return self.replysArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_selectedIndex == 1) {
        UserInfoCommentCell *cell0 = (UserInfoCommentCell *)[tableView dequeueReusableCellWithIdentifier:UserInfoCommentCellID];
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        cell0.model = model;
        
        @weakify(self)
        cell0.clickNewBlock = ^{
            @strongify(self)
            if (model.newsType == 0) {
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = [model.newsId integerValue];
                [self.navigationController pushViewController:ndVC animated:YES];
            }
            
        };
        
        cell = (UITableViewCell *)cell0;
    }else if (_selectedIndex == 0){
        
        id model = self.articlesArr[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = (HomePageModel *)model;
            switch (model1.itemType) {
                case 400:
                case 500:
                case 100:   //无图
                {
                    HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                    cell1.bottomShowType = 1;
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                    
                case 401:
                case 501:
                case 101:   //1图
                {
                    HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                    cell1.bottomShowType = 1;
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                case 403:
                case 503:
                case 103:   //3图
                {
                    HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                    cell1.bottomShowType = 1;
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                    
                default:
                    break;
            }
            
        }else if ([model isKindOfClass:[TopicModel class]]){
            HomePageFirstKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
            cell2.bottomShowType = 1;
            cell2.model = model;
            cell = (UITableViewCell *)cell2;
        }else if ([model isKindOfClass:[ADModel class]]){
            HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
            cell3.model = model;
            cell = (UITableViewCell *)cell3;
        }
    }else if (_selectedIndex == 2){
        ReadPostListTableViewCell *cell2 = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        SeniorPostDataModel *model = self.postsArr[indexPath.row];
        cell2.model = model;
        cell = cell2;
    }else if (_selectedIndex == 3){
        UserInfoCommentCell *cell0 = (UserInfoCommentCell *)[tableView dequeueReusableCellWithIdentifier:UserInfoCommentCellID];
        PostReplyModel *model = self.replysArr[indexPath.row];
        cell0.postReplyModel = model;
        @weakify(self);
        cell0.clickNewBlock = ^{
            @strongify(self);
            UIViewController *vc;
            if (model.postType == 2) { //投票
                TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
                tvpdVC.postModel.postId = model.postId;
                vc = tvpdVC;
            }else{
                ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
                tpdVC.postModel.postId = model.postId;
                vc = tpdVC;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell = (UITableViewCell *)cell0;
    }
    cell.selectedBackgroundView.backgroundColor = ClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 34;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.segHead.showIndex = self.selectedIndex;
    return [self getSectionView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0) {
        id model = self.articlesArr[indexPath.row];
        [UniversalMethod pushToAssignVCWithNewmodel:model];
    }else if (self.selectedIndex == 2) {
        SeniorPostDataModel *model = self.postsArr[indexPath.row];
        if (model.status == 0) {
            LRToast(@"正在审核中...");
        }else if (model.status == 2) {
            LRToast(@"帖子未通过审核");
        }else{
            UIViewController *vc;
            if (model.postType == 2) { //投票
                TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
                tvpdVC.postModel.postId = model.postId;
                vc = tvpdVC;
            }else{
                ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
                tpdVC.postModel.postId = model.postId;
                vc = tpdVC;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark ----- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
    [self.tableView reloadData];
    
    if (index == 0&&!self.articlesArr.count) {
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 1&&!self.commentsArr.count){
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 2&&!self.postsArr.count){
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 3&&!self.replysArr.count){
        [self.tableView.mj_header beginRefreshing];
    }
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
        [self.navigationController popViewControllerAnimated:YES];
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
        if (self.attentionBtn.selected) {
            [self.attentionBtn setNormalImage:nil];
            [self.attentionBtn setSelectedImage:nil];
        }else{
            [self.attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
        }
//        UserModel *user = [UserModel getLocalUserModel];
        if (status) {
//            user.followCount ++;
            LRToast(@"关注成功");
        }else{
//            user.followCount --;
            LRToast(@"已取消关注");
        }
        //覆盖之前保存的信息
//        [UserModel coverUserData:user];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//获取用户评论
-(void)requestUserComments
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.currPage1);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest getWithURLString:GetUserComments parameters:parameters success:^(id responseObject) {
        NSArray *arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.commentsArr = [self.tableView pullWithPage:self.currPage1 data:arr dataSource:self.commentsArr];
        
//        if (self.currPage0 == 1) {
//            [self.tableView.mj_header endRefreshing];
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
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

//获取用户发表文章
-(void)requestUserPushNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.currPage0);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest getWithURLString:GetUserNews parameters:parameters success:^(id responseObject) {
//        NSArray *arr = [HomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSMutableArray *arr = [UniversalMethod getProcessNewsData:responseObject[@"data"]];
        
        self.articlesArr = [self.tableView pullWithPage:self.currPage0 data:arr dataSource:self.articlesArr];
//        if (self.currPage1 == 1) {
//            [self.tableView.mj_header endRefreshing];
//            if (arr.count) {
//                self.articlesArr = [arr mutableCopy];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }else{
//            if (arr.count) {
//                [self.articlesArr addObjectsFromArray:arr];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

//获取用户帖子列表
-(void)requestListPostForUser
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.currPage2);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest getWithURLString:ListPostForUser parameters:parameters success:^(id responseObject) {
        NSMutableArray *arr = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.postsArr = [self.tableView pullWithPage:self.currPage0 data:arr dataSource:self.articlesArr];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

//获取用户帖子相关评论
-(void)requestListPostCommentsForUser
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.currPage3);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest getWithURLString:ListPostCommentsForUser parameters:parameters success:^(id responseObject) {
        NSArray *dataArr = [PostReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        self.replysArr = [self.tableView pullWithPage:self.currPage3 data:dataArr dataSource:self.replysArr];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}








@end
