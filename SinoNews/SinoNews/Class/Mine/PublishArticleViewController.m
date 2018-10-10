//
//  PublishArticleViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishArticleViewController.h"
#import "ZSSCustomButtonsViewController.h"

#import "LMWordViewController.h"
#import "LMWordView.h"
#import "LMTextHTMLParser.h"
#import "XLChannelModel.h"
#import "YBPopupMenu.h"
#import "ChannelSelectView.h"
#import "NewPublishModel.h"


@interface PublishArticleViewController ()<YBPopupMenuDelegate,UITextFieldDelegate>
{
    //不可以用作当前控制器的属性，否则会崩溃
    ZSSCustomButtonsViewController *inputViewController;
}

@property (nonatomic, strong) LMWordViewController *wordViewController;
@property (nonatomic, strong) UIView *channelChoose;
@property (nonatomic, strong) UIButton *channelBtn;
@property (nonatomic, assign) CGFloat topViewH;
@property (nonatomic, strong) NSMutableArray *channelArr;
@property (nonatomic, strong) XLChannelModel *channelModel;

//第二版
@property (nonatomic, strong) UIView *channelSelectionView;
@property (nonatomic, strong) TXLimitedTextField *titleInputField;
@property (nonatomic, strong) ChannelSelectView *selectView;

@property (nonatomic,assign) NSInteger rewardPoint; //悬赏积分
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
    
    [self showTopLine];
    
    NSString *title = @"发布文章";
    if (self.isPayArticle) {
        title = @"发布文章(免费内容)";
    }
    self.topViewH = 54;
    if (self.editType == 1) {
        title = @"发布问答";
        self.topViewH = 0;
    }else if(self.editType == 2){
        title = @"发布文章(付费内容)";
        self.topViewH = 0;
    }
    self.navigationItem.title = title;
    [self setNavigation];
    //    [self setUI];
    [self setUI2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    UIButton *rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    
    UILabel *editBtn = [UILabel new];
    editBtn.textAlignment = NSTextAlignmentCenter;
    editBtn.userInteractionEnabled = NO;
    editBtn.frame = CGRectMake(0, 10, 40, 20);
    editBtn.font = PFFontL(15);
    editBtn.textColor = RGBA(18, 130, 238, 1);
    editBtn.text = @"发布";
    if (self.isPayArticle&&self.editType!=2) {
        rightBtn.frame = CGRectMake(0, 0, 60, 40);
        editBtn.text = @"下一步";
        editBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    editBtn.layer.borderWidth = 1;
    //    [rightBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [rightBtn whenTap:^{
        @strongify(self);
        [self publishActionWithDraft:NO];
    }];
    [rightBtn addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left"]];
}

-(void)back
{
    if (!kStringIsEmpty(self.wordViewController.textView.attributedText.string)&&self.editType==0) {
        //在这里做保存处理
        GGLog(@"需要保存的文本：%@",self.wordViewController.textView.attributedText);
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void)setUI2
{
    //频道选择
    _channelSelectionView = [UIView new];
    [self.view addSubview:_channelSelectionView];
    _channelSelectionView.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(self.topViewH)
    ;
    [_channelSelectionView updateLayout];
    [_channelSelectionView addBorderTo:BorderTypeBottom borderColor:HexColor(#E3E3E3)];
    
    if (self.editType==0) {
        UILabel *channelLabel = [UILabel new];
        channelLabel.font = PFFontL(15);
        channelLabel.textColor = HexColor(#626262);
        [_channelSelectionView addSubview:channelLabel];
        channelLabel.sd_layout
        .topEqualToView(_channelSelectionView)
        .leftEqualToView(_channelSelectionView)
        .heightIs(self.topViewH)
        .widthIs(45)
        ;
        channelLabel.text = @"频道：";
        
        self.selectView = [ChannelSelectView new];
        [_channelSelectionView addSubview:self.selectView];
        self.selectView.sd_layout
        .topEqualToView(_channelSelectionView)
        .leftSpaceToView(channelLabel, 0)
        .heightIs(self.topViewH-1)
        .rightSpaceToView(_channelSelectionView, 0)
        ;
        [self.selectView updateLayout];
        //构建视图
        [self.selectView setViewWithChannelArr:[self getAllChannels]];
        //回调
        @weakify(self);
        self.selectView.selectBlock = ^(NSString *channelIdStr) {
            @strongify(self);
            self.channelId = channelIdStr;
        };
    }
    
    //添加输入界面
    inputViewController = [[ZSSCustomButtonsViewController alloc]init];
    if (self.isPayArticle) {
        inputViewController.hiddenSettingBtn = YES;
    }
    if (self.draftModel) {
        [inputViewController setHTML:self.draftModel.content];
    }
    
    if (self.editType == 2&&self.isPayArticle) {
        inputViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }else{
        //标题
        _titleInputField = [TXLimitedTextField new];
        _titleInputField.font = PFFontL(17);
        _titleInputField.placeholder = @"请输入标题";
        _titleInputField.delegate = self;
        [self.view addSubview:_titleInputField];
        _titleInputField.sd_layout
        .topSpaceToView(_channelSelectionView, 0)
        .leftSpaceToView(self.view, 10)
        .rightSpaceToView(self.view, 10)
        .heightIs(43)
        ;
        [_titleInputField updateLayout];
        
        UIView *sepLine = [UIView new];
        [self.view addSubview:sepLine];
        sepLine.sd_layout
        .topSpaceToView(_titleInputField, 0)
        .leftSpaceToView(self.view, 10)
        .rightSpaceToView(self.view, 10)
        .heightIs(1)
        ;
        [sepLine updateLayout];
        //加虚线
        [UIView drawDashLine:sepLine lineLength:5 lineSpacing:5 lineColor:HexColor(#E3E3E3)];
        
        inputViewController.view.frame = CGRectMake(0, CGRectGetMaxY(sepLine.frame) + 1, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(sepLine.frame) - 1);
    }
    
    
    
    [self addChildViewController:inputViewController];
    
    [self.view addSubview:inputViewController.view];
    
    @weakify(self);
    inputViewController.selectedBlock = ^(NSInteger index) {
        @strongify(self);
        [self processWithIndex:index];
    };
    
    //如果是文章草稿，需要设置已选的频道
    if (self.draftModel&&self.editType==0) {
        [self.selectView setSelectChannels:self.draftModel.channelIds];
    }
    
    //现在使用的这个编辑器有个bug，如果在同一界面有其他可编辑的输入框，并且焦点在另外的输入框上，那么直接给这个第三方的编辑器设置内容，图片会显示不出来，所以需要先把编辑器的内容先加载出来，再设置其他输入框的内容
    if (self.draftModel) {
        _titleInputField.text = self.draftModel.title;
    }
}

//保存或者放弃编辑
-(void)processWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            if (self.isToAudit) {
                LRToast(@"请直接发布");
            }else{
                [self publishActionWithDraft:YES];
            }
        }
            break;
        case 1:
            [self giveUpEditPop];
            break;
        default:
            break;
    }
}

//发布检测
-(void)publishActionWithDraft:(BOOL)yesOrNo
{
    GGLog(@"html:%@",[inputViewController getHTML]);
    GGLog(@"输入了：%@",[inputViewController getText]);
    
    if (kStringIsEmpty(self.channelId)&&self.editType==0){
        LRToast(@"请选择频道");
        return;
    }
    //    else if ([NSString isEmpty:self.wordViewController.textView.titleTextField.text]) {
    //        LRToast(@"请输入标题");
    //        return;
    //    }else if (self.wordViewController.textView.attributedText.length<=0){
    //        LRToast(@"还没编辑内容哟");
    //        return;
    //    }
    //    [self requestPublishArticleWithContent:[self. wordViewController exportHTML]];
    
    else if ([NSString isEmpty:self.titleInputField.text]&&self.editType == 0){
        LRToast(@"请输入标题");
        return;
    }else if ([NSString isEmpty:[inputViewController getText]]||[NSString isEmpty:[inputViewController getHTML]]){
        LRToast(@"还没编辑内容哟");
        return;
    }
    //如果是问答，需要弹框提示填入悬赏积分
    if (self.editType==1) {
        [self popInputIntegralWithDraft:(BOOL)yesOrNo isPaid:NO];
    }else{
        if (self.isPayArticle&&self.editType == 0) {
            PublishArticleViewController *paVC = [PublishArticleViewController new];
            paVC.isPayArticle = YES;
            paVC.editType = 2;
            paVC.channelId = self.channelId;
            paVC.articleTitle = self.titleInputField.text;
            paVC.freeContent = [inputViewController getHTML];
            [self.navigationController pushViewController:paVC animated:YES];
        }else if (self.isPayArticle&&self.editType == 2){
            self.paidContent = [inputViewController getHTML];
            [self popInputIntegralWithDraft:(BOOL)yesOrNo isPaid:YES];
        }else{
          [self requestPublishArticleWithContent:[inputViewController getHTML] isDraft:yesOrNo];
        }
    }
}

//询问用户是否放弃编辑
-(void)giveUpEditPop
{
    UIAlertController *popVC = [UIAlertController alertControllerWithTitle:@"放弃当前编辑?" message:@"当前内容将不会保存" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *giveUp = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [popVC addAction:giveUp];
    [popVC addAction:cancel];
    
    [self presentViewController:popVC animated:YES completion:nil];
}

//弹框输入悬赏(付费)积分
-(void)popInputIntegralWithDraft:(BOOL)yesOrNo isPaid:(BOOL)paid
{
    NSString *title = @"请输入悬赏积分";
    NSString *message = @"不输入默认为不悬赏";
    if (paid) { //付费文章
        title = @"请输入付费积分";
        message = @"付费积分不能为0";
    }
    self.rewardPoint = 0;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"0";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = [alertController.textFields objectAtIndex:0];
        self.rewardPoint = [textField.text integerValue];
        if (paid) {
            if (self.rewardPoint>0) {
                [self requestPublishArticleWithPayPoints:self.rewardPoint];
            }else{
                LRToast(@"付费积分不能为0哦");
            }
        }else{
            [self requestPublishArticleWithContent:[self->inputViewController getHTML] isDraft:yesOrNo];
        }
        
    }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark --- UITextFieldDelegate
//当编辑标题时，无法操作键盘上面的选项
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [inputViewController canTouch:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [inputViewController canTouch:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.titleInputField) {
        return YES;
    }
    if (textField != self.titleInputField) {
        //这里的if是为了获取删除操作,如果没有if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //限制最大输入长度
        else if (textField.text.length >= 5) {
            textField.text = [textField.text substringToIndex:6];
            return NO;
        }
        
    }
    return [self validateNumber:string];
}

//检测是否是纯数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    GGLog(@"点击了 %ld",index);
    self.channelModel = self.channelArr[index];
    [_channelBtn setNormalTitle:self.channelModel.channelName];
}

#pragma make ----- 请求发送
//发布文章或问答(草稿)
-(void)requestPublishArticleWithContent:(NSString *)content isDraft:(BOOL)yesOrNo
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //所属频道需要自己提前保存
    //    parameters[@"title"] = self.wordViewController.textView.titleTextField.text;
    parameters[@"title"] = self.titleInputField.text;
    if (self.editType == 2) {
        parameters[@"title"] = self.articleTitle;
    }
    if (self.editType==1) {
        //问答频道后台可以直接通过newsType来判断
        parameters[@"channelIds"] = @"2";
        parameters[@"newsType"] = @(2);
        parameters[@"rewardPoints"] = @(self.rewardPoint);
    }else{
        parameters[@"channelIds"] = self.channelId;
        parameters[@"newsType"] = @(1);
    }
    parameters[@"isDraft"] = @(yesOrNo);
    parameters[@"content"] = GetSaveString(content);
    //是否从草稿详情页过来的
    if (self.draftModel) {
        //是否已是待审核的文章或问答
        if (self.isToAudit) {
            parameters[@"newsId"] = @(self.draftModel.newsId);
        }else{
            parameters[@"draftId"] = @(self.draftModel.newsId);
        }
    }
    
    [HttpRequest postWithURLString:News_create parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        //退回到文章管理界面
        for (id vc in self.navigationController.viewControllers) {
            //            GGLog(@"类名:%@",NSStringFromClass([vc class]));
            if ([NSStringFromClass([vc class]) isEqualToString:@"PublishPageViewController"]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    } failure:nil RefreshAction:nil];
}

//发布付费文章
-(void)requestPublishArticleWithPayPoints:(NSInteger)points
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"title"] = GetSaveString(self.articleTitle);
    parameters[@"channelIds"] = GetSaveString(self.channelId);
    parameters[@"freeContent"] = GetSaveString(self.freeContent);
    parameters[@"paidContent"] = GetSaveString(self.paidContent);
    parameters[@"payPoints"] = @(points);
    
    [HttpRequest postWithURLString:CreatePaid parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        //退回到文章管理界面
        for (id vc in self.navigationController.viewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:@"PublishPageViewController"]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
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
