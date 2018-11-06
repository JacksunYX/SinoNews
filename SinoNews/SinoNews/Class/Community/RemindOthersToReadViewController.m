//
//  RemindOthersToReadViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "RemindOthersToReadViewController.h"

@interface RemindOthersToReadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic, strong) UITextField *searchField;
//关注用户数据数组
@property (nonatomic,strong) NSMutableArray *dataSource;
//搜索用户数据数组
@property (nonatomic,strong) NSMutableArray *searchArr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UIButton *confirmBtn;
@end

@implementation RemindOthersToReadViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *nickname = @[
                              @"李白",
                              @"床前明月光",
                              @"疑是地上霜",
                              @"举头望明月",
                              @"低头思故乡",
                              
                              ];
        for (int i = 0; i < nickname.count; i ++) {
            RemindPeople *model = [RemindPeople new];
            model.avatar = @"testAvatar";
            model.userId = i + 1055;
            model.nickname = nickname[i];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

-(NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [NSMutableArray new];
        NSArray *nickname = @[
                              @"疑是地上霜",
                              @"举头望明月",
                              @"低头思故乡",
                              @"可恶啊",
                              @"去年买包超耐磨",
                              ];
        for (int i = 0; i < nickname.count; i ++) {
            RemindPeople *model = [RemindPeople new];
            model.avatar = @"testAvatar";
            model.userId = i + 1057;
            model.nickname = nickname[i];
            [_searchArr addObject:model];
        }
    }
    return _searchArr;
}

//-(NSMutableArray *)selectedArr
//{
//    if (!_selectedArr) {
//        _selectedArr = [NSMutableArray new];
//    }
//    return _selectedArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = WhiteColor;
    [self setUI];
    [self processSelectArr];
    [self setConfirmBtnShowStatus];
}

-(void)setUI
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenW, 44)];
    titleView.backgroundColor = WhiteColor;
    [self.view addSubview:titleView];
    
    UIButton *cancel = [UIButton new];
    [cancel setNormalTitle:@"取消"];
    [cancel setBtnFont:PFFontL(14)];
    [cancel setNormalTitleColor:HexColor(#939393)];
    [cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchField = [UITextField new];
    self.searchField.backgroundColor = HexColor(#F3F5F4);
    self.searchField.delegate = self;
    
    [titleView sd_addSubviews:@[
                                cancel,
                                self.searchField,
                                ]];
    cancel.sd_layout
    .rightSpaceToView(titleView, 10)
    .centerYEqualToView(titleView)
    .widthIs(40)
    .heightIs(30)
    ;
    
    self.searchField.sd_layout
    .leftSpaceToView(titleView, 10)
    .rightSpaceToView(cancel, 10)
    .centerYEqualToView(titleView)
    .heightIs(30)
    ;
    self.searchField.sd_cornerRadius = @4;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    UIImageView *searchIcon = [[UIImageView alloc]initWithImage:UIImageNamed(@"leftSearch_icon")];
    [leftView addSubview:searchIcon];
    searchIcon.center = leftView.center;
    self.searchField.leftView = leftView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.font = PFFontL(14);
    self.searchField.textColor = HexColor(#939393);
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setNormalTitleColor:WhiteColor];
    [self.confirmBtn setBtnFont:PFFontL(16)];
    [self.view addSubview:self.confirmBtn];
    
    self.confirmBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(46)
    ;
    [self.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .topSpaceToView(titleView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.confirmBtn, 0)
    ;
    
    [_tableView registerClass:[RemindSelectTableViewCell class] forCellReuseIdentifier:RemindSelectTableViewCellID];
    if (self.type) {
        _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
            
        }];
    }
}

//处理选中数组
-(void)processSelectArr
{
    if (self.type) {
        if (self.selected2Arr.count>0) {
            //比对搜索结果,如果关键字有类似的需要置顶
            NSMutableArray *copyArr = [self.searchArr mutableCopy];
            for (int i = 0; i < copyArr.count; i++) {
                RemindPeople *model = copyArr[i];
                for (RemindPeople *model2 in self.selected2Arr) {
                    if (model2.userId == model.userId) {
                        //置顶
                        [self sortArr:self.searchArr atIndex:i];
                        break;
                    }
                }
            }
        }
    }else{
        if (self.selectedArr.count>0) {
            //如果关注列表为空，不需要做其他处理
            if (self.dataSource.count<=0) {
                self.dataSource = self.selectedArr;
            }else{
                //从其他界面进入1级界面
                //有一种特殊情况，就是保存的草稿里有@某个人，但是后来取消了对这个人的关注，然后用户又对这篇草稿继续编辑，进入@选择界面
                NSMutableArray *copyArr = [self.selectedArr mutableCopy];
                for (int i = 0; i < copyArr.count; i++) {
                    RemindPeople *model = copyArr[i];
                    //遍历原有数组
                    for (RemindPeople *model2 in self.dataSource) {
                        //如果有，则把原有数据置为选中，把传递过来的选中数组中的此元素移除
                        if (model2.userId == model.userId) {
                            model2.isSelected = YES;
                            [self.selectedArr removeObject:model];
                            break;
                        }
                    }
                }
                //self.selectedArr数组中剩下的都是当前没有的数据了
                if (self.selectedArr.count>0) {
                    [self.dataSource addObjectsFromArray:self.selectedArr];
                }
                //别忘了，此时的self.selectedArr并不是完整的，copyArr才是最开始传递过来的
                self.selectedArr = [copyArr mutableCopy];
                [self setConfirmBtnShowStatus];
                [self.tableView reloadData];
            }
            
        }
    }
    [self.tableView reloadData];
}

//将index下标的元素调整到首位
-(void)sortArr:(NSMutableArray *)arr atIndex:(NSInteger)index
{
    RemindPeople *model = arr[index];
    model.isSelected = YES;
    [self.selectedArr addObject:model];
    [arr removeObjectAtIndex:index];
    [arr insertObject:model atIndex:0];
}

//处理从2级界面传递过来的选中数组
-(void)processSecondSelectArr:(NSMutableArray *)selectArr
{
    if (selectArr.count>0) {
        NSMutableArray *copyArr = [selectArr mutableCopy];
        for (int i = 0; i < copyArr.count; i++) {
            RemindPeople *model = copyArr[i];
            //遍历原有数组
            for (RemindPeople *model2 in self.dataSource) {
                //如果回调的数组中有当前界面的
                if (model2.userId == model.userId) {
                    //如果当前有这条数据，需要移除。判断是否选中，原本就选中则直接移除，反之，则先添加到选中数组，再移除
                    if (!model2.isSelected) {
                        //置为选中
                        model2.isSelected = YES;
                        [self.selectedArr addObject:model];
                    }
                    [selectArr removeObject:model];
                    break;
                    
                }
            }
        }
        //最后剩余当前界面没有的，拼接上去
        if (selectArr.count>0) {
            [self.dataSource addObjectsFromArray:selectArr];
            [self.selectedArr addObjectsFromArray:selectArr];
        }
        [self setConfirmBtnShowStatus];
        [self.tableView reloadData];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确认事件
-(void)confirmAction:(UIButton *)sender
{
    if (self.selectBlock) {
        self.selectBlock(self.selectedArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//设置确定按钮的显示
-(void)setConfirmBtnShowStatus
{
    UIColor *backgroundColor;
    NSString *string = @"确定";
    if (self.selectedArr.count>0) {
        string = [string stringByAppendingFormat:@"(%lu)",(unsigned long)self.selectedArr.count];
        backgroundColor = HexColor(#1282EE);
    }else{
        backgroundColor = HexColor(#A1C5E5);
    }
    [self.confirmBtn setNormalTitle:string];
    self.confirmBtn.backgroundColor = backgroundColor;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type) {
        return self.searchArr.count;
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindSelectTableViewCell *cell = (RemindSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RemindSelectTableViewCellID];
    if (self.type) {
        cell.model = self.searchArr[indexPath.row];
    }else{
        cell.model = self.dataSource[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    RemindPeople *model;
    if (self.type==0) {
        model = self.dataSource[indexPath.row];
    }else{
        model = self.searchArr[indexPath.row];
    }
    
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.selectedArr addObject:model];
    }else{
        //找到相同id的移除
        for (RemindPeople *removeModel in self.selectedArr) {
            if (removeModel.userId == model.userId) {
                [self.selectedArr removeObject:removeModel];
                break;
            }
        }
    }
    
    [self setConfirmBtnShowStatus];
    
    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --- UITextFieldDelegate ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchField) {
        if ([NSString isEmpty:self.searchField.text]) {
            LRToast(@"请输入你想@的人");
        }else{
            
            [textField resignFirstResponder];
            if (self.type == 0) {
                RemindOthersToReadViewController *rotrVC = [RemindOthersToReadViewController new];
                rotrVC.type = 1;
                rotrVC.keyword = self.searchField.text;
                rotrVC.selected2Arr = self.selectedArr;
                @weakify(self);
                rotrVC.selectBlock = ^(NSMutableArray * _Nonnull selectArr) {
                    GGLog(@"2级页面回调");
                    @strongify(self);
                    [self processSecondSelectArr:selectArr];
                };
                [self.navigationController pushViewController:rotrVC animated:YES];
            }else{
                //执行搜索请求
            }
        }
    }
    return YES;
}

//请求


@end
