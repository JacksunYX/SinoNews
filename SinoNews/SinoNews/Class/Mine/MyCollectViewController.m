//
//  MyCollectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectArticleCell.h"
#import "MyCollectCasinoCell.h"

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectedIndex;    //选择的下标
}
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic,strong) BaseTableView *tableView;

//文章数据源数组
@property (nonatomic,strong) NSMutableArray *articleArray;
//娱乐城数据源数组
@property (nonatomic,strong) NSMutableArray *casinoArray;
//存储选择要删除数据数组
@property (nonatomic,strong) NSMutableArray *deleteArray;

//全选按钮
@property (nonatomic,strong) UIButton *selectAllBtn;
//选择按钮
@property (nonatomic,strong) UIButton *selectedBtn;
//删除按钮
@property (nonatomic,strong) UIButton *deleteBtn;

@end

@implementation MyCollectViewController

- (NSMutableArray *)articleArray
{
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
        for (int i = 0; i< 4; i++) {
            NSString *string = [NSString stringWithFormat:@"stringstringstringstringstringstringstring%d",arc4random()%100];
            [_articleArray addObject:string];
        }
    }
    return _articleArray;
}

- (NSMutableArray *)casinoArray
{
    if (!_casinoArray) {
        _casinoArray = [NSMutableArray array];
        for (int i = 0; i< 5; i++) {
            NSString *string = [NSString stringWithFormat:@"测试测试测试测试测试测试测试测试%d",arc4random()%100];
            [_casinoArray addObject:string];
        }
    }
    return _casinoArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = WhiteColor;
    [self setTitleView];
    [self getButton];
    [self addTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BaseNavigationVC *navi = (BaseNavigationVC *)self.navigationController;
    [navi showNavigationDownLine];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BaseNavigationVC *navi = (BaseNavigationVC *)self.navigationController;
    [navi hideNavigationDownLine];
}

-(void)setTitleView
{
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"文章",@"娱乐城"] headStyle:0 layoutStyle:0];
    //    _segHead.fontScale = .85;
//    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
//    _segHead.lineHeight = 3;
//    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = RGBA(50, 50, 50, 1);
    _segHead.deSelectColor = RGBA(152, 152, 152, 1);
    _segHead.maxTitles = 2;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:nil completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
    }];
    
    self.segHead.selectedIndex = ^(NSInteger index) {
//        GGLog(@"选择了下标为：%ld",index);
        self->selectedIndex = index;
        [weakself showOrHiddenTheSelections:NO];
        [weakself.tableView reloadData];
    };
}

-(void)addTableViews
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
//    [self.tableView activateConstraints:^{
//        self.tableView.top_attr = self.view.top_attr_safe;
//        self.tableView.left_attr = self.view.left_attr_safe;
//        self.tableView.right_attr = self.view.right_attr_safe;
//        self.tableView.bottom_attr = self.view.bottom_attr_safe;
//    }];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.deleteBtn, 0)
    ;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //允许支持同时多选多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = RGBA(227, 227, 227, 1);
    //注册
    [self.tableView registerClass:[MyCollectArticleCell class] forCellReuseIdentifier:MyCollectArticleCellID];
    [self.tableView registerClass:[MyCollectCasinoCell class] forCellReuseIdentifier:MyCollectCasinoCellID];
}

//创建选择、删除按钮
- (void)getButton
{
#pragma mark 选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.frame = CGRectMake(0, 0, 40, 30);
    selectedBtn.titleLabel.font = PFFontL(15);
    selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [selectedBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    [selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = selectedBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:selectedBtn];
    
#pragma mark 删除按钮
    self.deleteBtn = [UIButton new];
    self.deleteBtn.backgroundColor = WhiteColor;
    self.deleteBtn.titleLabel.font = PFFontL(15);
    self.deleteBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
    self.deleteBtn.layer.borderWidth = 1;
    [self.view addSubview:self.deleteBtn];
    self.deleteBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(0)
    ;
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.hidden = YES;
}

//显示或隐藏下方删除控件
-(void)showOrHiddenTheSelections:(BOOL)show
{
    self.tableView.editing = show;
    self.selectedBtn.selected = show;
    self.deleteBtn.hidden = !show;
    CGFloat hei = 0;
    if (show) {
        hei = 60;
    }else{
        [self.deleteArray removeAllObjects];
    }
    self.deleteBtn.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(hei)
    ;
}

#pragma mark 按钮方法
//选择按钮方法
- (void)selectedAction:(UIButton *)btn
{
    NSMutableArray *arr;
    if (selectedIndex == 0) {
        arr = self.articleArray;
    }else if (selectedIndex == 1){
        arr = self.casinoArray;
    }
    if (arr.count) {
        btn.selected = !btn.selected;
        [self showOrHiddenTheSelections:btn.selected];
    }else{
        LRToast(@"先去收藏点东西吧~");
    }
    
}

//删除按钮方法
- (void)deleteAction:(UIButton *)btn
{
    if (!self.deleteArray.count) {
        LRToast(@"还没有选择要删掉的东西哟～");
        return;
    }
    NSMutableArray *arr;
    if (selectedIndex == 0) {
        arr = self.articleArray;
    }else if (selectedIndex == 1){
        arr = self.casinoArray;
    }
    //将数据源数组中包含有删除数组中的数据删除掉
    [arr removeObjectsInArray:self.deleteArray];
    //清空删除数组
    [self.deleteArray removeAllObjects];

    [self.tableView reloadData];
    //恢复初始状态
    [self showOrHiddenTheSelections:NO];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex == 0) {
       return self.articleArray.count;
    }else if (selectedIndex == 1){
        return self.casinoArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (selectedIndex == 0) {
        MyCollectArticleCell *cell0 = (MyCollectArticleCell *)[tableView dequeueReusableCellWithIdentifier:MyCollectArticleCellID];
//        cell0.model = self.articleArray[indexPath.row];
        cell = (MyCollectArticleCell *)cell0;
    }else if (selectedIndex == 1){
        MyCollectCasinoCell *cell1 = (MyCollectCasinoCell *)[tableView dequeueReusableCellWithIdentifier:MyCollectCasinoCellID];
//        cell1.model = self.casinoArray[indexPath.row];
        cell = (MyCollectCasinoCell *)cell1;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 0) {
        return 100;
    }else if (selectedIndex == 1){
        return 128;
    }
    return 0;
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
    if (self.tableView.editing) {
        NSArray *arr;
        if (selectedIndex == 0) {
            arr = self.articleArray;
        }else if (selectedIndex == 1){
            arr = self.casinoArray;
        }
        [self.deleteArray addObject:[arr objectAtIndex:indexPath.row]];
    }
    [self.deleteBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        
        NSArray *arr;
        if (selectedIndex == 0) {
            arr = self.articleArray;
        }else if (selectedIndex == 1){
            arr = self.casinoArray;
        }
        [self.deleteArray removeObject:[arr objectAtIndex:indexPath.row]];
    }
    if (!self.deleteArray.count) {
        [self.deleteBtn setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    }
    
}




@end
