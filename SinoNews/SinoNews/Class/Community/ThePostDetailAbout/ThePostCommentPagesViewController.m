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
//评论分页按钮
@property (nonatomic,strong) UIButton *commentPagingBtn;
//保存评论时选取的图片等数据
@property (nonatomic,strong) NSDictionary *lastReplyDic;
//评论排序按钮
@property (nonatomic,strong) UIButton *commentSortBtn;
//下方回复视图
@property (nonatomic,strong) UIView *bottomView;
@end

@implementation ThePostCommentPagesViewController
-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AppendingString(@"评论", @"(22)");
    [self setNavigationView];
    [self setUI];
    [self setBottomView];
}

-(void)setNavigationView
{
    _commentSortBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [_commentSortBtn setNormalImage:UIImageNamed(@"commentSort_down")];
    [_commentSortBtn setSelectedImage:UIImageNamed(@"commentSort_up")];
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
    [_commentPagingBtn setNormalTitle:@"2/3"];
    _commentPagingBtn.sd_cornerRadius = @3;
    _commentPagingBtn.backgroundColor = HexColor(#45474A);
    [_commentPagingBtn addTarget:self action:@selector(popCommentPagingAction) forControlEvents:UIControlEventTouchUpInside];
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
        @weakify(self);
        [commentInput whenTap:^{
            @strongify(self);
            [self popCommentVC];
        }];
    }
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
    [scPV showAllNum:10 defaultSelect:self.selectIndex];
    @weakify(self);
    scPV.clickBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        self.selectIndex = selectIndex;
        //重新请求评论分页做数据处理
        
    };
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

//评论排序
-(void)changeCommentSort
{
    _commentSortBtn.selected = !_commentSortBtn.selected;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        ThePostCommentTableViewCell *cell20 = (ThePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentTableViewCellID];
        cell20.model = @{};
        cell = cell20;
    }else{
        ThePostCommentReplyTableViewCell *cell21 = (ThePostCommentReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostCommentReplyTableViewCellID];
        cell21.model = @{};
        cell = cell21;
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
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickCommentPopAlert];
}

@end
