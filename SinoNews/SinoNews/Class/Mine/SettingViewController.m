
//  SettingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/6.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SettingViewController.h"
#import "FontAndNightModeView.h"
#import "VideoAutoPlaySelectView.h"
#import "LogoutNoticeView.h"
#import "HomePageModel.h"
#import "SignInRuleWebView.h"

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
//                           @"检查更新",
                           @"清除缓存",
                           @"关于",
                           @"隐私协议",
//                           @"退出登录",
                           ];
        
        NSArray *rightTitle = @[
                                @"",
                                @"",
                                @"",
//                                @"",
                                @"",
                                @"",
                                @"",
//                                @"",
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
    self.navigationItem.title = @"设置";
    
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
            [(BaseTableView *)item setBackgroundColor:value];
        }else{
            [(BaseTableView *)item setBackgroundColor:BACKGROUND_COLOR];
        }
    });
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
        [cell.textLabel addTitleColorTheme];
        cell.detailTextLabel.font = PFFontL(14);
//        cell.detailTextLabel.textColor = RGBA(194, 194, 194, 1);
        [cell.detailTextLabel addContentColorTheme];
        
        UIView *sepLine = [UIView new];
        sepLine.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            if (UserGetBool(@"NightMode")) {
                [(UIView *)item setBackgroundColor:CutLineColorNight];
            }else{
                [(UIView *)item setBackgroundColor:CutLineColor];
            }
        });
        [cell.contentView addSubview:sepLine];
        sepLine.sd_layout
        .leftSpaceToView(cell.contentView, 10)
        .widthIs(ScreenW - 20)
        .bottomEqualToView(cell.contentView)
        .heightIs(1)
        ;
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    NSString *title = GetSaveString(model[@"title"]);
    cell.textLabel.text = title;
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    cell.accessoryType = 0;
    
    if ([title isEqualToString:@"字体大小"]) {
        cell.accessoryType = 1;
    }else if(CompareString(title, @"清除缓存")){
        cell.detailTextLabel.text = [NSString getCacheSize];
    }else if (CompareString(title, @"夜间模式")){
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
        if (UserGetBool(@"NightMode")) {
            icon.image = UIImageNamed(@"setting_nightModeSelected");
        }else{
            icon.image = UIImageNamed(@"setting_nightModeUnSelected");
        }
        cell.accessoryView = icon;
    }else if (CompareString(title, @"视频自动播放")){
        if (UserGetBool(@"VideoAutoPlay")) {
            cell.detailTextLabel.text = @"仅Wi-Fi网络";
        }else{
            cell.detailTextLabel.text = @"从不";
        }
    }
    [cell addBakcgroundColorTheme];
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
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *section = self.mainDatasource[indexPath.section];
    NSString *title = GetSaveString(section[indexPath.row][@"title"]);
    
    if (CompareString(title, @"夜间模式")) {
        if (UserGetBool(@"NightMode")) {
            UserSetBool(NO, @"NightMode")
            [LEETheme startTheme:@"NormalTheme"];
        }else{
            UserSetBool(YES, @"NightMode")
            [LEETheme startTheme:@"NightTheme"];
        }
        //发送修改了夜间模式的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NightModeChanged object:nil];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
    }else if (CompareString(title, @"字体大小")){
        [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
//            GGLog(@"夜间模式：%d,选择了下标为%ld的字体大小",open,fontIndex);
//            if (open) {
//                UserSetBool(YES, @"NightMode")
//            }else{
//                UserSetBool(NO, @"NightMode")
//            }
//            NSString *fontSize = [NSString stringWithFormat:@"%ld",fontIndex];
//            UserSet(fontSize, @"fontSize")
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:0];
        }];
    }else if (CompareString(title, @"视频自动播放")){
        [VideoAutoPlaySelectView show:^(NSInteger selectIndex) {
//            GGLog(@"选择了%ld",selectIndex);
            if (selectIndex) {
                UserSetBool(NO, @"VideoAutoPlay")
            }else{
                UserSetBool(YES, @"VideoAutoPlay")
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        }];
    }else if (CompareString(title, @"清除缓存")){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"需要清除缓存嘛？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([NSString clearCache]) {
                [HomePageModel clearLocaHistory];
                [BrowsNewsSingleton.singleton clearBrowsNewsIdArr];
                LRToast(@"清理完毕");
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不用了" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if (CompareString(title, @"关于")){
        [SignInRuleWebView showWithWebString:News_aboutUs];
    }else if (CompareString(title, @"隐私协议")){
        [SignInRuleWebView showWithWebString:News_statement];
    }else if (CompareString(title, @"退出登录")){
        
        [LogoutNoticeView show:^{
//            GGLog(@"确定退出登录");
            [UserModel clearLocalData];
            //重构主界面
//            MainTabbarVC *mainVC = [MainTabbarVC new];
//            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//            keyWindow.rootViewController = mainVC;
//
//            [keyWindow makeKeyAndVisible];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
    
}


@end
