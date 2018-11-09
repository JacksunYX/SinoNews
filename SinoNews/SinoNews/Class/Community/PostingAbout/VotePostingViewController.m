//
//  VotePostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VotePostingViewController.h"
#import "SelectPublishChannelViewController.h"

#import "VotePostingTableViewCell.h"
#import "VotePostingTableViewCell2.h"

#import "VoteChooseInputModel.h"

@interface VotePostingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *publishBtn;

@property (nonatomic,strong) NSMutableArray *chooseArr;
@property (nonatomic,strong) NSString *asmuchSelect;//最多选择
@property (nonatomic,strong) NSString *validTime;   //有效期
@property (nonatomic,assign) BOOL isVisible;    //是否可见

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *footView;
@end

static NSInteger limitMinNum = 2;
static NSInteger limitMaxNum = 20;
@implementation VotePostingViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(NSMutableArray *)chooseArr
{
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray new];
        
        for (int i = 0; i < 2; i ++) {
            VoteChooseInputModel *chooseModel = [VoteChooseInputModel new];
            chooseModel.content = @"";
            [_chooseArr addObject:chooseModel];
        }
    }
    return _chooseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    _asmuchSelect = @"1项";
    _validTime = @"7天";
    [self setUI];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"新投票";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#1282EE)];
    
    [_publishBtn setBtnFont:PFFontL(14)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)publishAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    //需要判断选项是否没有内容
    for (VoteChooseInputModel *model in self.chooseArr) {
        if ([NSString isEmpty:model.content]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"有还未输入内容的投票选项" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:confirm];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    }
    SelectPublishChannelViewController *spcVC = [SelectPublishChannelViewController new];
    [self.navigationController pushViewController:spcVC animated:YES];
}

-(void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#EEEEEE);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[VotePostingTableViewCell class] forCellReuseIdentifier:VotePostingTableViewCellID];
    [_tableView registerClass:[VotePostingTableViewCell2 class] forCellReuseIdentifier:VotePostingTableViewCell2ID];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.chooseArr.count;
    }else if (section == 1){
        return 3;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    @weakify(self);
    if (indexPath.section == 0) {
        VotePostingTableViewCell *cell0 = (VotePostingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VotePostingTableViewCellID];
         VoteChooseInputModel *chooseModel = self.chooseArr[indexPath.row];
        [cell0 setContent:chooseModel.content];
        [cell0 setSortNum:indexPath.row+1];
        
        cell0.deleteBlock = ^{
            @strongify(self);
            GGLog(@"移除下标:%ld",indexPath.row);
            if (self.chooseArr.count>limitMinNum) {
                [self.chooseArr removeObjectAtIndex:indexPath.row];
                [tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self popNotice:NO];
            }
        };
        cell0.inputBlock = ^(NSString * _Nonnull inputString) {
            chooseModel.content = inputString;
        };
        
        cell = cell0;
    }else if (indexPath.section == 1) {
        VotePostingTableViewCell2 *cell1 = (VotePostingTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:VotePostingTableViewCell2ID];
        if (indexPath.row == 2) {
            cell1.type = 1;
            
            cell1.switchBlock = ^(BOOL switchisOn) {
                @strongify(self);
                self.isVisible = switchisOn;
                GGLog(@"开关状态:%d",switchisOn);
            };
        }
        switch (indexPath.row) {
                case 0:{
                    [cell1 setRightTitle:self.asmuchSelect];
                    [cell1 setLeftTitle:@"最多可选"];
                }
                break;
                
                case 1:{
                    [cell1 setRightTitle:self.validTime];
                    [cell1 setLeftTitle:@"投票有效期"];
                }
                break;
                
                case 2:{
                    [cell1 setRightSwitchOn:self.isVisible];
                    [cell1 setLeftTitle:@"投票后结果可见"];
                }
                break;
                
            default:
                break;
        }
        cell = cell1;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 43;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        if (!_footView) {
            _footView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 43)];
            _footView.backgroundColor = WhiteColor;
            [_footView setBtnFont:PFFontL(14)];
            [_footView setNormalTitleColor:HexColor(#1282EE)];
            [_footView setNormalTitle:@"请输入投票选项"];
            [_footView setNormalImage:UIImageNamed(@"voteAdd_icon")];
            _footView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            _footView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [_footView addTarget:self action:@selector(addChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        footView = _footView;
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    @weakify(self);
    if (indexPath.section == 1) {
        LZPickerView *pickerView = [LZPickerView new];
        switch (indexPath.row) {
                case 0:{
                    [pickerView lzPickerVIewType:LZPickerViewTypeSexAndHeight];
                    NSMutableArray *arr = [NSMutableArray new];
                    for (int i = 0; i < self.chooseArr.count; i++) {
                        NSString *option = [NSString stringWithFormat:@"%d项",i+1];
                        [arr addObject:option];
                    }
                    pickerView.dataSource = arr;
                    pickerView.titleText = @"投票最多可选数";
                    pickerView.selectDefault = self.asmuchSelect;
                    
                    pickerView.selectValue  = ^(NSString *value){
                        @strongify(self);
                        self.asmuchSelect = value;
                        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [pickerView show];
                }
                break;
                case 1:{
                    [pickerView lzPickerVIewType:LZPickerViewTypeSexAndHeight];
                    
                    pickerView.dataSource = @[
                                              @"7天",
                                              @"14天",
                                              @"30天",
                                              @"60天",
                                              @"90天",
                                              @"180天",
                                              @"360天",
                                              
                                              ];
                    pickerView.titleText = @"投票有效期";
                    pickerView.selectDefault = self.validTime;
                    
                    pickerView.selectValue  = ^(NSString *value){
                        @strongify(self);
                        self.validTime = value;
                        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [pickerView show];
                }
                break;
                
            default:
                break;
        }
    }
    
}

//弹框提示
-(void)popNotice:(BOOL)max
{
    NSString *noticeString = [NSString stringWithFormat:@"投票项不能少于%ld个",limitMinNum];
    if (max) {
        noticeString = [NSString stringWithFormat:@"投票项不能超过%ld个",limitMaxNum];
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:noticeString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//添加投票选项
-(void)addChooseAction:(UIButton *)sender
{
    //添加的选项不能超过最大限制
    if (self.chooseArr.count>=limitMaxNum) {
        [self popNotice:YES];
    }else{
        VoteChooseInputModel *chooseModel = [VoteChooseInputModel new];
        chooseModel.content = @"";
        [self.chooseArr addObject:chooseModel];
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
