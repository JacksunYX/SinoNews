//
//  ThePostCommentPagesViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostCommentPagesViewController.h"

@interface ThePostCommentPagesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
//评论数组
@property (nonatomic,strong) NSMutableArray *commentsArr;

@property (nonatomic,assign) NSInteger sort;
//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;
//保存评论时选取的图片等数据
@property (nonatomic,strong) NSDictionary *lastReplyDic;
//评论排序按钮
@property (nonatomic,strong) UIButton *commentSortBtn;
//下方回复视图
@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UserModel *user;
@end

@implementation ThePostCommentPagesViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"评论（%ld）",self.postModel.commentCount];
    self.navigationItem.title = @"评论";
    [self setNavigationView];
    [self setUI];
    [self setBottomView];
    [self requestListPostComments:self.currPage];
}

-(void)setNavigationView
{
    _commentSortBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [_commentSortBtn setNormalImage:UIImageNamed(@"commentSort_up")];
    [_commentSortBtn setSelectedImage:UIImageNamed(@"commentSort_down")];
    [_commentSortBtn addTarget:self action:@selector(changeCommentSort) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_commentSortBtn];
}

- (void)setUI
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.separatorColor = HexColor(#E3E3E3);
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    
    [_tableView registerClass:[ThePostCommentTableViewCell class] forCellReuseIdentifier:ThePostCommentTableViewCellID];
    [_tableView registerClass:[ThePostCommentReplyTableViewCell class] forCellReuseIdentifier:ThePostCommentReplyTableViewCellID];
    
    //评论分页按钮
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
    _commentPagingBtn.hidden = NO;
    NSInteger totalPage = self.postModel.commentCount/10;
    if (self.postModel.commentCount%10>0) {
        //说明有余数
        totalPage ++;
    }
    [_commentPagingBtn setNormalTitle:[NSString stringWithFormat:@"%ld/%ld",self.currPage,totalPage]];
    
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
     
        [self.bottomView addSubview:commentInput];
        commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 20)
        .rightSpaceToView(self.bottomView, 20)
        .centerYEqualToView(self.bottomView)
        .heightIs(34)
        ;
        [commentInput updateLayout];
        [commentInput setSd_cornerRadius:@17];
        commentInput.text = @"有何高见，展开讲讲";
        if (self.postModel.hasExpired) {
            commentInput.text = @"帖子失效，不可评论";
        }
        @weakify(self);
        [commentInput whenTap:^{
            @strongify(self);
            if (!self.postModel.hasExpired) {
                [self popCommentVCWithParentId:0];
            }
        }];
    }
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

//弹出选择分页的视图
-(void)popCommentPagingAction
{
    NSInteger totalPage = self.postModel.commentCount/10;
    if (self.postModel.commentCount%10>0) {
        //说明有余数
        totalPage ++;
    }
    SelectCommentPageView *scPV = [SelectCommentPageView new];
    [scPV showAllNum:totalPage defaultSelect:self.currPage-1];
    @weakify(self);
    scPV.clickBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        self.currPage = selectIndex+1;
        //重新请求评论分页做数据处理
        [self requestListPostComments:self.currPage];
    };
}

//点击评论弹框
-(void)clickCommentPopAlertWith:(PostReplyModel *)replyModel
{
    if (self.postModel.hasExpired) {
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

//评论排序
-(void)changeCommentSort
{
    _commentSortBtn.selected = !_commentSortBtn.selected;
    if (_commentSortBtn.selected) {
        _sort = 1;
    }else{
        _sort = 0;
    }
    //如果有数据，直接本地排序，无数据再请求后台
    if (self.commentsArr>0) {
        self.commentsArr = (NSMutableArray *)[[self.commentsArr reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
    }else{
       [self requestListPostComments:self.currPage];
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThePostCommentReplyTableViewCell *cell = (ThePostCommentReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentReplyTableViewCellID];
    PostReplyModel *replyModel = self.commentsArr[indexPath.row];
    cell.tag = indexPath.row;
    cell.model = replyModel;
    @weakify(self);
    cell.avatarBlock = ^(NSInteger row) {
        [UserModel toUserInforVcOrMine:replyModel.userId];
    };
    cell.praiseBlock = ^(NSInteger row) {
        @strongify(self);
        if(self.user.userId == replyModel.userId){
            LRToast(@"不可以点赞自己哟");
        }else if (replyModel.praise) {
            LRToast(@"已经点过赞啦");
        }else{
            [self requestPraiseWithPraiseType:10 praiseId:replyModel.commentId commentNum:indexPath.row];
        }
    };
    
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
    PostReplyModel *replyModel = self.commentsArr[indexPath.row];
    [self clickCommentPopAlertWith:replyModel];
}

#pragma mark --请求
//帖子评论列表
-(void)requestListPostComments:(NSInteger)page
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"postId"] = @(self.postModel.postId);
    parameters[@"currPage"] = @(page);
    parameters[@"sort"] = @(self.sort);
    
    [HttpRequest getWithURLString:ListPostComments parameters:parameters success:^(id responseObject) {
        self.commentsArr = [PostReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        [self setUpPageBtn];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
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
        LRToast(@"已发送");
        self.lastReplyDic = nil;
        self.postModel.commentCount ++;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self requestListPostComments:self.currPage];
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
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
    } failure:nil RefreshAction:nil];
}

@end
