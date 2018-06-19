//
//  RankDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//


#import "RankDetailViewController.h"
#import "CompanyDetailModel.h"
#import "CommentCell.h"


@interface RankDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger sectionNum;   //总的分区数量
}
@property (nonatomic,strong) BaseTableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CompanyDetailModel *companyModel;

@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论列表
@property (nonatomic,assign) NSInteger currPage;   //页码
@end

@implementation RankDetailViewController

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
        [_dataSource addObject:[self addSection0Data]];
        
        [_dataSource addObject:[self addSection1Data]];
        
        [_dataSource addObject:[self addSection2Data]];
        
        [_dataSource addObject:[self addSection3Data]];
    }
    return _dataSource;
}

-(NSArray *)addSection0Data
{
    NSDictionary *dic0_0 = @{
                             @"title"         :   GetSaveString(self.companyModel.companyName),
                             @"icon"          :   GetSaveString(self.companyModel.logo),
                             @"webserveUrl"   :   GetSaveString(self.companyModel.website),
                             @"collectType"   :   @"1",
                             };
    NSDictionary *dic0_1 = @{
                             @"icon"          :   @"game_discount",
                             @"title"         :   GetSaveString(self.companyModel.promos),
                             };
    NSDictionary *dic0_2 = @{
                             @"icon"          :   @"game_setup",
                             @"title"         :   [@"成立：" stringByAppendingString:GetSaveString(self.companyModel.foundTime)],
                             };
    NSArray *section0 = @[dic0_0,dic0_1,dic0_2];
    return section0;
}

-(NSArray *)addSection1Data
{
    NSDictionary *dic1_0 = @{
                             @"icon"          :   @"game_type",
                             @"title"         :   GetSaveString(self.companyModel.game),
                             };
    NSDictionary *dic1_1 = @{
                             @"icon"          :   @"game_operation",
                             @"title"         :   GetSaveString(self.companyModel.area),
                             };
    
    
    NSDictionary *dic1_2 = @{
                             @"icon"          :   @"game_reserve",
                             @"title"         :   @"",
                             };
    NSDictionary *dic1_3 = @{
                             @"icon"          :   @"game_introduce",
                             @"title"         :   AppendingString(@"简介：", GetSaveString(self.companyModel.information)),
                             };
    
    NSArray *section1 = @[dic1_0,dic1_1,dic1_2,dic1_3];
    return section1;
}

-(NSArray *)addSection2Data
{
    NSMutableArray *title = [NSMutableArray new];
    NSMutableArray *score = [NSMutableArray new];
    for (NSDictionary *dic in self.companyModel.rankings) {
        [title addObject:dic[@"rankingName"]];
        [score addObject:dic[@"score"]];
    }
//    NSArray *title = @[
//                       @"存款体验",
//                       @"提款体验",
//                       @"游戏体验",
//                       @"网站体验",
//                       @"APP体验",
//                       @"历史信誉",
//                       @"资金运营",
//                       @"客户服务",
//                       @"拍照场地",
//                       @"担保金额",
//                       ];
//    NSArray *score = @[
//                       @9,
//                       @10,
//                       @8,
//                       @10,
//                       @9,
//                       @10,
//                       @9,
//                       @10,
//                       @10,
//                       @10,
//                       ];
    NSMutableArray *section2 = [NSMutableArray new];
    for (int i = 0; i < title.count; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"title"] = title[i];
        dic[@"score"] = score[i];
        [section2 addObject:dic];
    }
    
    return section2;
}

-(NSArray *)addSection3Data
{
    NSDictionary *dic = @{
                          @"img"    :   GetSaveString(self.companyModel.siteThumbnail),
                          
                          };
    
    NSArray *section3 = @[dic];
    return section3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"启示录";
    self.view.backgroundColor = WhiteColor;
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    WEAK(weakSelf, self);
    self.tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_footer.refreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }
        weakSelf.currPage = 1;
        [weakSelf requestCompanyRanking];
        [weakSelf requestCompanyCommentList];
    }];
    
    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_header.refreshing) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        weakSelf.currPage ++;
        [weakSelf requestCompanyCommentList];
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.companyModel) {
        sectionNum = self.dataSource.count + 1;
        return sectionNum;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return self.commentsArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *fatherView = cell.contentView;
        if (fatherView.subviews.count) {
            for (UIView *subview in fatherView.subviews) {
                [subview removeFromSuperview];
            }
        }
        
        NSArray *data = self.dataSource[indexPath.section];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self setSection0Row0WithData:data[indexPath.row] onView:cell];
            }else{
                [self setSection0OtherRowWithData:data[indexPath.row] onView:cell custom:NO];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 2) {
                [self setSection0OtherRowWithData:data[indexPath.row] onView:cell custom:YES];
            }else{
                [self setSection0OtherRowWithData:data[indexPath.row] onView:cell custom:NO];
            }
        }else if (indexPath.section == 2){
            [self setSection2OtherRowWithDatas:data onView:cell];
        }else if (indexPath.section == 3){
            [self setSection3RowWithData:data[indexPath.row] onView:cell];
        }
        
    }else if (indexPath.section == 4){
        CommentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CommentCellID];
        cell2.model = self.commentsArr[indexPath.row];
        cell = (CommentCell *)cell2;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
        }
    }
    if (indexPath.section == 1) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    
    if (indexPath.section == 2) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    
    if (indexPath.section == 3) {
        return ((ScreenW - 20)*130/355 + 15 + 45);
    }
    
    if (indexPath.section == 4) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2||section == 4) {
        return 40;
    }
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = WhiteColor;
    if (section == 2) {
        UILabel *title = [UILabel new];
        title.font = FontScale(16);
        title.isAttributedContent = YES;
        UIImageView *icon = [UIImageView new];
        icon.backgroundColor = WhiteColor;
        [headView sd_addSubviews:@[
                                   title,
                                   icon,
                                   ]];
        //布局
        title.sd_layout
        .centerYEqualToView(headView)
        .centerXEqualToView(headView)
        .autoHeightRatio(0)
        ;
        [title setSingleLineAutoResizeWithMaxWidth:100];
        NSString *titleStr = GetSaveString(self.companyModel.syntheticalRanking.score);
        NSString *str = [titleStr stringByAppendingString:@" 总分"];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc]initWithString:str];
        NSDictionary *dic = @{
                              NSFontAttributeName:FontScale(18),
                              NSForegroundColorAttributeName:RGBA(230, 102, 102, 1),
                              };
        [attText addAttributes:dic range:NSMakeRange(0, titleStr.length)];
        title.attributedText = attText;
        
        icon.sd_layout
        .centerYEqualToView(title)
        .leftSpaceToView(title, 5)
        .widthIs(20)
        .heightEqualToWidth()
        ;
        icon.contentMode = 4;
        icon.image = UIImageNamed(@"game_rule");
//        [icon setSd_cornerRadius:@10];
        [icon cornerWithRadius:10];
        icon.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
        icon.layer.borderWidth = 1;
    }else if (section == 4){
        UILabel *title = [UILabel new];
        title.font = PFFontR(15);
        [headView addSubview:title];
        //布局
        title.sd_layout
        .centerYEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        title.text = @"评论";
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        if (self.companyModel.otherwebsite.count) {
//            NSString *webStr = [self.companyModel.otherwebsite firstObject];
//            [self openUrlWithString:webStr];
//        }
//    }
}

//设置0区0行内容
-(void)setSection0Row0WithData:(NSDictionary *)model onView:(UITableViewCell *)cell
{
    UIView *fatherView = cell.contentView;
    UIImageView *star = [UIImageView new];
    UIImageView *icon = [UIImageView new];
    
    UILabel *title = [UILabel new];
    title.font = FontScale(16);
    
    UIButton *collectBtn = [UIButton new];
    collectBtn.titleLabel.font = FontScale(15);
    [collectBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    UIButton *websiteBtn = [UIButton new];
    websiteBtn.titleLabel.font = FontScale(15);
    [websiteBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    [fatherView sd_addSubviews:@[
                                 star,
                                 icon,
                                 websiteBtn,
                                 collectBtn,
                                 title,
                                 ]];
    //布局
    star.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(54)
    .heightIs(61)
    ;
    star.image = UIImageNamed(@"game_sixStar");
    
    icon.sd_layout
    .centerYEqualToView(star)
    .centerXEqualToView(star)
    .widthIs(50)
    .heightEqualToWidth()
    ;
//    [icon setSd_cornerRadius:@25];
    [icon cornerWithRadius:25];
    [icon sd_setImageWithURL:UrlWithStr(GetSaveString(self.companyModel.logo))];
//    icon.image = UIImageNamed(GetSaveString(model[@"icon"]));
    
    websiteBtn.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(50 * ScaleW)
    .heightIs(23)
    ;
    [websiteBtn setTitle:@"官网" forState:UIControlStateNormal];
    [websiteBtn setSd_cornerRadius:@5];
    websiteBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    websiteBtn.layer.borderWidth = 1;
    
    collectBtn.sd_layout
    .rightSpaceToView(websiteBtn, 10)
    .centerYEqualToView(fatherView)
    .widthIs(32 * ScaleW)
    .heightIs(23)
    ;
    UIImage *img;
    if ([model[@"collectType"] integerValue]) {
        img = UIImageNamed(@"game_collected");
    }else{
        img = UIImageNamed(@"game_unCollect");
    }
    [collectBtn setImage:img forState:UIControlStateNormal];
    [collectBtn setSd_cornerRadius:@5];
    collectBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    collectBtn.layer.borderWidth = 1;
    
    [websiteBtn addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
    
    title.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(star, 7)
    .rightSpaceToView(collectBtn, 7)
//    .autoHeightRatio(0)
    .heightIs(16)
    ;
//    [title setMaxNumberOfLinesToShow:1];
//    [title setSingleLineAutoResizeWithMaxWidth:100];
    //    title.text = GetSaveString(model[@"title"]);
    title.text = GetSaveString(self.companyModel.companyName);
}

//0区其他行
-(void)setSection0OtherRowWithData:(NSDictionary *)model onView:(UITableViewCell *)cell custom:(BOOL)custom
{
    UIView *fatherView = cell.contentView;
    
    UIImageView *leftIcon = [UIImageView new];
    UILabel *descrip = [UILabel new];
    descrip.font = FontScale(15);
    
    [fatherView sd_addSubviews:@[
                                 leftIcon,
                                 descrip,
                                 
                                 ]];
    leftIcon.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 10)
    .widthIs(20)
    .heightEqualToWidth()
    ;
    leftIcon.contentMode = 1;
    leftIcon.image = UIImageNamed(GetSaveString(model[@"icon"]));
    
    descrip.sd_layout
    .leftSpaceToView(leftIcon, 10)
    .rightSpaceToView(fatherView, 10)
    .topEqualToView(leftIcon)
    .autoHeightRatio(0)
    ;
    
    if (custom) {
        NSMutableString *otherWeb = [@"备用：" mutableCopy];
        NSMutableArray *ranges = [NSMutableArray new];
        NSMutableArray *actionStrs = [NSMutableArray array]; // 将要添加点击事件的字符串集合
        if (self.companyModel.otherwebsite.count) {
            for (int i = 0; i < self.companyModel.otherwebsite.count; i ++) {
                NSString *str = [NSString stringWithFormat:@"网址%d",i + 1];
                [actionStrs addObject:str];
                [otherWeb appendString:str];
                
                NSRange range = [otherWeb rangeOfString:str];
                [ranges addObject:[NSValue valueWithRange:range]];
                
                [otherWeb appendString:@"  "];
            }
            // 转换成富文本字符串
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:otherWeb];
            
            [attrStr addAttributes:@{NSFontAttributeName : FontScale(15)} range:NSMakeRange(0, otherWeb.length)];
            
            // 最好设置一下行高，不设的话默认是0
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            
            style.lineSpacing = 0;
            
            [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, otherWeb.length)];
            
            // 给指定文字添加颜色
            
            for (NSValue *rangeVal in ranges) {
                
                [attrStr addAttributes:@{NSForegroundColorAttributeName : RGBA(216, 132, 132, 1)} range:rangeVal.rangeValue];
                
            }
            
            descrip.attributedText = attrStr;
            @weakify(self);
            [descrip yb_addAttributeTapActionWithStrings:actionStrs tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//                GGLog(@"点击了%@\n index:%ld",string,index);
                @strongify(self);
                [self openUrlWithString:GetSaveString(self.companyModel.otherwebsite[index])];
            }];
        }else{
//            [otherWeb appendString:@"无"];
            descrip.text = @"备用：无";
            
        }
    }else{
        descrip.text = GetSaveString(model[@"title"]);
    }
    
    
//    if (cell.sd_indexPath.row == 1) {
//        descrip.text = [NSString stringWithFormat:@"优惠：%@",self.companyModel.promos];
//    }else if (cell.sd_indexPath.row == 2){
//        descrip.text = [NSString stringWithFormat:@"成立：%@",self.companyModel.foundTime];
//    }
    [cell setupAutoHeightWithBottomView:descrip bottomMargin:10];
}

//2区
-(void)setSection2OtherRowWithDatas:(NSArray *)modelArr onView:(UITableViewCell *)cell
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat lrMargin = 10;  //左右间隔
    CGFloat tbMargin = 10;  //上下间隔
    CGFloat centerX = 30;   //中间间隔
    for (int i = 0; i < modelArr.count; i ++) {
        if (i%2 == 0) {  //需要换行
            x = lrMargin;
            y += tbMargin;
        }else{          //不需要换行
            x += centerX;
        }
        
        NSDictionary *dic = modelArr[i];
        UILabel *title = [UILabel new];
        title.font = Font(15);
        title.text = GetSaveString(dic[@"title"]);
        [title sizeToFit];
        title.frame = CGRectMake(x, y, title.width, title.height);

        CGFloat progressW = (ScreenW/2 - lrMargin * 2 - centerX/2 - title.width);
        YSProgressView *progress = [[YSProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame) + lrMargin, CGRectGetMidY(title.frame) - 9, progressW, 18)];
        progress.trackTintColor = RGBA(139, 198, 255, 1);
        progress.progressTintColor = RGBA(234, 234, 234, 1);
        progress.progressValue = ([dic[@"score"] floatValue]/100.0)*100.0;
        
        //分数
        UILabel *score = [[UILabel alloc]initWithFrame:progress.frame];
        score.textAlignment = NSTextAlignmentCenter;
        score.font = Font(14);
        score.text = [NSString stringWithFormat:@"%@ 分",dic[@"score"]];
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:progress];
        [cell.contentView addSubview:score];
        x = CGRectGetMaxX(progress.frame);

        if ((i + 1)%2 == 0) {
            y += CGRectGetHeight(title.frame);
        }
        if (i == modelArr.count - 1) {
            [cell setupAutoHeightWithBottomView:title bottomMargin:10];
        }
    }
}

//3区
-(void)setSection3RowWithData:(NSDictionary *)model onView:(UITableViewCell *)cell
{
    UIImageView *img = [UIImageView new];
    [cell.contentView addSubview:img];
    img.sd_layout
    .leftSpaceToView(cell.contentView, 10)
    .rightSpaceToView(cell.contentView, 10)
    .topEqualToView(cell.contentView)
    .heightIs((ScreenW - 20)*130/355)
    ;
    [img setSd_cornerRadius:@7];
//    img.image = UIImageNamed(GetSaveString(model[@"img"]));
    [img sd_setImageWithURL:UrlWithStr(model[@"img"])];
    
    UIButton *sendCommentBtn = [UIButton new];
    sendCommentBtn.titleLabel.font = Font(15);
    [sendCommentBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    UIButton *collectBtn = [UIButton new];
    collectBtn.titleLabel.font = Font(15);
    [collectBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    UIButton *webserveBtn = [UIButton new];
    webserveBtn.titleLabel.font = Font(15);
    [webserveBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    [cell.contentView sd_addSubviews:@[
                                       sendCommentBtn,
                                       collectBtn,
                                       webserveBtn,
                                       ]];
    sendCommentBtn.sd_layout
    .topSpaceToView(img, 15)
    .centerXEqualToView(cell.contentView)
    .widthIs(110 * ScaleW)
    .heightIs(30)
    ;
    [sendCommentBtn setSd_cornerRadius:@3];
    sendCommentBtn.layer.borderWidth = 1;
    sendCommentBtn.layer.borderColor = RGBA(255, 196, 31, 1).CGColor;
    [sendCommentBtn setTitle:@"发评论" forState:UIControlStateNormal];
    
    collectBtn.sd_layout
    .rightSpaceToView(sendCommentBtn, 12)
    .centerYEqualToView(sendCommentBtn)
    .widthIs(110 * ScaleW)
    .heightIs(30)
    ;
    [collectBtn setSd_cornerRadius:@3];
    collectBtn.layer.borderWidth = 1;
    collectBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [collectBtn setImage:UIImageNamed(@"game_collected") forState:UIControlStateNormal];
    
    webserveBtn.sd_layout
    .leftSpaceToView(sendCommentBtn, 12)
    .centerYEqualToView(sendCommentBtn)
    .widthIs(110 * ScaleW)
    .heightIs(30)
    ;
    [webserveBtn setSd_cornerRadius:@3];
    webserveBtn.layer.borderWidth = 1;
    webserveBtn.layer.borderColor = RGBA(236, 105, 65, 1).CGColor;
    [webserveBtn setTitle:@"官网" forState:UIControlStateNormal];
    
    [sendCommentBtn addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
    [webserveBtn addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
}

//跳转到网页
-(void)openUrlWithString:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

//按钮事件集合
-(void)touchActions:(UIButton *)btn
{
    NSString *btnTitle = btn.titleLabel.text;
    if ([btnTitle isEqualToString:@"官网"]) {
        [self openUrlWithString:GetSaveString(self.companyModel.website)];
    }else if ([btnTitle isEqualToString:@"发评论"]){
        LRToast(@"发送了一个评论~");
    }else{
        LRToast(@"点击了收藏~");
    }
}

#pragma mark ----- 发送请求
//企业详情
-(void)requestCompanyRanking
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"companyId"] = GetSaveString(self.companyId);
    
    [HttpRequest getWithURLString:CompanyDetail parameters:parameters success:^(id responseObject) {
        self.companyModel = [CompanyDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

//评论列表
-(void)requestCompanyCommentList
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"companyId"] = GetSaveString(self.companyId);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest getWithURLString:CompanyShowComment parameters:parameters success:^(id responseObject) {
        NSArray *arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        if (arr.count) {
            if (self.currPage == 1) {
                self.commentsArr = [arr mutableCopy];
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.commentsArr addObjectsFromArray:arr];
            }
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
