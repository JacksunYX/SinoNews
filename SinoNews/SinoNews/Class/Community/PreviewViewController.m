//
//  PreviewViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PreviewViewController.h"

#import "PreviewTextTableViewCell.h"
#import "PreviewImageTableViewCell.h"

@interface PreviewViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) UIView *headView;
//目录按钮
@property (nonatomic,strong) UIButton *directoryBtn;
@property (nonatomic,strong) LeftPopDirectoryViewController *menu;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帖子预览";
    
    [self setUI];
}

- (void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[PreviewTextTableViewCell class] forCellReuseIdentifier:PreviewTextTableViewCellID];
    [_tableView registerClass:[PreviewImageTableViewCell class] forCellReuseIdentifier:PreviewImageTableViewCellID];
    [self setUpHeadView];
    
    _directoryBtn = [UIButton new];
    [self.view addSubview:_directoryBtn];
    _directoryBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .widthIs(80)
    .heightIs(60)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN + 20)
    ;
    [_directoryBtn setNormalImage:UIImageNamed(@"directory_icon")];
    [_directoryBtn addTarget:self action:@selector(popDirectoryAction) forControlEvents:UIControlEventTouchUpInside];
}

//设置标题和内容
-(void)setUpHeadView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        UILabel *title = [UILabel new];
        UILabel *content = [UILabel new];
        
        [_headView sd_addSubviews:@[
                                    title,
                                    content,
                                    
                                    ]];
        title.sd_layout
        .topSpaceToView(_headView, 10)
        .leftSpaceToView(_headView, 10)
        .rightSpaceToView(_headView, 10)
        .autoHeightRatio(0)
        ;
        title.font = PFFontR(20);
        title.text = GetSaveString(self.dataModel.postTitle);
        [title updateLayout];
        
        content.sd_layout
        .topSpaceToView(title, 10)
        .leftSpaceToView(_headView, 10)
        .rightSpaceToView(_headView, 10)
        .autoHeightRatio(0)
        ;
        content.font = PFFontR(15);
        content.text = GetSaveString(self.dataModel.postContent);
        [content updateLayout];
        
        [_headView setupAutoHeightWithBottomView:content bottomMargin:10];
    }
    _tableView.tableHeaderView = self.headView;
}

//弹出目录侧边栏
-(void)popDirectoryAction
{
    self.menu = [LeftPopDirectoryViewController new];
    self.menu.dataSource = self.dataModel.dataSource;
    self.menu.view.frame = CGRectMake(0, 0, 260, ScreenH);
    [self.menu initSlideFoundationWithDirection:SlideDirectionFromLeft];
    [self.menu show];
    
    @weakify(self);
    self.menu.clickBlock = ^(NSInteger index) {
        @strongify(self);
        GGLog(@"滚动至下标为:%ld的cell",index);
        [self.tableView scrollToRow:index inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    SeniorPostingAddElementModel *model = self.dataModel.dataSource[indexPath.row];
    if (model.addtType == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }else{
        //文本
        if(model.addtType == 0||model.addtType == 1)
        {
            PreviewTextTableViewCell *cell01 = (PreviewTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PreviewTextTableViewCellID];
            cell01.model = model;
            cell = cell01;
        }else{  //图片
            PreviewImageTableViewCell *cell2 = (PreviewImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PreviewImageTableViewCellID];
            cell2.model = model;
            cell = cell2;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeniorPostingAddElementModel *model = self.dataModel.dataSource[indexPath.row];
    if (model.addtType == 3) {
        return 0;
    }
//    else if (model.addtType == 2){
//        //根据不同屏幕宽度等比例比例计算图片高度高度
//        CGFloat h = (ScreenW * model.imageH)/model.imageW;
//        return h;
//    }
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}



@end
