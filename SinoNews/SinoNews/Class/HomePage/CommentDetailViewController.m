//
//  CommentDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "CommentCell.h"

@interface CommentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
}
@property (nonatomic,strong) UITextField *commentInput;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,assign) NSInteger currPage;   //页码(起始为1)
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation CommentDetailViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论详情";
    
//    [self addNavigationView];
    [self addTableView];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noComment" title:@"暂无评论"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
    UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts" hightimage:nil andTitle:@""];
    self.navigationItem.rightBarButtonItems = @[more,fonts];
    
}

//更多
-(void)moreSelect
{
    LRToast(@"更多");
}

//更多
-(void)fontsSelect
{
    LRToast(@"字体");
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
        [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            UITextField *field = x.first;
            GGLog(@"-----%@",field.text);
            [field resignFirstResponder];
            if ([NSString isEmpty:field.text]) {
                LRToast(@"评论不能为空哦");
            }else{
                [self requestCommentWithComment:field.text];
                field.text = @"";
            }
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          self.commentInput,
                                          ]];
        
        self.commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 35)
        .rightSpaceToView(self.bottomView, 35)
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
//        self.commentInput.backgroundColor = RGBA(219, 219, 219, 1);
        [self.commentInput setSd_cornerRadius:@17];
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:@"写评论..."];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontR(14),
                              NSForegroundColorAttributeName : RGBA(148, 152, 153, 1),
                              };
        [placeholder addAttributes:dic range:NSMakeRange(0, placeholder.length)];
        self.commentInput.attributedPlaceholder = placeholder;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 33)];
        UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 21)];
        [leftView addSubview:leftImg];
        leftImg.center = leftView.center;
        leftImg.image = UIImageNamed(@"news_comment");
        self.commentInput.leftViewMode = UITextFieldViewModeAlways;
        self.commentInput.leftView = leftView;
        
        [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
            @strongify(self);
            [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.bottomView, nil];
        }];
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
    //    .bottomSpaceToView(self.bottomView, 0)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    _tableView.backgroundColor = ClearColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 38, 0, 10);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        [self refreshComments];
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
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
    
    [_tableView.mj_header beginRefreshing];
}

-(void)refreshComments
{
    self.currPage = 1;
    [self requestComments];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.commentsArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0){
        CommentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CommentCellID];
        cell2.tag = indexPath.row;
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        cell2.model = model;
        @weakify(self)
        //点赞
        cell2.praiseBlock = ^(NSInteger row) {
            @strongify(self)
            if (model.isPraise) {
                LRToast(@"已经点过赞啦");
            }else{
                NSInteger type = 0;
                if (self.pushType == 1) {       //公司
                    type = 5;
                }else if (self.pushType == 2){  //回答
                    type = 8;
                }else{  //新闻
                    type = 1;
                }
                [self requestPraiseWithPraiseType:type praiseId:[model.commentId integerValue] commentNum:row];
            }
        };
        //头像
        cell2.avatarBlock = ^(NSInteger row) {
            [UserModel toUserInforVcOrMine:[model.userId integerValue]];
        };
        
        //回复TA
//        cell2.replayBlock = ^(NSInteger row) {
////            GGLog(@"点击了回复TA");
//            @strongify(self)
//            self.parentId = [model.commentId integerValue];
//            [self.commentInput becomeFirstResponder];
//        };
        //点击回复
        cell2.clickReplay = ^(NSInteger row,NSInteger index) {
            GGLog(@"点击了第%ld条回复",index);
        };
        //查看全部评论
        cell2.checkAllReplay = ^(NSInteger row) {
            GGLog(@"点击了查看全部回复");
        };
        
        cell = (CommentCell *)cell2;
    }
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
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.commentInput resignFirstResponder];
    
}

#pragma mark ----- 请求发送
//获取评论列表
-(void)requestComments
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *requestUrl;
    
    if (self.pushType == 1) {       //公司
        parameters[@"companyId"] = @([self.model.companyId integerValue]);
        requestUrl = CompanyShowReply;
    }else if (self.pushType == 2){  //回答
        parameters[@"answerId"] = @(self.answerId);
        requestUrl = ShowAnswerReply;
    }else{  //新闻
        parameters[@"newsId"] = @([self.model.newsId integerValue]);
        requestUrl = ShowReply;
    }
    
    parameters[@"commentId"] = @([self.model.commentId integerValue]);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest getWithURLString:requestUrl parameters:parameters success:^(id responseObject) {
        NSArray *arr;
        if (self.pushType == 2) {
            arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }else{
            arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        }
        
        self.commentsArr = [self.tableView pullWithPage:self.currPage data:arr dataSource:self.commentsArr];
        
//        if (self.currPage == 1) {
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
        [self setBottomView];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}

//回复评论
-(void)requestCommentWithComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *requestUrl;
    
    if (self.pushType == 1) {       //公司
        parameters[@"companyId"] = @([self.model.companyId integerValue]);
        requestUrl = CompanyComments;
    }else if (self.pushType == 2){  //回答
        parameters[@"answerId"] = @(self.answerId);
        requestUrl = AnswerComment;
    }else{  //新闻
        parameters[@"newsId"] = @([self.model.newsId integerValue]);
        requestUrl = Comments;
    }
    
    parameters[@"comment"] = comment;
    parameters[@"parentId"] = @([self.model.commentId integerValue]);
    
    [HttpRequest postWithTokenURLString:requestUrl parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        LRToast(@"评论已发送");
        [self refreshComments];
    } failure:nil RefreshAction:^{
        
    }];
}

//点赞文章/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"data"][@"success"] integerValue] == 1) {
            CompanyCommentModel *model = self.commentsArr[row];
            model.isPraise = YES;
            LRToast(@"点赞成功");
            model.likeNum = [res[@"data"][@"num"] integerValue];
            [self.tableView reloadData];
        }else{
            LRToast(@"已经点赞过了");
        }
        
    } failure:nil RefreshAction:^{
        
    }];
}


@end
