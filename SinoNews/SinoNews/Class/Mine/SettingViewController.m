
//  SettingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/6.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;
@end

@implementation SettingViewController

-(NSMutableArray *)mainDatasource
{
    if (!_mainDatasource) {
        NSArray *title = @[
                           @"夜间模式",
                           @"字体大小",
                           @"视频自动播放",
                           @"检查更新",
                           @"清除缓存",
                           @"关于",
                           @"隐私协议",
                           @"退出登录",
                           ];
        
        NSArray *rightTitle = @[
                                @"",
                                @"",
                                @"仅WI-FI网络",
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
            
            if (i < 5) {
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
    self.navigationItem.title = @"设置";
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
        cell.detailTextLabel.textColor = RGBA(194, 194, 194, 1);
        
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    NSString *title = GetSaveString(model[@"title"]);
    cell.textLabel.text = title;
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    cell.accessoryType = 0;
    
    if ([title isEqualToString:@"字体大小"]) {
        cell.accessoryType = 1;
    }else if([title isEqualToString:@"清除缓存"]){
        cell.detailTextLabel.text = [NSString getCacheSize];
    }else if ([title isEqualToString:@"夜间模式"]){
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
        if (UserGetBool(@"NightMode")) {
            icon.image = UIImageNamed(@"setting_nightModeSelected");
        }else{
            icon.image = UIImageNamed(@"setting_nightModeUnSelected");
        }
        cell.accessoryView = icon;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
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
    
    NSArray *section = self.mainDatasource[indexPath.section];
    NSString *title = GetSaveString(section[indexPath.row][@"title"]);
    
    if (CompareString(title, @"夜间模式")) {
        if (UserGetBool(@"NightMode")) {
            UserSetBool(NO, @"NightMode")
        }else{
            UserSetBool(YES, @"NightMode")
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
    }else if (CompareString(title, @"清除缓存")){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"需要清除缓存嘛？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([NSString clearCache]) {
                LRToast(@"清理完毕~");
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不用了" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if (CompareString(title, @"退出登录")){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserModel clearLocalData];
            //重构主界面
            MainTabbarVC *mainVC = [MainTabbarVC new];
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            keyWindow.rootViewController = mainVC;
            
            [keyWindow makeKeyAndVisible];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不用了" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}


@end
