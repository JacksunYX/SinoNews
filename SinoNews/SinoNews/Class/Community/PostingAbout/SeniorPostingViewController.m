//
//  SeniorPostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingViewController.h"
#import "SelectPublishChannelViewController.h"
#import "AddNewTitleViewController.h"
#import "AddNewContentViewController.h"

#import "SeniorPostingAddTitleCell.h"
#import "SeniorPostingAddContentCell.h"
#import "SeniorPostingAddImageCell.h"
#import "SeniorPostingAddVideoCell.h"

@interface SeniorPostingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) FSTextView *titleView;
@property (nonatomic,strong) FSTextView *contentView;
@property (nonatomic,strong) UIButton *publishBtn;
//title、content输入输入时键盘的辅助视图
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;

@end

@implementation SeniorPostingViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 240)];
        
        _titleView = [FSTextView textView];
        _titleView.font = PFFontR(20);
        _titleView.textColor = BlackColor;
        _titleView.delegate = self;
        _titleView.inputAccessoryView = self.bottomView;
        
        _contentView = [FSTextView textView];
        _contentView.font = PFFontL(15);
        _contentView.textColor = BlackColor;
        _contentView.delegate = self;
        _contentView.inputAccessoryView = self.bottomView;
        
        [_headView sd_addSubviews:@[
                                    _titleView,
                                    _contentView,
                                    ]];
        _titleView.sd_layout
        .leftEqualToView(_headView)
        .topEqualToView(_headView)
        .rightEqualToView(_headView)
        .heightIs(74)
        ;
        _titleView.placeholder = @"起个引人关注的标题哦～";
        _titleView.placeholderColor = HexColor(#BAC3C7);
        _titleView.placeholderFont = PFFontR(20);
        // 限制输入最大字符数.
        _titleView.maxLength = 25;
        // 添加输入改变Block回调.
        @weakify(self);
        [_titleView addTextDidChangeHandler:^(FSTextView *textView) {
            // 文本改变后的相应操作.
            
        }];
        // 添加到达最大限制Block回调.
        [_titleView addTextLengthDidMaxHandler:^(FSTextView *textView) {
            // 达到最大限制数后的相应操作.
            LRToast(@"帖子标题最多支持25个字符");
            @strongify(self);
            [self.view endEditing:YES];
        }];
        
        _contentView.sd_layout
        .topSpaceToView(_titleView, 0)
        .leftEqualToView(_headView)
        .rightEqualToView(_headView)
        .bottomEqualToView(_headView)
        ;
        _contentView.placeholder = @"分享观点，谈谈自己的看法，这就是一个任你发挥的平台...";
        _contentView.placeholderColor = HexColor(#B9C3C7);
        _contentView.placeholderFont = PFFontL(15);
        // 添加输入改变Block回调.
        [_contentView addTextDidChangeHandler:^(FSTextView *textView) {
            @strongify(self);
            // 文本改变后的相应操作.
            NSString *string = textView.formatText;
            if (string.length>0) {
                self.publishBtn.enabled = YES;
                [self.publishBtn setNormalTitleColor:HexColor(#1282EE)];
            }else{
                self.publishBtn.enabled = NO;
                [self.publishBtn setNormalTitleColor:HexColor(#959595)];
            }
        }];
        _contentView.borderColor = HexColor(#E3E3E3);
        _contentView.borderWidth = 1;
    }
    return _headView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _bottomView.backgroundColor = WhiteColor;
        
        _showKeyboard = [UIButton new];
        [_bottomView addSubview:_showKeyboard];
        _showKeyboard.sd_layout
        .rightSpaceToView(_bottomView, 15)
        .centerYEqualToView(_bottomView)
        .widthIs(26)
        .heightIs(24)
        ;
        [_showKeyboard setNormalImage:UIImageNamed(@"hiddenKeyboard_icon")];
        [_showKeyboard addTarget:self action:@selector(showOrHideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    [self setUI];
    
    //键盘监听
    @weakify(self);
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
}

//修改导航栏显示
-(void)addNavigationView
{
//    self.navigationItem.title = @"高级发帖";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
    UIButton *saveBtn = [self geyBtnWithIcon:@"saveThePostDraft" title:@"保存"];
    UIButton *previewBtn = [self geyBtnWithIcon:@"previewThePost" title:@"预览"];
    UIButton *composeBtn = [self geyBtnWithIcon:@"composeThePost" title:@"排版"];
    _publishBtn = [self geyBtnWithIcon:@"publishThePost" title:@"发表"];
    saveBtn.tag = 0;
    previewBtn.tag = 1;
    composeBtn.tag = 2;
    _publishBtn.tag = 3;
    [saveBtn addTarget:self action:@selector(navigationAction:) forControlEvents:UIControlEventTouchUpInside];
    [previewBtn addTarget:self action:@selector(navigationAction:) forControlEvents:UIControlEventTouchUpInside];
    [composeBtn addTarget:self action:@selector(navigationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_publishBtn addTarget:self action:@selector(navigationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barbutton1 = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
    UIBarButtonItem *barbutton2 = [[UIBarButtonItem alloc]initWithCustomView:composeBtn];
    UIBarButtonItem *barbutton3 = [[UIBarButtonItem alloc]initWithCustomView:previewBtn];
    UIBarButtonItem *barbutton4 = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    
    self.navigationItem.rightBarButtonItems = @[
                                                barbutton1,
                                                barbutton2,
                                                barbutton3,
                                                barbutton4,
                                                ];
}

//统一创建导航栏按钮
-(UIButton *)geyBtnWithIcon:(NSString *)icon title:(NSString *)bntTitle
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 40)];
//    btn.backgroundColor = Arc4randomColor;
    [btn setBtnFont:PFFontL(13)];
    [btn setNormalTitleColor:HexColor(#161A24)];
    [btn setNormalTitle:bntTitle];
    [btn setNormalImage:UIImageNamed(icon)];
    btn.imageEdgeInsets = UIEdgeInsetsMake( -20, 15, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake( 20, -15, 0, 0);
    return btn;
}

//导航栏按钮点击事件
-(void)navigationAction:(UIButton *)sender
{
    GGLog(@"%@",sender.titleLabel.text);
    switch (sender.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = HexColor(#EEEEEE);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 49 + BOTTOM_MARGIN)
    ;
    [_tableView updateLayout];
    //注册
    [_tableView registerClass:[SeniorPostingAddTitleCell class] forCellReuseIdentifier:SeniorPostingAddTitleCellID];
    [_tableView registerClass:[SeniorPostingAddContentCell class] forCellReuseIdentifier:SeniorPostingAddContentCellID];
    [_tableView registerClass:[SeniorPostingAddImageCell class] forCellReuseIdentifier:SeniorPostingAddImageCellID];
    [_tableView registerClass:[SeniorPostingAddVideoCell class] forCellReuseIdentifier:SeniorPostingAddVideoCellID];
    
    _tableView.tableHeaderView = self.headView;
    
    [self setFuctionView];
}

//下方的功能按钮视图
-(void)setFuctionView
{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    
    bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(49+BOTTOM_MARGIN)
    ;
    [bottomView updateLayout];
    
    UIView *functionView = [UIView new];
    [bottomView addSubview:functionView];
    
    functionView.sd_layout
    .topEqualToView(bottomView)
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .bottomSpaceToView(bottomView, BOTTOM_MARGIN)
    ;
    [functionView updateLayout];
    [functionView addBorderTo:BorderTypeTop borderColor:HexColor(#E3E3E3)];
    //添加功能按钮
    UIButton *emojiBtn = [UIButton new];
    UIButton *addTitleBtn = [UIButton new];
    UIButton *addContentBtn = [UIButton new];
    UIButton *addImageBtn = [UIButton new];
    UIButton *addVideoBtn = [UIButton new];
    UIButton *addPeopleBtn = [UIButton new];
    UIButton *showKeyboardBtn = [UIButton new];
    //布局
    [functionView sd_addSubviews:@[
                                   emojiBtn,
                                   addTitleBtn,
                                   addContentBtn,
                                   addImageBtn,
                                   addVideoBtn,
                                   addPeopleBtn,
                                   showKeyboardBtn,
                                   
                                   ]];
    emojiBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(functionView, 15)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [emojiBtn setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
    
    addTitleBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(emojiBtn, 30)
    .widthIs(15)
    .heightIs(19)
    ;
    [addTitleBtn setNormalImage:UIImageNamed(@"addTitle_post")];
    
    addContentBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addTitleBtn, 30)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [addContentBtn setNormalImage:UIImageNamed(@"addContent_post")];
    
    addImageBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addContentBtn, 30)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [addImageBtn setNormalImage:UIImageNamed(@"addImage_icon")];
    
    addVideoBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addImageBtn, 30)
    .widthIs(25)
    .heightIs(19)
    ;
    [addVideoBtn setNormalImage:UIImageNamed(@"addVedio_post")];
    
    addPeopleBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addVideoBtn, 30)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [addPeopleBtn setNormalImage:UIImageNamed(@"attentionPeople_normal")];
    [addPeopleBtn setSelectedImage:UIImageNamed(@"attentionPeople_light")];
    
    showKeyboardBtn.sd_layout
    .centerYEqualToView(functionView)
    .rightSpaceToView(functionView, 15)
    .widthIs(26)
    .heightIs(24)
    ;
    [showKeyboardBtn setNormalImage:UIImageNamed(@"showKeyboard_icon")];
    
    emojiBtn.tag = 0;
    addTitleBtn.tag = 1;
    addContentBtn.tag = 2;
    addImageBtn.tag = 3;
    addVideoBtn.tag = 4;
    addPeopleBtn.tag = 5;
    showKeyboardBtn.tag = 6;
    
    [emojiBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addTitleBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addContentBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addVideoBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addPeopleBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [showKeyboardBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
}

//隐藏键盘
-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

//功能按钮点击事件
-(void)functionActions:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            GGLog(@"弹出emoji键盘");
        }
            break;
        case 1:
        {
            AddNewTitleViewController *atVC = [AddNewTitleViewController new];
            RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:atVC];
            atVC.finishBlock = ^(NSString * _Nonnull inputTitle) {
                GGLog(@"回调小标题：%@",inputTitle);
            };
            [self presentViewController:navi animated:YES completion:nil];
            
        }
            break;
        case 2:
        {
            AddNewContentViewController *ancVC = [AddNewContentViewController new];
            RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:ancVC];
            ancVC.finishBlock = ^(NSString * _Nonnull inputContent) {
                GGLog(@"回调文本：%@",inputContent);
            };
            [self presentViewController:navi animated:YES completion:nil];
            
        }
            break;
        case 3:
        {
            GGLog(@"添加图片");
        }
            break;
        case 4:
        {
            GGLog(@"添加视频");
        }
            break;
        case 5:
        {
            GGLog(@"添加@的人");
        }
            break;
        case 6:
        {
            [self.titleView becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
}


@end
