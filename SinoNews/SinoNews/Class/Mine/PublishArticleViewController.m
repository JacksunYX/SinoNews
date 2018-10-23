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

//第三版编辑器
#import "WGRichTextEditorVC.h"

//内容编辑页面
#import "PaidEditViewController.h"

@interface PublishArticleViewController ()<YBPopupMenuDelegate,UITextFieldDelegate>
{
    //不可以用作当前控制器的属性，否则会崩溃
    ZSSCustomButtonsViewController *inputViewController;
    
    WGRichTextEditorVC *wgrteFirstVC;
    WGRichTextEditorVC *wgrteSecondVC;
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
    
    self.fd_interactivePopDisabled = YES;
    
    NSString *title = @"发布文章";
    if (self.isPayArticle) {
        title = @"发布付费文章";
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
//    [self setUI2];
    [self setUI3];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
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
//    if (self.isPayArticle&&self.editType!=2) {
//        rightBtn.frame = CGRectMake(0, 0, 60, 40);
//        editBtn.text = @"下一步";
//        editBtn.frame = CGRectMake(0, 0, 60, 25);
//    }
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    editBtn.layer.borderWidth = 1;
//        [rightBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
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
        [channelLabel updateLayout];
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
        //如果是文章草稿，需要设置已选的频道
        if (self.draftModel) {
            [self.selectView setSelectChannels:self.draftModel.channelIds];
        }
        //回调
        @weakify(self);
        self.selectView.selectBlock = ^(NSString *channelIdStr) {
            @strongify(self);
            self.channelId = channelIdStr;
        };
    }
    
    CGFloat topY = 0;
    if (self.editType == 2&&self.isPayArticle) {
        topY = 0;
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
        topY = CGRectGetMaxY(sepLine.frame) + 1;
    }
    
    //添加输入界面
    inputViewController = [[ZSSCustomButtonsViewController alloc]init];
    
    if (self.draftModel) {
        [inputViewController setHTML:self.draftModel.content];
    }
    
    if (self.isPayArticle) {
        inputViewController.hiddenSettingBtn = YES;
    }
    
    [self addChildViewController:inputViewController];
    
    [self.view addSubview:inputViewController.view];
    
    inputViewController.view.frame = CGRectMake(0, topY, self.view.bounds.size.width, self.view.bounds.size.height - topY);
    
    @weakify(self);
    inputViewController.selectedBlock = ^(NSInteger index) {
        @strongify(self);
        [self processWithIndex:index];
    };
    
    //现在使用的这个编辑器有个bug，如果在同一界面有其他可编辑的输入框，并且焦点在另外的输入框上，那么直接给这个第三方的编辑器设置内容，图片会显示不出来，所以需要先把编辑器的内容先加载出来，再设置其他输入框的内容
    if (self.draftModel) {
        _titleInputField.text = self.draftModel.title;
    }
}

-(void)setUI3
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
        [channelLabel updateLayout];
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
        
        //如果是文章草稿，需要设置已选的频道
        if (self.draftModel) {
            [self.selectView setSelectChannels:self.draftModel.channelIds];
        }
        
        //标题
        if (self.isPayArticle) {
            _titleInputField = [TXLimitedTextField new];
            _titleInputField.font = PFFontR(24);
            _titleInputField.placeholder = @"请输入标题";
            _titleInputField.delegate = self;
            [self.view addSubview:_titleInputField];
            _titleInputField.sd_layout
            .topSpaceToView(_channelSelectionView, 0)
            .leftSpaceToView(self.view, 25)
            .rightSpaceToView(self.view, 25)
            .heightIs(70)
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
            self.topViewH = CGRectGetMaxY(sepLine.frame);
        }
    }
    
    wgrteFirstVC = [WGRichTextEditorVC new];
    
    if (self.draftModel) {
        wgrteFirstVC.draftModel = self.draftModel;
    }
    
    if (self.isPayArticle) {
        wgrteFirstVC.hiddenSettingBtn = YES;
        if (self.editType == 2) {
            wgrteFirstVC.hiddenTitle = YES;
        }
        wgrteFirstVC.disableEdit = YES;
        wgrteFirstVC.content = @"免费部分";
    }
    
    [self addChildViewController:wgrteFirstVC];
    
    [self.view addSubview:wgrteFirstVC.view];
    
    if (self.isPayArticle) {
        CGFloat webH = (ScreenH - NAVI_HEIGHT - self.topViewH - BOTTOM_MARGIN - 5)/2;
        wgrteFirstVC.view.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view, self.topViewH)
        .heightIs(webH)
        ;
        wgrteFirstVC.view.tag = 100;
        //添加一个编辑按钮
        [self addEditBtnOnFatherView:wgrteFirstVC.view];
        
        [self addSecondEditorView:webH];
    }else{
        wgrteFirstVC.view.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view, self.topViewH)
        .bottomSpaceToView(self.view, 0)
        ;
    }
    
    @weakify(self);
    wgrteFirstVC.selectedBlock = ^(NSInteger index) {
        @strongify(self);
        [self processWithIndex:index];
    };
    
}

//添加编辑付费部分的试图
-(void)addSecondEditorView:(CGFloat)height
{
    wgrteSecondVC = [WGRichTextEditorVC new];
    
    wgrteSecondVC.hiddenSettingBtn = YES;
    
    wgrteSecondVC.hiddenTitle = YES;
    
    wgrteSecondVC.disableEdit = YES;
    wgrteSecondVC.content = @"付费部分";
    [self addChildViewController:wgrteSecondVC];
    
    [self.view addSubview:wgrteSecondVC.view];
    
    wgrteSecondVC.view.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(height)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    wgrteSecondVC.view.tag = 101;
    //添加一个编辑按钮
    [self addEditBtnOnFatherView:wgrteSecondVC.view];
    
    UIView *sepLine = [UIView new];
    [self.view addSubview:sepLine];
    sepLine.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    .bottomSpaceToView(wgrteSecondVC.view, 2)
    ;
    [sepLine updateLayout];
    //加虚线
    [UIView drawDashLine:sepLine lineLength:5 lineSpacing:5 lineColor:HexColor(#E3E3E3)];
}

//添加编辑按钮
-(void)addEditBtnOnFatherView:(UIView *)fatherView
{
    UIButton *editBtn = [UIButton new];
    [fatherView addSubview:editBtn];
    editBtn.sd_layout
    .bottomSpaceToView(fatherView, 5)
    .rightSpaceToView(fatherView, 20)
    .widthIs(50)
    .heightIs(20)
    ;
    editBtn.sd_cornerRadius = @10;
    [editBtn setNormalTitle:@"编辑"];
    [editBtn setBtnFont:PFFontL(14)];
    editBtn.backgroundColor = HexColor(#1282EE);
    editBtn.tag = fatherView.tag - 100;
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
}

//编辑按钮点击事件
-(void)editClick:(UIButton *)sender
{
    @weakify(self);
    switch (sender.tag) {
        case 0:
        {
            GGLog(@"编辑免费部分");
            PaidEditViewController *peVC = [PaidEditViewController new];
            peVC.type = 0;
            peVC.content = self.freeContent;
            peVC.editBlock = ^(NSString * _Nonnull editContent) {
                @strongify(self);
                self.freeContent = editContent;
                [self->wgrteFirstVC setContent:editContent];
            };
            [self.navigationController pushViewController:peVC animated:YES];
        }
            break;
        case 1:
        {
            GGLog(@"编辑付费部分");
            PaidEditViewController *peVC = [PaidEditViewController new];
            peVC.type = 1;
            peVC.content = self.paidContent;
            peVC.editBlock = ^(NSString * _Nonnull editContent) {
                @strongify(self);
                self.paidContent = editContent;
                [self->wgrteSecondVC setContent:editContent];
            };
            [self.navigationController pushViewController:peVC animated:YES];
        }
            break;
            
        default:
            break;
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
//    GGLog(@"html:%@",[inputViewController getHTML]);
//    GGLog(@"输入了：%@",[inputViewController getText]);
    /*
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
    
    else if (self.editType == 0){
        if (self.isPayArticle) {
            if ([NSString isEmpty:_titleInputField.text]) {
                LRToast(@"请输入标题");
                return;
            }
        }else{
            if ([NSString isEmpty:[wgrteFirstVC getTitle]]) {
                LRToast(@"请输入标题");
                return;
            }
        }
    }else if ([NSString isEmpty:[wgrteFirstVC contentNoH5]]||[NSString isEmpty:[wgrteFirstVC contentH5]]){
        LRToast(@"内容必须有文字哦");
        return;
    }
    */
    
    if (self.editType == 0) {
        //1.先判断频道是否为空
        if (kStringIsEmpty(self.channelId)) {
            LRToast(@"请选择频道");
            return;
        }
        //2.再根据是否收费判断标题
        else if (self.isPayArticle) {
            if ([NSString isEmpty:_titleInputField.text]) {
                LRToast(@"请输入标题");
                return;
            }
            //3.1判断免费部分内容是否为空
            if ([NSString isEmpty:self.freeContent]) {
                LRToast(@"免费内容还未填充内容呢");
                return;
            }
            //3.2判断免费部分内容是否为空
            if ([NSString isEmpty:self.paidContent]){
                LRToast(@"付费内容还未填充内容呢");
                return;
            }
            //3.3发布付费文章
            [self popInputIntegralWithDraft:yesOrNo isPaid:YES];
        }else{
            if ([NSString isEmpty:[wgrteFirstVC getTitle]]) {
                LRToast(@"请输入标题");
                return;
            }
            //3.4判断内容是否为空
            if ([NSString isEmpty:[wgrteFirstVC contentH5]]||[NSString isEmpty:[wgrteFirstVC contentNoH5]]) {
                LRToast(@"内容必须要有文字哦");
                return;
            }
            [self requestPublishArticleWithContent:[wgrteFirstVC contentH5] isDraft:yesOrNo];
        }
        
    }else
    //如果是问答，需要弹框提示填入悬赏积分
    if (self.editType==1) {
        [self popInputIntegralWithDraft:(BOOL)yesOrNo isPaid:NO];
    }
    /*
    else{
        if (self.isPayArticle&&self.editType == 0) {
            PublishArticleViewController *paVC = [PublishArticleViewController new];
            paVC.isPayArticle = YES;
            paVC.editType = 2;
            paVC.channelId = self.channelId;
            paVC.articleTitle = [wgrteFirstVC getTitle];
            paVC.freeContent = [wgrteFirstVC contentH5];
            [self.navigationController pushViewController:paVC animated:YES];
        }else if (self.isPayArticle&&self.editType == 2){
            self.paidContent = [wgrteFirstVC contentH5];
            [self popInputIntegralWithDraft:(BOOL)yesOrNo isPaid:YES];
        }else{
          [self requestPublishArticleWithContent:[wgrteFirstVC contentH5] isDraft:yesOrNo];
        }
    }
     */
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
            [self requestPublishArticleWithContent:[self->wgrteFirstVC contentH5] isDraft:yesOrNo];
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
            textField.text = [textField.text substringToIndex:5];
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
    parameters[@"title"] = [wgrteFirstVC getTitle];
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
        if (yesOrNo) {
            LRToast(@"草稿已保存");
        }else{
            LRToast(@"发布成功");
        }
        GCDAfterTime(1, ^{
            //退回到文章管理界面
            for (id vc in self.navigationController.viewControllers) {
                //            GGLog(@"类名:%@",NSStringFromClass([vc class]));
                if ([NSStringFromClass([vc class]) isEqualToString:@"PublishPageViewController"]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        });
        
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
        LRToast(@"发布成功");
        GCDAfterTime(1, ^{
            for (id vc in self.navigationController.viewControllers) {
                if ([NSStringFromClass([vc class]) isEqualToString:@"PublishPageViewController"]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        });
        
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
