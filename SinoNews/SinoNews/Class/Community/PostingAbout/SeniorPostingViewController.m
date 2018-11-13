//
//  SeniorPostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//
//

#import "SeniorPostingViewController.h"
#import "SelectPublishChannelViewController.h"
#import "AddNewTitleViewController.h"
#import "AddNewContentViewController.h"
#import "EditImageViewController.h"
#import "EditVideoViewController.h"
#import "RemindOthersToReadViewController.h"
#import "PreviewViewController.h"

#import "SeniorPostingAddTitleCell.h"
#import "SeniorPostingAddContentCell.h"
#import "SeniorPostingAddImageCell.h"
#import "SeniorPostingAddVideoCell.h"

@interface SeniorPostingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray <SeniorPostingAddElementModel *>*dataSource;
@property (nonatomic,strong) NSMutableArray <RemindPeople *>*remindArr;
@property (nonatomic,strong) SeniorPostDataModel *postModel;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) FSTextView *titleView;
@property (nonatomic,strong) FSTextView *contentView;
@property (nonatomic,strong) UIButton *publishBtn;
//title、content输入输入时键盘的辅助视图
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *addPeopleBtn;  //@按钮

//是否正在排序中
@property (nonatomic,assign) BOOL isSorting;

//目录按钮
@property (nonatomic,strong) UIButton *directoryBtn;
@property (nonatomic,strong) LeftPopDirectoryViewController *menu;

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

-(SeniorPostDataModel *)postModel
{
    if (!_postModel) {
        _postModel = [SeniorPostDataModel new];
    }
    return _postModel;
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
            @strongify(self);
            self.postModel.postTitle = textView.formatText;
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
            self.postModel.postContent = textView.formatText;
            // 文本改变后的相应操作.
//            NSString *string = textView.formatText;
//            if (string.length>0) {
//                self.publishBtn.enabled = YES;
//                [self.publishBtn setNormalTitleColor:HexColor(#1282EE)];
//            }else{
//                self.publishBtn.enabled = NO;
//                [self.publishBtn setNormalTitleColor:HexColor(#959595)];
//            }
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
    [self setUpNavigationView:NO];
    [self setUI];
    
    [self reloadDataWithDataArrUpperCase];
    
    //键盘监听
    @weakify(self);
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
}

//修改导航栏显示
-(void)setUpNavigationView:(BOOL)openSort
{
    //    self.navigationItem.title = @"高级发帖";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
    if (openSort) {
        UIBarButtonItem *rightBarBtn = [UIBarButtonItem itemWithTarget:self action:@selector(finishAction) title:@"完成" font:PFFontR(14) titleColor:ThemeColor highlightedColor:ThemeColor titleEdgeInsets:UIEdgeInsetsZero];
        self.navigationItem.rightBarButtonItems = @[rightBarBtn];
        
    }else{
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
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            //如果没有子元素时,必须当标题跟内容同时有内容时才能预览
            //如果只有子元素，可以直接预览
            if (self.dataSource.count>0) {
                [self pushToPreviewVC];
            }else if ([NSString isEmpty:_titleView.formatText]) {
                LRToast(@"标题不能空缺哦");
            }else if ([NSString isEmpty:_contentView.formatText]){
                LRToast(@"内容不能空缺哦");
            }else{
                [self pushToPreviewVC];
            }
        }
            break;
        case 2:
        {
            //无元素，不需要排序
            if (self.dataSource.count<=0) {
                break;
            }
            [self openOrCloseSort:YES];
        }
            break;
        case 3:
        {
            for (SeniorPostingAddElementModel *model in self.dataSource) {
                NSDictionary *dic = [model mj_keyValues];
                GGLog(@"添加的内容:%@",dic);
            }
        }
            break;
            
        default:
            break;
    }
}

//排序完成点击事件
-(void)finishAction
{
    [self openOrCloseSort:NO];
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
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    _addPeopleBtn = [UIButton new];
    UIButton *showKeyboardBtn = [UIButton new];
    //布局
    CGFloat avgSpaceX = 20;
    [functionView sd_addSubviews:@[
                                   emojiBtn,
                                   addTitleBtn,
                                   addContentBtn,
                                   addImageBtn,
                                   addVideoBtn,
                                   _addPeopleBtn,
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
    .leftSpaceToView(emojiBtn, avgSpaceX)
    .widthIs(15)
    .heightIs(19)
    ;
    [addTitleBtn setNormalImage:UIImageNamed(@"addTitle_post")];
    
    addContentBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addTitleBtn, avgSpaceX)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [addContentBtn setNormalImage:UIImageNamed(@"addContent_post")];
    
    addImageBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addContentBtn, avgSpaceX)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [addImageBtn setNormalImage:UIImageNamed(@"addImage_icon")];
    
    addVideoBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addImageBtn, avgSpaceX)
    .widthIs(25)
    .heightIs(19)
    ;
    [addVideoBtn setNormalImage:UIImageNamed(@"addVedio_post")];
    
    _addPeopleBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addVideoBtn, avgSpaceX)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    [_addPeopleBtn setNormalImage:UIImageNamed(@"attentionPeople_normal")];
    [_addPeopleBtn setSelectedImage:UIImageNamed(@"attentionPeople_light")];
    
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
    _addPeopleBtn.tag = 5;
    showKeyboardBtn.tag = 6;
    
    [emojiBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addTitleBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addContentBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [addVideoBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
    [_addPeopleBtn addTarget:self action:@selector(functionActions:) forControlEvents:UIControlEventTouchUpInside];
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
    if (_isSorting) {
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            GGLog(@"弹出emoji键盘");
        }
            break;
        case 1:
        {
            [self setChildTitleWithModel:nil];
        }
            break;
        case 2:
        {
            [self setChildContentWithModel:nil];
        }
            break;
        case 3:
        {
            [self checkLocalPhoto];
        }
            break;
        case 4:
        {
            [self checkLocalVedio];
        }
            break;
        case 5:
        {
            [self setRemindPeoples];
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

//弹出目录侧边栏
-(void)popDirectoryAction
{
    self.menu = [LeftPopDirectoryViewController new];
    self.menu.dataSource = self.dataSource;
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

//跳转预览界面
-(void)pushToPreviewVC
{
    PreviewViewController *pVC = [PreviewViewController new];
    pVC.dataModel = self.postModel;
    [self.navigationController pushViewController:pVC animated:YES];
}

//跳转设置需要@的人
-(void)setRemindPeoples
{
    RemindOthersToReadViewController *rotrVC = [RemindOthersToReadViewController new];
    
    rotrVC.selectedArr = self.remindArr.mutableCopy;
    
    @weakify(self);
    rotrVC.selectBlock = ^(NSMutableArray * _Nonnull selectArr) {
        GGLog(@"1级页面回调");
        @strongify(self);
        self.remindArr = selectArr.mutableCopy;
        //修改角标状态
        if (self.remindArr.count>0) {
            [self.addPeopleBtn showBadgeWithStyle:WBadgeStyleNumber value:self.remindArr.count animationType:WBadgeAnimTypeNone];
            self.addPeopleBtn.badgeBgColor = HexColor(#FF5858);
        }else{
            [self.addPeopleBtn clearBadge];
        }
        self.addPeopleBtn.selected = self.remindArr.count>0?YES:NO;
    };
    
    [self.navigationController pushViewController:rotrVC animated:YES];
}

//添加/修改小标题
-(void)setChildTitleWithModel:(SeniorPostingAddElementModel *)data
{
    AddNewTitleViewController *atVC = [AddNewTitleViewController new];
    if (data) {
        atVC.lastTitle = data.title;
    }
    RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:atVC];
    @weakify(self);
    atVC.finishBlock = ^(NSString * _Nonnull inputTitle) {
        GGLog(@"回调小标题：%@",inputTitle);
        @strongify(self);
        
        if (data) {
            data.addtType = 0;
            data.title = inputTitle;
            [self.tableView reloadData];
        }else{
            SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
            model.addtType = 0;
            model.title = inputTitle;
            [self.dataSource addObject:model];
            [self reloadDataWithDataArrUpperCase];
            [self scrollToBottom];
        }
    };
    [self presentViewController:navi animated:YES completion:nil];
}

//添加/修改文本
-(void)setChildContentWithModel:(SeniorPostingAddElementModel *)data
{
    AddNewContentViewController *ancVC = [AddNewContentViewController new];
    if (data) {
        ancVC.lastContent = data.content;
    }
    RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:ancVC];
    @weakify(self);
    ancVC.finishBlock = ^(NSString * _Nonnull inputContent) {
        GGLog(@"回调文本：%@",inputContent);
        @strongify(self);
        if (data) {
            data.addtType = 1;
            data.content = inputContent;
            [self.tableView reloadData];
        }else{
            SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
            model.addtType = 1;
            model.content = inputContent;
            [self.dataSource addObject:model];
            [self.tableView reloadData];
            [self scrollToBottom];
        }
    };
    [self presentViewController:navi animated:YES completion:nil];
}

//选择图片
- (void)checkLocalPhoto{
    //最大数初始化为1，且不让允许选择图片时，就变成了单选视频了
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

//选择视频
-(void)checkLocalVedio
{
    //最大数初始化为1，且不让允许选择图片时，就变成了单选视频了
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingImage = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

//滚动至tableView最下方
-(void)scrollToBottom
{
    [self.tableView scrollToRow:self.dataSource.count - 1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//处理小标题大写问题
-(void)reloadDataWithDataArrUpperCase
{
    int j = 1;//标记有几个小标题分区
    if (self.dataSource.count>0) {
        //遍历数据源
        for (int i = 0; i < self.dataSource.count; i ++) {
            SeniorPostingAddElementModel *model = self.dataSource[i];
            if (model.addtType==0) {//说明是小标题
                //标记是第几个小分区标题
                model.sectionNum = j;
                j ++;
            }
        }
    }
    
    if (j == 1) {   //j没有变化，说明没有小标题了，隐藏目录按钮
        _directoryBtn.hidden = YES;
    }else{
        _directoryBtn.hidden = NO;
    }
    self.postModel.dataSource = self.dataSource;
    [self.tableView reloadData];
}

//是否开启排序
-(void)openOrCloseSort:(BOOL)open
{
    //重新处理模型中的排序参数
    for (int i = 0; i < self.dataSource.count; i ++) {
        SeniorPostingAddElementModel *model = self.dataSource[i];
        model.isSort = open;
    }
    _isSorting = open;
    [self.tableView reloadData];
    [self setUpNavigationView:open];
}

/**
 排序
 
 @param index 需要排序的下标
 @param type 操作类型：0删除，1上升，2下降
 */
-(void)sortWithIndex:(NSInteger)index operationType:(NSInteger)type
{
    switch (type) {
        case 0: //删除
        {
            [self.dataSource removeObjectAtIndex:index];
        }
            break;
        case 1://上升
        {
            //当前位置是首位时，无法上升
            if (index == 0) {
                return;
            }else{
                [self.dataSource exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
            }
        }
            break;
        case 2://下降
        {
            //当前位置是末位时，无法下降
            if (index == self.dataSource.count - 1) {
                return;
            }else{
                [self.dataSource exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
            }
        }
            break;
            
        default:
            break;
    }
    [self reloadDataWithDataArrUpperCase];
    if (self.dataSource.count<=0) {
        [self finishAction];
    }
}

#pragma mark --- UITextViewDelegate ---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //禁止标题输入换行
    if (textView == _titleView&&[text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

#pragma mark --- TZImagePickerControllerDelegate ---
//选择图片后会进入该代理方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (UIImage *image in photos) {
        SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
        model.addtType = 2;
        model.image = image;
        model.imageW = image.size.width;
        model.imageH = image.size.height;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    [self scrollToBottom];
}

//选择视频后会进入该代理方法，返回了封面和视频资源文件
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset
{
    ShowHudOnly;
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        HiddenHudOnly;
        GGLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
        NSURL *videoURL = [NSURL fileURLWithPath:outputPath];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
        model.addtType = 3;
        model.videoData = videoData;
        model.image = coverImage;
        model.videoUrl = outputPath;
        [self.dataSource addObject:model];
        
        [self.tableView reloadData];
        [self scrollToBottom];
    } failure:^(NSString *errorMessage, NSError *error) {
        HiddenHudOnly;
        LRToast(@"视频导出失败");
        GGLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell.tag = indexPath.row;
    SeniorPostingAddElementModel *model = self.dataSource[indexPath.row];
    switch (model.addtType) {
        case 0://标题
        {
            SeniorPostingAddTitleCell *cell0 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddTitleCellID];
            cell0.model = model;
            cell0.deleteBlock = ^{
                [self sortWithIndex:indexPath.row operationType:0];
            };
            cell0.goUpBlock = ^{
                [self sortWithIndex:indexPath.row operationType:1];
            };
            cell0.goDownBlock = ^{
                [self sortWithIndex:indexPath.row operationType:2];
            };
            cell = cell0;
        }
            break;
        case 1://文本
        {
            SeniorPostingAddContentCell *cell1 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddContentCellID];
            cell1.model = model;
            cell1.deleteBlock = ^{
                [self sortWithIndex:indexPath.row operationType:0];
            };
            cell1.goUpBlock = ^{
                [self sortWithIndex:indexPath.row operationType:1];
            };
            cell1.goDownBlock = ^{
                [self sortWithIndex:indexPath.row operationType:2];
            };
            cell = cell1;
        }
            break;
        case 2://图片
        {
            SeniorPostingAddImageCell *cell2 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddImageCellID];
            cell2.model = model;
            cell2.deleteBlock = ^{
                [self sortWithIndex:indexPath.row operationType:0];
            };
            cell2.goUpBlock = ^{
                [self sortWithIndex:indexPath.row operationType:1];
            };
            cell2.goDownBlock = ^{
                [self sortWithIndex:indexPath.row operationType:2];
            };
            cell = cell2;
        }
            break;
        case 3://视频
        {
            SeniorPostingAddVideoCell *cell3 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddVideoCellID];
            cell3.model = model;
            cell3.deleteBlock = ^{
                GGLog(@"删除第%ld个元素",indexPath.row);
            };
            cell3.goUpBlock = ^{
                GGLog(@"上升第%ld个元素",indexPath.row);
            };
            cell3.goDownBlock = ^{
                GGLog(@"下降第%ld个元素",indexPath.row);
            };
            cell = cell3;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    SeniorPostingAddElementModel *model = self.dataSource[indexPath.row];
    switch (model.addtType) {
        case 0://标题
        {
            [self setChildTitleWithModel:model];
        }
            break;
        case 1://文本
        {
            [self setChildContentWithModel:model];
        }
            break;
        case 2://图片
        {
            EditImageViewController *eiVC = [EditImageViewController new];
            eiVC.model = model;
            @weakify(self);
            eiVC.finishBlock = ^(SeniorPostingAddElementModel * _Nonnull finishModel) {
                @strongify(self);
                self.dataSource[indexPath.row] = finishModel;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:eiVC animated:YES];
        }
            break;
        case 3://视频
        {
            EditVideoViewController *evVC = [EditVideoViewController new];
            evVC.model = model;
            @weakify(self);
            evVC.finishBlock = ^(SeniorPostingAddElementModel * _Nonnull finishModel) {
                @strongify(self);
                self.dataSource[indexPath.row] = finishModel;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:evVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}





@end
