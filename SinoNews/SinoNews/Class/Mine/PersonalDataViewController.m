//
//  PersonalDataViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "WSDatePickerView.h"

@interface PersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;
@property (nonatomic ,strong) UserModel *user;
@property (nonatomic ,strong) UIView *sexSelectView;
@end

@implementation PersonalDataViewController

//性别选择视图
-(UIView *)sexSelectView
{
    if (!_sexSelectView) {
        _sexSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 71, 17)];
        _sexSelectView.backgroundColor = WhiteColor;
        
        UIButton *btn1 = [self getBtn];
        btn1.frame = CGRectMake(0, 0, 34, 17);
        [btn1 setTitle:@"男" forState:UIControlStateNormal];
        btn1.tag = 10010 + 1;

        UIButton *btn2 = [self getBtn];
        btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) + 3, 0, 34, 17);
        [btn2 setTitle:@"女" forState:UIControlStateNormal];
        btn2.tag = 10010 + 2;
        
        [_sexSelectView sd_addSubviews:@[btn1,btn2]];
    }
    return _sexSelectView;
}

-(UIButton *)getBtn
{
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = PFFontL(13);
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
    self.view.backgroundColor = WhiteColor;
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
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

//按钮点击事件
-(void)sexSelectedAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10010;
    [sender setSelected:YES];
    NSInteger another = 0;
    if (index == 1) {
        another = 10010 + 2;
    }else if (index == 2){
        another = 10010 + 1;
    }
    //获取另一个btn
    UIButton *btn2 = [self.sexSelectView viewWithTag:another];
    [btn2 setSelected:NO];
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
        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        cell.detailTextLabel.font = PFFontL(14);
        cell.detailTextLabel.textColor = RGBA(50, 50, 50, 1);
        
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    NSString *title = GetSaveString(model[@"title"]);
    cell.textLabel.text = title;
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    cell.accessoryType = 1;
    
    if ([title isEqualToString:@"头像"]) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
        [icon cornerWithRadius:21];
        NSString *avatarStr = GetSaveString(self.user.avatar);
        [icon sd_setImageWithURL:UrlWithStr(avatarStr)];
        cell.accessoryView = icon;
    }else if(CompareString(title, @"昵称")){
        cell.accessoryType = 0;
        NSString *username = GetSaveString(self.user.username);
        cell.detailTextLabel.text = username;
    }else if (CompareString(title, @"性别")){
        cell.accessoryView = self.sexSelectView;
    }else if (CompareString(title, @"生日")){
        cell.detailTextLabel.text = @"点击编辑生日";
    }else if (CompareString(title, @"收货地址")){
        cell.detailTextLabel.text = @"设置";
    }else if (CompareString(title, @"绑定手机")){
        cell.detailTextLabel.text = @"设置";
    }else if (CompareString(title, @"绑定邮箱")){
        cell.detailTextLabel.text = @"设置";
    }else if (CompareString(title, @"修改密码")){
        cell.detailTextLabel.text = @"设置";
    }
    
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
            //先对质量压缩
            NSData *imgData = [(UIImage *)data compressWithMaxLength:100 * 1024];
            UIImage *img = [UIImage imageWithData:imgData];
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        }];
    }else if (CompareString(title, @"生日")){
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            GGLog(@"选择的日期：%@",dateString);
            
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
        
    }else if (CompareString(title, @"绑定手机")){
        
    }else if (CompareString(title, @"绑定邮箱")){
        
    }else if (CompareString(title, @"修改密码")){
        
    }
}







@end
