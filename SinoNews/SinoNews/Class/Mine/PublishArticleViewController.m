//
//  PublishArticleViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishArticleViewController.h"

#import "LMWordViewController.h"
#import "LMWordView.h"
#import "LMTextHTMLParser.h"
#import "XLChannelModel.h"
#import "YBPopupMenu.h"

@interface PublishArticleViewController ()<YBPopupMenuDelegate>
@property (nonatomic, strong) LMWordViewController *wordViewController;
@property (nonatomic, strong) UIView *channelChoose;
@property (nonatomic, strong) UIButton *channelBtn;
@property (nonatomic, assign) CGFloat topViewH;
@property (nonatomic, strong) NSMutableArray *channelArr;
@property (nonatomic, strong) XLChannelModel *channelModel;

@end

@implementation PublishArticleViewController
-(UIView *)channelChoose
{
    if (!_channelChoose) {
        _channelChoose = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.topViewH)];
        [_channelChoose addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
        [self.view addSubview:_channelChoose];
        _channelBtn = [UIButton new];
        _channelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_channelChoose addSubview:_channelBtn];
        _channelBtn.sd_layout
        .leftSpaceToView(_channelChoose, 20)
        .centerYEqualToView(_channelChoose)
        .widthIs(100)
        .heightIs(self.topViewH)
        ;
        [_channelBtn setNormalTitleColor:RGB(50, 50, 50)];
        [_channelBtn setNormalTitle:@"请选择频道"];
        [_channelBtn addTarget:self action:@selector(chooseChannelAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _channelChoose;
}

-(void)chooseChannelAction:(UIButton *)sender
{
    NSMutableArray *titleArr = [NSMutableArray new];
    self.channelArr = [self getAllChannels];
    for (XLChannelModel *model in self.channelArr) {
        [titleArr addObject:model.channelName];
    }
    [YBPopupMenu showRelyOnView:sender titles:titleArr icons:nil menuWidth:80 delegate:self];
}

- (LMWordViewController *)wordViewController {
    
    if (!_wordViewController) {
        _wordViewController = [[LMWordViewController alloc] init];
        _wordViewController.showTitle = YES;
    }
    return _wordViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    NSString *title = @"发布文章";
    self.topViewH = 0;
    if (self.editType == 1) {
        title = @"发布问答";
        self.topViewH = 0;
    }
    self.navigationItem.title = title;
    [self setNavigation];
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    UIImageView *rightBtn = [UIImageView new];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 15, 40, 20);
    editBtn.titleLabel.font = PFFontL(15);
    [editBtn setNormalTitleColor:RGBA(18, 130, 238, 1)];
    [editBtn setNormalTitle:@"发布"];
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    editBtn.layer.borderWidth = 1;
    [editBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)setUI
{
    [self addChildViewController:self.wordViewController];
    
    [self.view addSubview:self.wordViewController.view];
    NSString *placehold = @"请输入标题";
    if (self.editType == 1) {
        placehold = @"请输入问题";
        self.wordViewController.view.frame = self.view.bounds;
    }else{
//        self.channelChoose.backgroundColor = WhiteColor;
        self.wordViewController.view.frame = CGRectMake(0, self.topViewH, self.view.bounds.size.width, self.view.bounds.size.height - self.topViewH);
    }
    self.wordViewController.textView.titleTextField.placeholder = placehold;
    
}

-(void)publishAction:(UIButton *)sender
{
    if (!self.channelId&&self.editType==0){
        LRToast(@"请选择频道");
        return;
    }else if ([NSString isEmpty:self.wordViewController.textView.titleTextField.text]) {
        LRToast(@"请输入标题");
        return;
    }else if (self.wordViewController.textView.attributedText.length<=0){
        LRToast(@"还没编辑内容哟");
        return;
    }
    [self requestPublishArticleWithContent:[self. wordViewController exportHTML]];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    GGLog(@"点击了 %ld",index);
    self.channelModel = self.channelArr[index];
    [_channelBtn setNormalTitle:self.channelModel.channelName];
}

#pragma make ----- 请求发送
-(void)requestPublishArticleWithContent:(NSString *)content
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //所属频道需要自己提前保存
    parameters[@"title"] = self.wordViewController.textView.titleTextField.text;
    if (self.editType) {
        //问答频道的id固定是85
        parameters[@"channelId"] = @(85);
        parameters[@"newsType"] = @(2);
    }else{
//       parameters[@"channelId"] = self.channelModel.channelId;
        parameters[@"channelId"] = self.channelId;
        parameters[@"newsType"] = @(1);
    }
    
    parameters[@"content"] = GetSaveString(content);
    
    [HttpRequest postWithURLString:News_create parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:nil RefreshAction:nil];
}

//获取本地保存的所有频道
-(NSMutableArray *)getAllChannels
{
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    NSArray *arr1 = [NSMutableArray arrayWithArray:columnArr[0]];
    NSArray *arr2 = columnArr[1];
    NSMutableArray *totalArr = [[arr1 arrayByAddingObjectsFromArray:arr2] mutableCopy];
    for (XLChannelModel *channel in [arr1 arrayByAddingObjectsFromArray:arr2]) {
        //过滤掉最新和问答频道
        if (CompareString(channel.channelId, @"82")||CompareString(channel.channelName, @"最新")||CompareString(channel.channelName, @"问答")) {
            [totalArr removeObject:channel];
        }
    }
    return totalArr;
}

@end
