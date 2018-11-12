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

@interface SeniorPostingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>
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
    CGFloat avgSpaceX = 20;
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
    
    addPeopleBtn.sd_layout
    .centerYEqualToView(functionView)
    .leftSpaceToView(addVideoBtn, avgSpaceX)
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
    @weakify(self);
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
                @strongify(self);
                SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
                model.addtType = 0;
                model.title = inputTitle;
                [self.dataSource addObject:model];
                [self.tableView reloadData];
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
                @strongify(self);
                SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
                model.addtType = 1;
                model.content = inputContent;
                [self.dataSource addObject:model];
                [self.tableView reloadData];
            };
            [self presentViewController:navi animated:YES completion:nil];
            
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

#pragma mark --- TZImagePickerControllerDelegate ---
//选择图片后会进入该代理方法，
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (UIImage *image in photos) {
        SeniorPostingAddElementModel *model = [SeniorPostingAddElementModel new];
        model.addtType = 2;
        model.image = image;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
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
    SeniorPostingAddElementModel *model = self.dataSource[indexPath.row];
    switch (model.addtType) {
        case 0://标题
        {
            SeniorPostingAddTitleCell *cell0 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddTitleCellID];
            cell0.model = model;
            cell = cell0;
        }
            break;
        case 1://文本
        {
            SeniorPostingAddContentCell *cell1 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddContentCellID];
            cell1.model = model;
            cell = cell1;
        }
            break;
        case 2://图片
        {
            SeniorPostingAddImageCell *cell2 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddImageCellID];
            cell2.model = model;
            cell = cell2;
        }
            break;
        case 3://视频
        {
            SeniorPostingAddVideoCell *cell3 = [tableView dequeueReusableCellWithIdentifier:SeniorPostingAddVideoCellID];
            cell3.model = model;
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
