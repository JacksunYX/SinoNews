//
//  ToReportTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/12/10.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ToReportTableViewCell.h"

NSString * const ToReportTableViewCellID = @"ToReportTableViewCellID";

@implementation ToReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (!self.editing) return;
    //替换编辑模式下cell左边的图片
    if (self.isEditing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //这里自定义了cell 就改变自定义控件的颜色
        //        self.textLabel.backgroundColor = [UIColor clearColor];
        UIControl *control = [self.subviews lastObject];
        UIImageView * imgView = [[control subviews] objectAtIndex:0];
        if (self.isSelected) {
            imgView.image = [UIImage imageNamed:@"collect_selected"];
        }else{
            imgView.image = [UIImage imageNamed:@"collect_unSelected"];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *selectView = [UIView new];
        selectView.backgroundColor = ClearColor;
        self.selectedBackgroundView = selectView;
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{
    
    
}

@end
