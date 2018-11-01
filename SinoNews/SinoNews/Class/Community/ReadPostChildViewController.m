//
//  ReadPostChildViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadPostChildViewController.h"

#import "ReadPostListTableViewCell.h"

@interface ReadPostChildViewController ()
@property (nonatomic,strong) NSMutableArray *topBtnArr;
@end

@implementation ReadPostChildViewController
-(NSMutableArray *)topBtnArr
{
    if (!_topBtnArr) {
        _topBtnArr = [NSMutableArray new];
    }
    return _topBtnArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addTopView];
}

-(void)addTopView
{
    UIView *topView = [UIView new];
    topView.backgroundColor = WhiteColor;
    [self.view addSubview:topView];
    topView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(40)
    ;
    [topView updateLayout];
    
    NSArray *titleArr = @[
                          @"发帖时间",
                          @"回复时间",
                          @"最新热门",
                          @"最新好文",
                          ];
    CGFloat wid = ScreenW/4;
    CGFloat hei = topView.height;
    for (int i = 0; i <4; i ++) {
        UIButton *btn = [UIButton new];
        btn.tag = 100+i;
        [btn setBtnFont:PFFontM(12)];
        [btn setNormalTitleColor:LightGrayColor];
        [btn setSelectedTitleColor:HexColor(#1282ee)];
        [topView addSubview:btn];
        [self.topBtnArr addObject:btn];
        btn.sd_layout
        .leftSpaceToView(topView, wid*i)
        .topEqualToView(topView)
        .widthIs(wid)
        .heightIs(hei)
        ;
        [btn setNormalTitle:titleArr[i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self selectIndex:0];
}

//按钮点击事件
-(void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    [self selectIndex:index];
}

//选择制定下标的按钮选中，其他按钮不选中
-(void)selectIndex:(NSInteger)selected
{
    UIButton *selectedBtn = self.topBtnArr[selected];
    if (selectedBtn.selected) {
        return;
    }else{
        selectedBtn.selected = !selectedBtn.selected;
        GGLog(@"选中了下标为%ld的按钮",selected);
        
    }
    for (int i = 0; i <self.topBtnArr.count; i ++) {
        if (i != selected) {
            UIButton *otherBtn = self.topBtnArr[i];
            otherBtn.selected = NO;
        }
    }
}



@end
