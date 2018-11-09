//
//  VotePostingTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/9.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VotePostingTableViewCell.h"

NSString * const VotePostingTableViewCellID = @"VotePostingTableViewCellID";

@interface VotePostingTableViewCell ()<UITextFieldDelegate>
{
    UILabel *sortLabel;
    JHTextField *content;
    UIButton *deleteBtn;
}
@end

@implementation VotePostingTableViewCell

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
    sortLabel = [UILabel new];
    sortLabel.font = PFFontL(14);
    sortLabel.textColor = HexColor(#161A24);
    sortLabel.textAlignment = NSTextAlignmentCenter;
    
    content = [JHTextField new];
    content.font = PFFontL(15);
    content.textColor = HexColor(#161A24);
    content.limitLength = 100;
    //占位文字属性
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = HexColor(#ACB5B9);
    attributes[NSFontAttributeName] = PFFontL(15);
    content.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入投票选项" attributes:attributes];
    
    
    deleteBtn = [UIButton new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 sortLabel,
                                 deleteBtn,
                                 content,
                                 ]];
    
    sortLabel.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(20)
    .heightEqualToWidth()
    ;
    sortLabel.sd_cornerRadius = @10;
    sortLabel.layer.borderColor = HexColor(#95A1A5).CGColor;
    sortLabel.layer.borderWidth = 1;
    
    deleteBtn.sd_layout
    .rightSpaceToView(fatherView, 15)
    .centerYEqualToView(fatherView)
    .widthIs(15)
    .heightEqualToWidth()
    ;
    [deleteBtn setNormalImage:UIImageNamed(@"voteDelete_icon")];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    content.sd_layout
    .topSpaceToView(fatherView, 18)
    .leftSpaceToView(sortLabel, 16)
    .rightSpaceToView(deleteBtn, 16)
    .heightIs(20)
    ;
    
    @weakify(self);
    content.textFieldTextEditingChangedBlock = ^(UITextField *textField) {
        @strongify(self);
        if (self.inputBlock) {
            self.inputBlock(textField.text);
        }
    };
    
    [self setupAutoHeightWithBottomView:content bottomMargin:18];
    
}

-(void)deleteAction:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

-(void)setSortNum:(NSInteger)num
{
    sortLabel.text = [NSString stringWithFormat:@"%ld",num];
}

-(void)setContent:(NSString *)contentString
{
    content.text = contentString;
}

@end
