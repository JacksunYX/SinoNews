//
//  AddressViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AddressViewController.h"
#import "EditAddressViewController.h"
#import "AddressTableViewCell.h"


@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//添加新地址
@property (nonatomic, strong) UIButton *addAddress;

@property (nonatomic, strong) NSMutableArray *deleteArr;  //用来保存删除的addressid的数组
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理收货地址";
    [self showTopLine];
    [self configUI];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noAddress" title:@"暂无收货地址"];
//    [self showOrHiddenTheAddBtn:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configUI {
    
    self.addAddress = [UIButton new];
    [self.addAddress setNormalTitleColor:HexColor(#888888)];
    self.addAddress.titleLabel.font = PFFontL(17);
    self.addAddress.backgroundColor = WhiteColor;
    
    [self.view addSubview:self.addAddress];
    self.addAddress.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 16)
    .heightIs(49)
    ;
    [self.addAddress updateLayout];
    [self.addAddress setNormalImage:UIImageNamed(@"address_add")];
    [self.addAddress setNormalTitle:@"添加新地址"];
    self.addAddress.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    @weakify(self)
    [[self.addAddress rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        EditAddressViewController *eaVC = [EditAddressViewController new];
        eaVC.refreshBlock = ^{
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:eaVC animated:YES];
    }];
    //添加阴影
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.addAddress.bounds];
    self.addAddress.layer.masksToBounds = NO;
    self.addAddress.layer.shadowColor = RGBA(63, 72, 81, 0.29).CGColor;
    self.addAddress.layer.shadowOffset = CGSizeMake(3, 4);
    self.addAddress.layer.shadowOpacity = 1;
    self.addAddress.layer.shadowPath = shadowPath.CGPath;
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [self.tableView updateLayout];
    
    [self.tableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:AddressTableViewCellID];

    self.tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView ly_startLoading];
        [self requestMall_listAddress];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//显示或隐藏添加地址按钮
-(void)showOrHiddenTheAddBtn:(BOOL)show
{
//    self.tableView.hidden = show;
    if (show) {
        [self.view bringSubviewToFront:self.addAddress];
    }else{
        [self.view bringSubviewToFront:self.tableView];
    }
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddressTableViewCellID];
    cell.model = self.dataArray[indexPath.row];
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
    @weakify(self)
    /*
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"需要编辑此地址嘛?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除该地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑该地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        EditAddressViewController *eaVC = [EditAddressViewController new];
        eaVC.refreshBlock = ^{
            
        };
        [self.navigationController pushViewController:eaVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:deleteAction];
    [alertVC addAction:editAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
     */
    EditAddressViewController *eaVC = [EditAddressViewController new];
    AddressModel *model = self.dataArray[indexPath.row];
    eaVC.model = model;
    eaVC.refreshBlock = ^{
        @strongify(self)
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:eaVC animated:YES];
}

#pragma mark ---- 请求发送
//收获地址列表
-(void)requestMall_listAddress
{
    [HttpRequest postWithURLString:Mall_listAddress parameters:nil isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.dataArray = [AddressModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self showOrHiddenTheAddBtn:!self.dataArray.count];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } RefreshAction:nil];
}




@end
