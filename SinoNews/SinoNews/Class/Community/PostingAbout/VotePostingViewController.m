//
//  VotePostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VotePostingViewController.h"
#import "SelectPublishChannelViewController.h"
#import "ForumViewController.h"

#import "VotePostingTableViewCell.h"
#import "VotePostingTableViewCell2.h"

#import "VoteChooseInputModel.h"

@interface VotePostingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EmotionKeyBoardDelegate,YYTextViewDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *publishBtn;

@property (nonatomic,strong) NSMutableArray *chooseArr;
@property (nonatomic,strong) NSString *asmuchSelect;//最多选择
@property (nonatomic,strong) NSString *validTime;   //有效期
@property (nonatomic,assign) BOOL isVisible;    //是否可见

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) YYTextView *titleView;
@property (nonatomic,strong) YXTextView *contentView;
@property (nonatomic,strong) UIButton *footView;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *emojiKeyboard;
//emoji键盘
@property (nonatomic,strong) WTEmoticonInputView *emoticonInputView;
//保存数据的模型
@property (nonatomic,strong) SeniorPostDataModel *voteModel;
@end

//可添加投票选项的最小、最大数
static NSInteger limitMinNum = 2;
static NSInteger limitMaxNum = 20;
@implementation VotePostingViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 183)];
        
        _titleView = [YYTextView new];
        _titleView.backgroundColor = WhiteColor;
        _titleView.font = PFFontR(20);
        _titleView.textColor = BlackColor;
        _titleView.delegate = self;
        _titleView.inputAccessoryView = self.bottomView;
        
        _contentView = [YXTextView new];
        _contentView.backgroundColor = WhiteColor;
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
        .heightIs(69)
        ;
        
        _titleView.placeholderText = @"起个引人关注的标题哦～";
        _titleView.placeholderTextColor = HexColor(#BAC3C7);
        _titleView.placeholderFont = PFFontR(20);
        
        _contentView.sd_layout
        .topSpaceToView(_titleView, 0)
        .leftEqualToView(_headView)
        .rightEqualToView(_headView)
        .bottomEqualToView(_headView)
        ;
        _contentView.placeholderText = @"填写投票描述，详细的描述会让更多的启世录用户参与投票哦～";
        _contentView.placeholderTextColor = HexColor(#B9C3C7);
        _contentView.placeholderFont = PFFontL(15);
        
        _contentView.layer.borderColor = HexColor(#E3E3E3).CGColor;
        _contentView.layer.borderWidth = 1;
    }
    return _headView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _bottomView.backgroundColor = WhiteColor;
        
        _emojiKeyboard = [UIButton new];
        _showKeyboard = [UIButton new];
        [_bottomView sd_addSubviews:@[
                                      _emojiKeyboard,
                                      _showKeyboard,
                                      ]];
        
        _emojiKeyboard.sd_layout
        .leftSpaceToView(_bottomView, 15)
        .topSpaceToView(_bottomView, 14)
        .widthIs(23)
        .heightEqualToWidth()
        ;
        [_emojiKeyboard setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
        [_emojiKeyboard setSelectedImage:UIImageNamed(@"systemKeyboard_icon")];
        [_emojiKeyboard addTarget:self action:@selector(changeKeyboardType) forControlEvents:UIControlEventTouchUpInside];
        
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

-(WTEmoticonInputView *)emoticonInputView
{
    if (!_emoticonInputView) {
        _emoticonInputView = [[WTEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kKeyBoardH)];
        _emoticonInputView.delegate = self;
    }
    return _emoticonInputView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(NSMutableArray *)chooseArr
{
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray new];
        
        for (int i = 0; i < limitMinNum; i ++) {
            VoteChooseInputModel *chooseModel = [VoteChooseInputModel new];
            chooseModel.content = @"";
            [_chooseArr addObject:chooseModel];
        }
    }
    return _chooseArr;
}

-(SeniorPostDataModel *)voteModel
{
    if (!_voteModel) {
        _voteModel = [SeniorPostDataModel new];
        _voteModel.postType = 2;
    }
    return _voteModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    _asmuchSelect = @"1项";
    _validTime = @"7天";
    [self setUI];
    
    //键盘监听
    @weakify(self);
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
    
//    [_titleView becomeFirstResponder];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"新投票";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#1282EE)];
    
    [_publishBtn setBtnFont:PFFontL(14)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)back
{
    //需要判断选项是否没有内容
    BOOL chooseContent = NO;
    for (VoteChooseInputModel *model in self.chooseArr) {
        if (![NSString isEmpty:model.content]) {
            chooseContent = YES;
            break;
        }
    }
    if ([self.voteModel isContentNeutrality]||chooseContent) {
        @weakify(self);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"不发表将不会保存您当前输入的内容哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"不发了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:confirm];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//发表
-(void)publishAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([NSString isEmpty:self.voteModel.postTitle]) {
        LRToast(@"标题不能为空哦");
        return;
    }else if ([NSString isEmpty:self.voteModel.postContent]) {
        LRToast(@"投票描述不能为空哦");
        return;
    }
    
    //需要判断选项是否没有内容
    for (VoteChooseInputModel *model in self.chooseArr) {
        if ([NSString isEmpty:model.content]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"有未输入内容的投票选项" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:confirm];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    }
//    SelectPublishChannelViewController *spcVC = [SelectPublishChannelViewController new];
//    [self.navigationController pushViewController:spcVC animated:YES];
    for (VoteChooseInputModel *model in self.chooseArr) {
        model.hiddenVoteResult = !self.isVisible;
        if (model.isSelected) {
            model.isSelected = NO;
        }else{
            continue;
        }
    }
    self.voteModel.voteSelects = self.chooseArr;
    self.voteModel.choosableNum = [_asmuchSelect substringToIndex:1].integerValue;
    self.voteModel.validityDate = [_validTime substringToIndex:1].integerValue;
    self.voteModel.visibleAfterVote = _isVisible;
    
    ForumViewController *fVC = [ForumViewController new];
    fVC.postModel = self.voteModel;
    [self.navigationController pushViewController:fVC animated:YES];
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
    .bottomSpaceToView(self.view, 0)
    ;
    [_tableView updateLayout];
    _tableView.tableHeaderView = self.headView;
    [_tableView registerClass:[VotePostingTableViewCell class] forCellReuseIdentifier:VotePostingTableViewCellID];
    [_tableView registerClass:[VotePostingTableViewCell2 class] forCellReuseIdentifier:VotePostingTableViewCell2ID];
}

//弹框提示
-(void)popNotice:(BOOL)max
{
    NSString *noticeString = [NSString stringWithFormat:@"投票项不能少于%ld个",limitMinNum];
    if (max) {
        noticeString = [NSString stringWithFormat:@"投票项不能超过%ld个",limitMaxNum];
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:noticeString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//添加投票选项
-(void)addChooseAction:(UIButton *)sender
{
    //添加的选项不能超过最大限制
    if (self.chooseArr.count>=limitMaxNum) {
        [self popNotice:YES];
    }else{
        VoteChooseInputModel *chooseModel = [VoteChooseInputModel new];
        chooseModel.content = @"";
        [self.chooseArr addObject:chooseModel];
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }
}

//隐藏键盘
-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

//切换键盘
-(void)changeKeyboardType
{
    _emojiKeyboard.selected = !_emojiKeyboard.selected;
    if (_emojiKeyboard.selected) {
        self.contentView.inputView = self.emoticonInputView;
    }else{
        self.contentView.inputView = nil;
    }
    [self.contentView reloadInputViews];
}

#pragma mark --- EmotionKeyBoardDelegate ---
- (void)clickEmotionName:(NSString *)name
{
    NSString *emotionString = [[WTUtils getEmoticonData] allKeysForObject:name][0];
    YXTextView *textView = self.contentView;
    
    [textView replaceRange:textView.selectedTextRange withText:emotionString];
}

- (void)clickDelete
{
    YXTextView *textView = self.contentView;
    [textView deleteBackward];
}

#pragma mark --- YYTextViewDelegate ---
-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //禁止标题输入换行
    if (textView == _titleView&&[text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(YYTextView *)textView
{
    if (textView == _titleView) {
        if (textView.text.length>25) {
            LRToast(@"标题长度不可超过25个字符哦");
            textView.text = [textView.text substringToIndex:25];
        }
        self.voteModel.postTitle = [textView.text removeSpace];
    }else if (textView == _contentView){
        self.voteModel.postContent = [textView.text removeSpace];
    }
}

-(void)textViewDidBeginEditing:(YYTextView *)textView
{
    GGLog(@"已经开始编辑");
    if (textView != _contentView) {
        _emojiKeyboard.hidden = YES;
    }else{
        _emojiKeyboard.hidden = NO;
    }
}

-(void)textViewDidEndEditing:(YYTextView *)textView
{
    GGLog(@"已经结束编辑");
    self.emojiKeyboard.selected = NO;
    textView.inputView = nil;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.chooseArr.count;
    }else if (section == 1){
        return 3;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    @weakify(self);
    if (indexPath.section == 0) {
        VotePostingTableViewCell *cell0 = (VotePostingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VotePostingTableViewCellID];
         VoteChooseInputModel *chooseModel = self.chooseArr[indexPath.row];
        [cell0 setContent:chooseModel.content];
        [cell0 setSortNum:indexPath.row+1];
        
        cell0.deleteBlock = ^{
            @strongify(self);
            GGLog(@"移除下标:%ld",indexPath.row);
            if (self.chooseArr.count>limitMinNum) {
                [self.chooseArr removeObjectAtIndex:indexPath.row];
                [tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
                //比较是否当前选项数量已少于用户之前选的最大可选数
                NSMutableString *num = self.asmuchSelect.mutableCopy;
                [num deleteCharactersInRange:NSMakeRange(1, 1)];
                if (self.chooseArr.count<[num integerValue]) {
                    self.asmuchSelect = [NSString stringWithFormat:@"%ld项",self.chooseArr.count];
                    [tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                [self popNotice:NO];
            }
        };
        cell0.inputBlock = ^(NSString * _Nonnull inputString) {
            chooseModel.content = inputString;
        };
        cell0.beginInputBlock = ^(UIView * _Nonnull inputView) {
            @strongify(self);
            if (inputView != self.contentView) {
                self.emojiKeyboard.hidden = YES;
            }
        };
        cell0.inputAccessoryView = self.bottomView;
        cell = cell0;
    }else if (indexPath.section == 1) {
        VotePostingTableViewCell2 *cell1 = (VotePostingTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:VotePostingTableViewCell2ID];
        if (indexPath.row == 2) {
            cell1.type = 1;
            
            cell1.switchBlock = ^(BOOL switchisOn) {
                @strongify(self);
                self.isVisible = switchisOn;
                
                GGLog(@"开关状态:%d",switchisOn);
            };
        }else{
            cell1.type = 0;
        }
        switch (indexPath.row) {
                case 0:{
                    [cell1 setRightTitle:self.asmuchSelect];
                    [cell1 setLeftTitle:@"最多可选"];
                }
                break;
                
                case 1:{
                    [cell1 setRightTitle:self.validTime];
                    [cell1 setLeftTitle:@"投票有效期"];
                }
                break;
                
                case 2:{
                    [cell1 setRightSwitchOn:self.isVisible];
                    [cell1 setLeftTitle:@"投票后结果可见"];
                }
                break;
                
            default:
                break;
        }
        cell = cell1;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 43;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        if (!_footView) {
            _footView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 43)];
            _footView.backgroundColor = WhiteColor;
            [_footView setBtnFont:PFFontL(14)];
            [_footView setNormalTitleColor:HexColor(#1282EE)];
            [_footView setNormalTitle:@"请输入投票选项"];
            [_footView setNormalImage:UIImageNamed(@"voteAdd_icon")];
            _footView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            _footView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [_footView addTarget:self action:@selector(addChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        footView = _footView;
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    if (indexPath.section == 1) {
        LZPickerView *pickerView = [LZPickerView new];
        switch (indexPath.row) {
                case 0:{
                    [pickerView lzPickerVIewType:LZPickerViewTypeSexAndHeight];
                    NSMutableArray *arr = [NSMutableArray new];
                    for (int i = 0; i < self.chooseArr.count; i++) {
                        NSString *option = [NSString stringWithFormat:@"%d项",i+1];
                        [arr addObject:option];
                    }
                    pickerView.dataSource = arr;
                    pickerView.titleText = @"投票最多可选数";
                    pickerView.selectDefault = self.asmuchSelect;
                    
                    pickerView.selectValue  = ^(NSString *value){
                        @strongify(self);
                        self.asmuchSelect = value;
                        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [pickerView show];
                }
                break;
                case 1:{
                    [pickerView lzPickerVIewType:LZPickerViewTypeSexAndHeight];
                    
                    pickerView.dataSource = @[
                                              @"7天",
                                              @"14天",
                                              @"30天",
                                              @"60天",
                                              @"90天",
                                              @"180天",
                                              @"360天",
                                              
                                              ];
                    pickerView.titleText = @"投票有效期";
                    pickerView.selectDefault = self.validTime;
                    
                    pickerView.selectValue  = ^(NSString *value){
                        @strongify(self);
                        self.validTime = value;
                        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [pickerView show];
                }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
