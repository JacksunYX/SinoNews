//
//  ChannelSelectView.m
//  SinoNews
//
//  Created by Michael on 2018/8/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ChannelSelectView.h"
#import "XLChannelModel.h"

@interface ChannelSelectView ()
@property (nonatomic,strong) NSMutableArray *channelArr;
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableArray *btnArr;    //保存按钮
@end

static NSInteger maxSelect = 3; //最大选择数
@implementation ChannelSelectView
-(NSMutableArray *)selectedArr
{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray new];
    }
    return _selectedArr;
}

-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray new];
    }
    return _btnArr;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

//根据传递过来的数组构建视图
-(void)setViewWithChannelArr:(NSMutableArray *)channelArr
{
    self.channelArr = [channelArr mutableCopy];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    scrollView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    ;
    [scrollView updateLayout];
    
    UIView *lastView = scrollView;
    int i = 0;
    for (XLChannelModel *model in channelArr) {
        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setBtnFont:PFFontL(14)];
        [btn setNormalTitleColor:HexColor(#989898)];
        [btn setSelectedTitleColor:HexColor(#1282EE)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HexColor(#E3E3E3).CGColor;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(lastView, 10)
        .centerYEqualToView(scrollView)
        .heightIs(22)
        .widthIs(44)
        ;
        [btn setNormalTitle:GetSaveString(model.channelName)];
        [self.btnArr addObject:btn];
        lastView = btn;
        i ++;
    }
    [scrollView setupAutoContentSizeWithRightView:lastView rightMargin:10];
}

//按钮点击方法
-(void)click:(UIButton *)btn
{
    //先检查是否在已选数组中存在
    XLChannelModel *model = self.channelArr[btn.tag];
    if ([self.selectedArr containsObject:model]) {
        //已选
        
    }else if (self.selectedArr.count>=maxSelect) {
        LRToast(@"至多只能选择2个频道发布哦");
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.selectedArr addObject:model];
        btn.layer.borderColor = HexColor(#1282EE).CGColor;
    }else{
        [self.selectedArr removeObject:model];
        btn.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }
    if (self.selectBlock) {
        //拼接下当前id字符串
        NSMutableString *idStr = [@"" mutableCopy];

        for (int i = 0; i < self.selectedArr.count; i++) {
            XLChannelModel *model = self.selectedArr[i];
            [idStr appendFormat:@"%@,",model.channelId];
            if (i == self.selectedArr.count-1) {
                //删掉最后一个','
                [idStr deleteCharactersInRange:NSMakeRange(idStr.length-1, 1)];
            }
        }
        self.selectBlock(idStr);
    }
}

//设置已选频道
-(void)setSelectChannels:(NSArray *)channels
{
    if (!channels.count) {
        return;
    }
    for (NSString *channelId in channels) {
        for (int i = 0; i < self.channelArr.count; i ++) {
            XLChannelModel *model = self.channelArr[i];
            if ([channelId integerValue] == [model.channelId integerValue]) {
                //找出对应的按钮，调用方法
                UIButton *btn = self.btnArr[i];
                [self click:btn];
                GGLog(@"已选频道:%@",model.channelName);
                break;
            }
        }
    }
}


@end
