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
    self.view.backgroundColor = WhiteColor;
    [self configUI];
    [self showOrHiddenTheAddBtn:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configUI {
    
    self.addAddress = [UIButton new];
    [self.addAddress setTitleColor:RGBA(136, 136, 136, 1) forState:UIControlStateNormal];
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
    [self.addAddress setTitle:@"添加新地址" forState:UIControlStateNormal];
    @weakify(self)
    [[self.addAddress rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        EditAddressViewController *eaVC = [EditAddressViewController new];
        eaVC.refreshBlock = ^{
            
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
    self.tableView.backgroundColor = BACKGROUND_COLOR;
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
}

//显示或隐藏添加地址按钮
-(void)showOrHiddenTheAddBtn:(BOOL)show
{
    self.tableView.hidden = show;
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddressTableViewCellID];
    cell.model = self.dataArray[indexPath.row];
    
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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"需要编辑此地址嘛?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除该地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    @weakify(self)
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
}






@end
