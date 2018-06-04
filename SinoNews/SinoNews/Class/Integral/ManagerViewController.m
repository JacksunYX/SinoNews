//
//  ManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerViewController.h"
#import "LXSegmentBtnView.h"

@interface ManagerViewController ()
{
    UIImageView *userIcon;  //头像
    UILabel     *userName;  //昵称
    UILabel     *integer;   //积分
}

@property (nonatomic,strong) LXSegmentBtnView *segmentView;
@property (nonatomic,strong) CAGradientLayer *gradient;

@end

@implementation ManagerViewController

- (CAGradientLayer *)gradient
{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)RGBA(79, 160, 238, 1).CGColor,
                           (id)RGBA(173, 208, 241, 1).CGColor, nil];
        _gradient.startPoint = CGPointMake(0, 0.5);
        _gradient.endPoint = CGPointMake(1, 0.5);
        _gradient.locations = @[@0.0, @1];
    }
    return _gradient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理";
    self.view.backgroundColor = WhiteColor;
    
    [self setupTopViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//上部分
-(void)setupTopViews
{
    userIcon = [UIImageView new];
    userName = [UILabel new];
    userName.font = FontScale(15);
    integer = [UILabel new];
    integer.font = FontScale(15);
    UIView *line = [UIView new];
    
    [self.view sd_addSubviews:@[
                                      userIcon,
                                      userName,
                                      integer,
                                      line,
                                      ]];
    userIcon.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10)
    .widthIs(44)
    .heightEqualToWidth()
    ;
    [userIcon setSd_cornerRadius:@22];
    userIcon.image = UIImageNamed(@"userIcon");
    
    userName.sd_layout
    .leftSpaceToView(userIcon, 7)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(15))
    ;
    [userName setSingleLineAutoResizeWithMaxWidth:150];
    userName.text = @"春风十里不如你";
    
    integer.sd_layout
    .rightSpaceToView(self.view, 10)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(14))
    ;
    [integer setSingleLineAutoResizeWithMaxWidth:150];
    integer.text = @"1000000积分";
    
    _segmentView = [LXSegmentBtnView new];
    [self.view addSubview:_segmentView];
    
    _segmentView.sd_layout
    .topSpaceToView(userIcon, 17)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(45)
    ;
    
    [_segmentView updateLayout];
    _segmentView.btnTitleSelectColor = RGBA(18, 130, 238, 1);
    _segmentView.btnTitleNormalColor = RGBA(136, 136, 136, 1);
    WeakSelf
    _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
        [weakSelf setColorWithBtn:btn];
    };
    
    _segmentView.btnTitleArray = @[
                                   @"积分记录",
                                   @"游戏记录",
                                   @"兑换记录",
                                   ];
    
}

-(void)setColorWithBtn:(UIButton *)btn
{
    self.gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
    [btn.layer insertSublayer:self.gradient below:btn.titleLabel.layer];
}









@end
