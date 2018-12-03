//
//  VoteDetailChooseTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VoteDetailChooseTableViewCell.h"

NSString * const VoteDetailChooseTableViewCellID = @"VoteDetailChooseTableViewCellID";

@interface VoteDetailChooseTableViewCell ()
{
    UIButton *selectBtn;
    UILabel *content;
    UILabel *pollLabel; //票数、百分比显示
    UIView *pollDownView;   //展示票数比例下层视图
    UIView *pollFrontView;  //展示票数比例上层视图
}
@end

@implementation VoteDetailChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    selectBtn = [UIButton new];
    content = [UILabel new];
    pollLabel = [UILabel new];
    pollDownView = [UIView new];
    pollFrontView = [UIView new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 content,
                                 selectBtn,
                                 pollLabel,
                                 pollDownView,
                                 
                                 ]];
    content.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 20)
    .rightSpaceToView(fatherView, 20)
    .autoHeightRatio(0)
    ;
    content.font = PFFontL(16);
    
    selectBtn.sd_layout
    .bottomSpaceToView(content, -22)
    .leftSpaceToView(fatherView, 18)
    .widthIs(20)
    .heightIs(20)
    ;
    [selectBtn setNormalImage:UIImageNamed(@"remindRead_noSelect")];
    [selectBtn setSelectedImage:UIImageNamed(@"remindRead_selected")];
    
    pollLabel.sd_layout
    .leftEqualToView(content)
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(content, 10)
    .heightIs(16)
    ;
    pollLabel.font = PFFontL(12);
    pollLabel.textColor = HexColor(#74777F);
    
    
    pollDownView.sd_layout
    .topSpaceToView(pollLabel, 10)
    .leftEqualToView(selectBtn)
    .rightSpaceToView(fatherView, 20)
    .heightIs(20)
    ;
    pollDownView.sd_cornerRadius = @10;
    pollDownView.backgroundColor = HexColor(#F1F1F1);
    
    [pollDownView addSubview:pollFrontView];
    pollFrontView.sd_layout
    .leftEqualToView(pollDownView)
    .topEqualToView(pollDownView)
    .bottomEqualToView(pollDownView)
    .widthRatioToView(pollDownView, 0)
    ;
    pollFrontView.sd_cornerRadius = @10;
    pollFrontView.backgroundColor = HexColor(#1282EE);
    
    [self setupAutoHeightWithBottomView:pollDownView bottomMargin:10];
}

-(void)setModel:(VoteChooseInputModel *)model
{
    _model = model;
    selectBtn.selected = model.isSelected;
    
    selectBtn.hidden = model.hiddenSelectIcon;
    pollFrontView.hidden = model.hiddenVoteResult;
    if (model.hiddenVoteResult) {
        pollLabel.text = @"发布者未开放投票数据";
    }else{
        CGFloat percentage = 0.0;
        if (model.totalPolls) {
            percentage = (float)model.havePolls/model.totalPolls;
            pollLabel.text = [NSString stringWithFormat:@"%ld票(%.2lf%%)",model.havePolls,percentage*100];
        }else{
           pollLabel.text = [NSString stringWithFormat:@"%ld票",model.havePolls];
        }
        pollFrontView.sd_layout
        .widthRatioToView(pollDownView, percentage);
        ;
        [pollFrontView updateLayout];
    }
    
    NSString *contentString;
    if (model.hiddenSelectIcon) {
        contentString = @"";
    }else{
        contentString = @"     ";
    }
    content.text = [NSString stringWithFormat:@"%@%ld.%@",contentString,self.tag+1,GetSaveString(model.content)];
    
}

@end
