//
//  NewSettingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/8/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NewSettingViewController.h"
#import "SettingViewController.h"
#import "PersonalDataViewController.h"

@interface NewSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
//上方
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *datasource;
@end

@implementation NewSettingViewController
-(NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray new];
        [_datasource addObject:@"账户设置"];
        [_datasource addObject:@"APP设置"];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    ;
    
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

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *text = GetSaveString(self.datasource[indexPath.row]);
    cell.textLabel.text = text;
    [cell.textLabel addTitleColorTheme];
    [cell addBakcgroundColorTheme];
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *vc;
    NSString *text = GetSaveString(self.datasource[indexPath.row]);
    if (CompareString(text, @"账户设置")) {
        PersonalDataViewController *pdVC = [PersonalDataViewController new];
        vc = pdVC;
    }else if (CompareString(text, @"APP设置")){
        SettingViewController *sVC = [SettingViewController new];
        vc = sVC;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


@end
