//
//  ThePostListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostListViewController.h"

@interface ThePostListViewController ()<TFDropDownMenuViewDelegate>

@end

@implementation ThePostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

-(void)setUI
{
    NSMutableArray *array1 = @[
                               @"所有版块",
                               @"招商银行",
                               @"民生银行",
                               @"国内信用卡",
                               @"工商银行",
                               @"工浦发银行",
                               @"机场贵宾服务",
                               @"万豪礼赏",
                               @"二手市集",
                               @"spg俱乐部",
                               ].mutableCopy;
    NSMutableArray *array2 = @[
                               @"最新发帖",
                               @"回帖最多",
                               @"收藏最多",
                               ].mutableCopy;
    NSMutableArray *data1 = [NSMutableArray arrayWithObjects:array1, array2, nil];
    TFDropDownMenuView *menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 34) firstArray:data1 secondArray:nil];
    menu.delegate = self;
    menu.cellSelectBackgroundColor = WhiteColor;
    menu.separatorColor = ClearColor;
    menu.itemTextSelectColor = HexColor(#1282ee);
    menu.cellTextSelectColor = HexColor(#1282ee);
    menu.tableViewHeight = 170;
    menu.itemFontSize = 15;
    menu.cellTitleFontSize = 15;
    [self.view addSubview:menu];
    menu.menuStyleArray = @[
                            [NSNumber numberWithInteger:TFDropDownMenuStyleCollectionView],
                            [NSNumber numberWithInteger:TFDropDownMenuStyleTableView]
                            ].mutableCopy;
}


- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index {
    GGLog(@"index: %@", index);
}

- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column {
    GGLog(@"column: %ld", column);
}

@end
