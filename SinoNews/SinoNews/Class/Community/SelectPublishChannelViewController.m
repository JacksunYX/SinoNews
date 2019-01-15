//
//  SelectPublishChannelViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectPublishChannelViewController.h"

#import "ForumLeftTableViewCell.h"
#import "SelectPublishChannelCell.h"

@interface SelectPublishChannelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *centerTable;
@property (nonatomic,strong) BaseTableView *rightTable;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@property (nonatomic,assign) NSInteger centerSelectedIndex;

@property (nonatomic,strong) UIButton *publishBtn;

@end

@implementation SelectPublishChannelViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *leftArr = @[
                             @"我的关注",
                             @"酒店常客",
                             @"航空常客",
                             @"信用卡",
                             @"飞科生活",
                             ];
        NSArray *centerArr = @[
                               @"酒店Report",
                               @"IHG优悦会",
                               @"万豪礼赏",
                               @"spg俱乐部",
                               @"希尔顿荣誉客会",
                               ];
        NSArray *rightArr = @[
                              @"洲际",
                              @"喜达屋",
                              @"雅高",
                              @"万豪",
                              @"凯悦",
                              ];
        
        [_dataSource addObject:leftArr];
        [_dataSource addObject:centerArr];
        [_dataSource addObject:rightArr];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    
    @weakify(self);
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNet" title:@"" refreshBlock:^{
        @strongify(self);
        ShowHudOnly;
        [self requestSectionTree];
    }];
    [self requestSectionTree];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"选择发表到的版块";
    [self setTopLineColor:HexColor(#E3E3E3)];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#161A24)];
    
    [_publishBtn setBtnFont:PFFontR(16)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)setUI
{
    if (_leftTable) {
        return;
    }
    CGFloat avgW = ScreenW *(1.0/3);
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTable.backgroundColor = HexColor(#EEEEEE);
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTable.separatorColor = CutLineColor;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    
    _centerTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _centerTable.backgroundColor = WhiteColor;
    _centerTable.delegate = self;
    _centerTable.dataSource = self;
    _centerTable.showsVerticalScrollIndicator = NO;
    _centerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_centerTable];
    _centerTable.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(_leftTable, 0)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_centerTable updateLayout];
    [_centerTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTable.backgroundColor = WhiteColor;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.showsVerticalScrollIndicator = NO;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    _rightTable.sd_layout
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
    //如果是firstIndex=-1，说明是从我的关注列表里进入的版块
    if (self.postModel.sectionId) {
        NSArray *indexs = [self getSectionIndexsWithId:self.postModel.sectionId];
        NSInteger firstIndex = [indexs[0] integerValue];
        NSInteger secondIndex = [indexs[1] integerValue];
        NSInteger thirdIndex = [indexs[2] integerValue];
        
        [self selectFirstView:firstIndex];
        [self selectSecondView:secondIndex];
        [self selectThirdView:thirdIndex];
    }else{
        [self selectFirstView:0];
    }
}

//发表
-(void)publishAction:(UIButton *)sender
{
    if (self.postModel.sectionId == 0) {
        LRToast(@"没有选择版块哟");
        return;
    }
    if (self.postModel.isToll) {
        [self popInputIntegral];
    }else{
        [self requestPublishPost:0];
    }
}

//弹框输入付费积分
-(void)popInputIntegral
{
    NSString *title = @"请输入付费积分";;
    NSString *message = @"付费积分不能为0";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"0";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = [alertController.textFields objectAtIndex:0];
        NSInteger rewardPoint = [textField.text integerValue];
        if (rewardPoint>0) {
            [self requestPublishPost:rewardPoint];
        }else{
            LRToast(@"付费积分不能为0哦");
        }
        
    }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if是为了获取删除操作,如果没有if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    //限制最大输入长度
    else if (textField.text.length >= 5) {
        textField.text = [textField.text substringToIndex:5];
        return NO;
    }
    
    return [self validateNumber:string];
}

//检测是否是纯数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//查找对应版块id所在的分级
-(NSArray *)getSectionIndexsWithId:(NSInteger)sectionId
{
    NSMutableArray *indexs = @[].mutableCopy;
    NSInteger firstIndex = 0;
    NSInteger secondIndex = 0;
    NSInteger thirdIndex = 0;
    
    //是否有1级
    if (self.dataSource.count>0) {
        for (int i = 0; i < self.dataSource.count; i ++) {
            MainSectionModel *model1 = self.dataSource[i];
            //是否就在1级版块
            if (model1.sectionId == sectionId) {
                firstIndex = i;
                [indexs addObject:@(firstIndex)];
                [indexs addObject:@(secondIndex)];
                [indexs addObject:@(thirdIndex)];
                return indexs;
            }
            //是否有2级
            if (model1.subSections.count > 0) {
                for (int j = 0; j < model1.subSections.count; j ++) {
                    MainSectionModel *model2 = model1.subSections[j];
                    //是否就在2级版块
                    if (model2.sectionId == sectionId) {
                        firstIndex = i;
                        secondIndex = j;
                        [indexs addObject:@(firstIndex)];
                        [indexs addObject:@(secondIndex)];
                        [indexs addObject:@(thirdIndex)];
                        return indexs;
                    }
                    //是否有3级
                    if (model2.subSections.count>0) {
                        for (int k = 0; k < model2.subSections.count; k ++) {
                            MainSectionModel *model3 = model2.subSections[k];
                            if (model3.sectionId == sectionId) {
                                firstIndex = i;
                                secondIndex = j;
                                thirdIndex = k;
                                [indexs addObject:@(firstIndex)];
                                [indexs addObject:@(secondIndex)];
                                [indexs addObject:@(thirdIndex)];
                                return indexs;
                            }
                        }
                    }else{
                        continue;
                    }
                }
            }else{
                continue;
            }
        }
    }else{
        NSLog(@"没有版块数据");
        [indexs addObject:@(firstIndex)];
        [indexs addObject:@(secondIndex)];
        [indexs addObject:@(thirdIndex)];
    }
    if (indexs.count<=0) {
        NSLog(@"没有找到对应的版块");
        [indexs addObject:@(firstIndex)];
        [indexs addObject:@(secondIndex)];
        [indexs addObject:@(thirdIndex)];
    }
    
    return indexs;
}

#pragma mark --- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        return self.dataSource.count;
    }
    if (tableView == _centerTable) {
        if (self.dataSource.count>0) {
            MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
            return model.subSections.count;
        }
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        return model.subSections.count;
    }
    if (tableView == _rightTable) {
        if (self.dataSource.count>0) {
            MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
            if (model.subSections.count>0) {
                MainSectionModel *model2 = model.subSections[self.centerSelectedIndex];
                return model2.subSections.count;
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell0 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        MainSectionModel *model = self.dataSource[indexPath.row];
        [cell0 setTitle:model.name];
        cell = cell0;
    }else if (tableView == _centerTable) {
        SelectPublishChannelCell *cell1 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        cell1.type = 1;
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        [cell1 setTitle:model2.name];
        cell = cell1;
    }else if (tableView == _rightTable) {
        SelectPublishChannelCell *cell2 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[self.centerSelectedIndex];
        MainSectionModel *model3 = model2.subSections[indexPath.row];
        [cell2 setTitle:model3.name];
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.frame.size.width tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        [self selectFirstView:indexPath.row];
    }else if (tableView == _centerTable){
        [self selectSecondView:indexPath.row];
    }else if (tableView == _rightTable){
        [self selectThirdView:indexPath.row];
    }
}

//选中一级的某个cell
-(void)selectFirstView:(NSInteger)index
{
    if (self.dataSource.count>0) {
        [_leftTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.leftSelectedIndex = index;
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        if (model.subSections.count<=0) {
            //没有二级版块
            [self.centerTable reloadData];
            self.postModel.sectionId = model.sectionId;
        }else{
            [self selectSecondView:0];
        }
    }else{
        NSLog(@"一级版块数据为空");
    }
}

//选中二级的某个cell
-(void)selectSecondView:(NSInteger)index
{
    [_centerTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_centerTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.centerSelectedIndex = indexPath.row;
    MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
    MainSectionModel *model2 = model.subSections[index];
    if (model2.subSections.count<=0) {
        //没有三级版块
        [self.rightTable reloadData];
        self.postModel.sectionId = model2.sectionId;
    }else{
        [self selectThirdView:0];
    }
}

//选中三级的某个cell
-(void)selectThirdView:(NSInteger)index
{
    [_rightTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    MainSectionModel *model = self.dataSource[_leftSelectedIndex];
    MainSectionModel *model2 = model.subSections[_centerSelectedIndex];
    if (model2.subSections.count>0) {
        MainSectionModel *model3 = model2.subSections[index];
        self.postModel.sectionId = model3.sectionId;
    }
}

#pragma mark --请求
//请求主版块数据
-(void)requestListMainSection
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:ListMainSection parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        self.dataSource = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//请求二级版块数据
-(void)requestListSubSection:(MainSectionModel *)model
{
    [HttpRequest getWithURLString:ListSubSection parameters:@{@"sectionId":@(model.sectionId)} success:^(id responseObject) {
        NSArray *subListArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        model.subSections = subListArr.mutableCopy;
        
        [self selectSecondView:0];
    } failure:^(NSError *error) {
        [self.centerTable reloadData];
    }];
}

//请求版块树
-(void)requestSectionTree
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:SectionTree parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        self.dataSource = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//发表帖子(积分)
-(void)requestPublishPost:(NSInteger)integer
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSMutableDictionary *dic = [self.postModel mj_JSONObject];
    NSMutableArray *dataSource = dic[@"dataSource"];
    for (int i = 0; i < dataSource.count; i ++) {
        NSMutableDictionary *item = dataSource[i];
        if (item[@"imageData"]) {
            [item removeObjectForKey:@"imageData"];
        }
        if (item[@"videoData"]){
            [item removeObjectForKey:@"videoData"];
        }
    }
    //重新处理@数组
    NSArray *remindArr = dic[@"remindPeople"];
    NSMutableArray *remindPeople = @[].mutableCopy;
    for (int j = 0; j < remindArr.count; j ++) {
        NSDictionary *people = remindArr[j];
        [remindPeople addObject:@([people[@"userId"] integerValue])];
    }
    dic[@"remindPeople"] = remindPeople;
    
    parameters[@"postModel"] = [dic mj_JSONString];
    NSLog(@"parameters:%@",parameters);
    [HttpRequest postWithURLString:PublishPost parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"发布成功,等待审核通过后即可显示");
        //记得要从本地草稿箱移除
        [SeniorPostDataModel remove:self.postModel];
        if (self.refreshCallBack) {
            self.refreshCallBack();
        }
        GCDAfterTime(1, ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    } failure:nil RefreshAction:nil];
}

@end
