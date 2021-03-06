//
//  PersonalDataViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "WSDatePickerView.h"
#import "LogoutNoticeView.h"
#import "BindingDataViewController.h"
#import "ChangePasswordViewController.h"
#import "AddressViewController.h"
#import "BandingVerifierViewController.h"


@interface PersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;
@property (nonatomic ,strong) UserModel *user;
@property (nonatomic ,strong) UIView *sexSelectView;
@end

@implementation PersonalDataViewController

//性别选择视图
-(UIView *)getSexSelectView
{
    if (!self.sexSelectView) {
        self.sexSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 93, 24)];
        [self.sexSelectView addBakcgroundColorTheme];
        
        UIButton *btn1 = [self getBtn];
        btn1.frame = CGRectMake(0, 0, 45, 24);
        [btn1 setTitle:@"男" forState:UIControlStateNormal];
        btn1.tag = 10010 + 1;
        
        UIButton *btn2 = [self getBtn];
        btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) + 3, 0, 45, 24);
        [btn2 setTitle:@"女" forState:UIControlStateNormal];
        btn2.tag = 10010 + 0;
        
        [self.sexSelectView sd_addSubviews:@[btn1,btn2]];
    }
    UIButton *btn1 = [self.sexSelectView viewWithTag:10010 + 1];
    UIButton *btn2 = [self.sexSelectView viewWithTag:10010 + 0];
    btn1.selected = NO;
    btn2.selected = NO;
    if (self.user.gender==0) {  //女
        btn1.selected = NO;
        btn2.selected = YES;
    }else if (self.user.gender==1){ //男
        btn1.selected = YES;
        btn2.selected = NO;
    }
    
    return self.sexSelectView;
}

-(UIButton *)getBtn
{
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = PFFontL(14);
    [btn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBA(237, 246, 255, 1)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(sexSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UserModel *)user
{
    if (!_user) {
        _user = [UserModel getLocalUserModel];
    }
    return _user;
}

-(NSMutableArray *)mainDatasource
{
    if (!_mainDatasource) {
        NSArray *title = @[
                           @"头像",
                           @"昵称",
                           @"性别",
                           @"生日",
                           @"收货地址",
                           @"绑定手机",
                           @"绑定邮箱",
                           @"修改密码",
                           @"绑定支付宝",
                           @"绑定银行卡",
                           @"退出登录",
                           ];
        
        NSArray *rightTitle = @[
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                ];
        NSMutableArray *section0 = [NSMutableArray new];
        NSMutableArray *section1 = [NSMutableArray new];
        for (int i = 0 ; i < title.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"title"] = title[i];
            dic[@"rightTitle"] = rightTitle[i];
            
            if (i < 4) {
                [section0 addObject:dic];
            }else{
                [section1 addObject:dic];
            }
        }
        _mainDatasource = [NSMutableArray new];
        [_mainDatasource addObjectsFromArray:@[section0,section1]];
        
    }
    return _mainDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(BaseTableView *)item setBackgroundColor:HexColor(#292d30)];
            [(BaseTableView *)item setSeparatorColor:CutLineColorNight];
        }else{
            [(BaseTableView *)item setBackgroundColor:HexColor(#F2F6F7)];
            [(BaseTableView *)item setSeparatorColor:CutLineColor];
        }
    });
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

//性别按钮点击事件
-(void)sexSelectedAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10010;
    @weakify(self)
    if (self.user.gender != -1) {
        LRToast(@"性别只能设置一次哦");
        return;
    }
    [self requestEditGenderWith:index haveChanged:^{
        @strongify(self)
        self.user.gender = index;
        [UserModel coverUserData:self.user];
        //刷新
        [self.tableView reloadData];
    }];

}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainDatasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainDatasource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"MineCell"];
        cell.textLabel.font = PFFontL(16);
//        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        [cell addTitleColorTheme];
        cell.detailTextLabel.font = PFFontL(14);
//        cell.detailTextLabel.textColor = RGBA(50, 50, 50, 1);
        [cell.detailTextLabel addContentColorTheme];
        
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    NSString *title = GetSaveString(model[@"title"]);
    cell.textLabel.text = title;
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    cell.accessoryType = 1;
    
    if ([title isEqualToString:@"头像"]) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
        icon.layer.cornerRadius = 21;
        icon.layer.masksToBounds = YES;
        NSString *avatarStr = GetSaveString(self.user.avatar);
        [icon sd_setImageWithURL:UrlWithStr(avatarStr)];
        cell.accessoryView = icon;
    }else if(CompareString(title, @"昵称")){
        cell.accessoryType = 0;
        NSString *username = GetSaveString(self.user.username);
        cell.detailTextLabel.text = username;
    }else if (CompareString(title, @"性别")){
        cell.accessoryView = [self getSexSelectView];
    }else if (CompareString(title, @"生日")){
        if (self.user.birthday) {
            cell.detailTextLabel.text = self.user.birthday;
        }else{
            cell.detailTextLabel.text = @"点击编辑生日";
        }
    }else if (CompareString(title, @"收货地址")){
        cell.detailTextLabel.text = @"设置";
    }else if (CompareString(title, @"绑定手机")){
        if (!self.user.mobile) {
            cell.detailTextLabel.text = @"设置";
        }else{
            cell.accessoryType = 0;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.user.mobile];
        }
    }else if (CompareString(title, @"绑定邮箱")){
        if (kStringIsEmpty(self.user.email)) {
            cell.detailTextLabel.text = @"设置";
        }else{
            cell.accessoryType = 0;
            cell.detailTextLabel.text = GetSaveString(self.user.email);
        }
    }else if (CompareString(title, @"修改密码")){
        cell.detailTextLabel.text = @"设置";
    }
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    NSString *title = GetSaveString(model[@"title"]);
    
    @weakify(self)
    if ([title isEqualToString:@"头像"]) {
        
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            @strongify(self)

            GCDAfterTime(0.5, ^{
                
                [HttpRequest uploadFileImage:User_updateAvata parameters:@{} uploadImage:(UIImage *)data success:^(id response){
                    LRToast(@"上传成功");
                    UserModel *user = [UserModel getLocalUserModel];
                    user.avatar = response[@"data"];
                    self.user = user;
                    [UserModel coverUserData:user];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
                } failure:nil RefreshAction:^{
                    self.user = [UserModel getLocalUserModel];
                    if (!self.user) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }];
                
            });
   
        }];
    }else if (CompareString(title, @"生日")){
        //获取用户的生日，如果存在就滚动到该日期
        NSDate *date = [NSDate date:GetSaveString(self.user.birthday) WithFormat:@"yyyy-MM-dd"];
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:date CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            GGLog(@"选择的日期：%@",dateString);
            @strongify(self)
            [self requestImproveUserInfoWithBirthday:dateString];
        }];
        
        //指定最小最大日期
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *minLimitDate = [minDateFormater dateFromString:@"1900-01-01"];
        datepicker.minLimitDate = minLimitDate;
        
        NSDateFormatter *maxDateFormater = [[NSDateFormatter alloc] init];
        [maxDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *maxLimitDate = [maxDateFormater dateFromString:@"2018-01-01"];
        datepicker.maxLimitDate = maxLimitDate;
        
        datepicker.dateLabelColor = [UIColor clearColor];//年-月-日-时-分 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = [UIColor whiteColor];//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;
        [datepicker show];
    }else if (CompareString(title, @"收货地址")){
        AddressViewController *aVC = [AddressViewController new];
        [self.navigationController pushViewController:aVC animated:YES];
    }else if (CompareString(title, @"绑定手机")){
        BindingDataViewController *bdVC = [BindingDataViewController new];
        bdVC.bindingType = 1;
        bdVC.isUpdate = self.user.mobile?YES:NO;
        
        [self.navigationController pushViewController:bdVC animated:YES];
    }else if (CompareString(title, @"绑定邮箱")){
        BindingDataViewController *bdVC = [BindingDataViewController new];
        if (!kStringIsEmpty(self.user.email)) {
            bdVC.isUpdate = YES;
        }
        [self.navigationController pushViewController:bdVC animated:YES];
    }else if (CompareString(title, @"修改密码")){
        ChangePasswordViewController *cpVC = [ChangePasswordViewController new];
        [self.navigationController pushViewController:cpVC animated:YES];
    }else if (CompareString(title, @"退出登录")){
        [LogoutNoticeView show:^{
            [UserModel clearLocalData];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
    
    else if (CompareString(title, @"绑定支付宝")){
//        BandingAlipayViewController *baVC = [BandingAlipayViewController new];
        BandingVerifierViewController *bvVC = [BandingVerifierViewController new];
        bvVC.verifierType = 0;
        [self.navigationController pushViewController:bvVC animated:YES];
    }else if (CompareString(title, @"绑定银行卡")){
//        BandingBankCardViewController *bbcVC = [BandingBankCardViewController new];
        BandingVerifierViewController *bvVC = [BandingVerifierViewController new];
        bvVC.verifierType = 1;
        
//        BankCardViewController *bcVC = [BankCardViewController new];
        
        [self.navigationController pushViewController:bvVC animated:YES];
    }
     
}

#pragma mark ---- 请求发送
//修改性别
-(void)requestEditGenderWith:(NSInteger)gender haveChanged:(void(^)(void))changed
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"gender"] = [NSString stringWithFormat:@"%ld",gender];
    [HttpRequest postWithURLString:User_editUserInfo parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
//        LRToast(@"性别修改成功");
        if (changed) {
            changed();
        }
        
    } failure:nil RefreshAction:^{
        self.user = [UserModel getLocalUserModel];
        if (!self.user) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.tableView reloadData];
    }];
}

//修改生日
-(void)requestImproveUserInfoWithBirthday:(NSString *)birthday
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"birthday"] = birthday;
    [HttpRequest postWithURLString:User_editUserInfo parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
//        LRToast(@"生日修改成功");
        self.user.birthday = birthday;
        [UserModel coverUserData:self.user];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        self.user = [UserModel getLocalUserModel];
        if (!self.user) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.tableView reloadData];
    }];
}



@end
