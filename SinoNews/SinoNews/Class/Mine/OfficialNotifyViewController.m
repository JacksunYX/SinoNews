//
//  OfficialNotifyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "OfficialNotifyViewController.h"
#import "OfficialNotifyCell.h"

@interface OfficialNotifyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UITextField *inputView;

@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;

@end

@implementation OfficialNotifyViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *avatar = @[
                            @"login_logo",
                            @"user_icon",
                            @"user_icon",
                            @"user_icon",
                            @"user_icon",
                            ];
        NSArray *content = @[
                             @"你好，欢迎来到启世录，我 是启世录小助手！在使用启世录的过程中有任何问题，都可以在这里进行咨询，我会第一时间帮助您解决，祝您在启世录玩的开心愉快！",
                             @"你好",
                             @"测试一下没有时间",
                             @"测试一下没有时间",
                             @"测试一下没有时间",
                             ];
        NSArray *sendType = @[
                              @0,
                              @1,
                              @1,
                              @1,
                              @1,
                              ];
        NSArray *time = @[
                          @"今天 09:08",
                          @"今天 10:53",
                          @"",
                          @"",
                          @"",
                          ];
        for (int i = 0; i < avatar.count; i ++) {
            OfficialNotifyModel *model = [OfficialNotifyModel new];
            model.avatar = avatar[i];
            model.content = content[i];
            model.time = time[i];
            model.type = [sendType[i] integerValue];
//            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"启世录官方通知";
    self.view.backgroundColor = WhiteColor;
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//添加tableview
-(void)addTableView
{
    self.bottomView = [UIView new];
    [self.view addSubview:self.bottomView];
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(55)
    ;
    [self.bottomView updateLayout];
    @weakify(self)
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.bottomView, nil];
    }];
    
    UIButton *sendBtn = [UIButton new];
    sendBtn.titleLabel.font = PFFontL(15);
    sendBtn.backgroundColor = RGBA(29, 136, 245, 1);
    [sendBtn setNormalTitleColor:WhiteColor];
    [sendBtn setNormalTitle:@"发送"];
    
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self sendContent];
    }];
    
    self.inputView = [UITextField new];
    self.inputView.delegate = self;
    self.inputView.returnKeyType = UIReturnKeySend;
    self.inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 32)];
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    
    [self.bottomView sd_addSubviews:@[
                                      sendBtn,
                                      self.inputView,
                                      ]];
    sendBtn.sd_layout
    .rightSpaceToView(self.bottomView, 10)
    .centerYEqualToView(self.bottomView)
    .widthIs(43)
    .heightIs(32)
    ;
    [sendBtn setSd_cornerRadius:@6];
    
    self.inputView.sd_layout
    .leftSpaceToView(self.bottomView, 10)
    .rightSpaceToView(sendBtn, 13)
    .centerYEqualToView(self.bottomView)
    .heightIs(38)
    ;
    [self.inputView setSd_cornerRadius:@19];
    self.inputView.layer.borderColor = RGBA(232, 236, 239, 1).CGColor;
    self.inputView.layer.borderWidth = 1;
    
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        GGLog(@"完成编辑");
        UITextField *field = x.first;
        GGLog(@"-----%@",field.text);
        [self sendContent];
    }];
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.bottomView, 0)
    ;
    self.tableView.backgroundColor = RGBA(232, 236, 239, 1);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[OfficialNotifyCell class] forCellReuseIdentifier:OfficialNotifyCellID];
    
    
    self.tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self requestListMessagesWithLoadType:0];
        
    }];
    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        [self requestListMessagesWithLoadType:1];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
}

//发送文本
-(void)sendContent
{
    [self.inputView resignFirstResponder];
    if ([NSString isEmpty:self.inputView.text]) {
        LRToast(@"不能发送空文本哦");
    }else{
        //发送评论
        [self requestSendMessageToSystemWithContent:self.inputView.text];
        self.inputView.text = @"";
    }
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfficialNotifyCell *cell = (OfficialNotifyCell *)[tableView dequeueReusableCellWithIdentifier:OfficialNotifyCellID];
    cell.model = self.dataSource[indexPath.row];
    
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


#pragma mark ---- 请求发送
//向系统发送私信
-(void)requestSendMessageToSystemWithContent:(NSString *)content
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"messageContent"] = GetSaveString(content);
    [HttpRequest postWithURLString:SendMessageToSystem parameters:parameters isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id response) {
        if (response[@"success"]) {
            [self requestListMessagesWithLoadType:1];
        }
    } failure:nil RefreshAction:nil];
}

//获取私信列表(0loadTime之前的，1之后的)
-(void)requestListMessagesWithLoadType:(NSInteger)loadType
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"loadTime"] = [self getLoadTimeWithLoadType:loadType];
    parameters[@"loadType"] = @(loadType);
    [HttpRequest getWithURLString:ListMessages parameters:parameters success:^(id responseObject) {
        NSArray *data = [OfficialNotifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (loadType == 0) {
            self.dataSource = [[data arrayByAddingObjectsFromArray:self.dataSource] mutableCopy];
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.dataSource addObjectsFromArray:data];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//根据loadType来获取loadTime
-(NSString *)getLoadTimeWithLoadType:(NSInteger)loadType
{
    NSString *loadTime = @"";
    //前提是已经有数据了
    if (self.dataSource.count>0) {
        NSUInteger i = 0;
        if (loadType) {
            //取最后一个
            i = self.dataSource.count - 1;
        }
        OfficialNotifyModel *model = self.dataSource[i];
        loadTime = model.plainTime;
    }
    
    return loadTime;
}


@end
