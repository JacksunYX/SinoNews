//
//  SeniorPostingAddContentCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddContentCell.h"

NSString * const SeniorPostingAddContentCellID = @"SeniorPostingAddContentCellID";
@interface SeniorPostingAddContentCell ()
{
    FSTextView *content;
    //排序视图
    UIView *sortBackView;
    UIImageView *goUpTouch;
    UIImageView *goDownTouch;
    UIImageView *deleteTouch;
}
@end

@implementation SeniorPostingAddContentCell

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
        [self addSortView];
    }
    return self;
}

-(void)setUI
{
    content = [FSTextView textView];
    [self.contentView addSubview:content];
    content.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(200)
    ;
    content.textColor = HexColor(#161A24);
    content.font = PFFontR(15);
    content.userInteractionEnabled = NO;
    
    [self setupAutoHeightWithBottomView:content bottomMargin:20];
}

//添加排序视图
-(void)addSortView
{
    sortBackView = [UIView new];
    [self.contentView addSubview:sortBackView];
    sortBackView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    //添加上升、删除、下降
    goUpTouch = UIImageView.new;
    goDownTouch = UIImageView.new;
    deleteTouch = UIImageView.new;
    
    [sortBackView sd_addSubviews:@[
                                   deleteTouch,
                                   goUpTouch,
                                   goDownTouch,
                                   ]];
    deleteTouch.sd_layout
    .centerXEqualToView(sortBackView)
    .centerYEqualToView(sortBackView)
    .widthIs(42)
    .heightEqualToWidth()
    ;
    deleteTouch.image = UIImageNamed(@"sortContent_delete");
    
    goUpTouch.sd_layout
    .centerYEqualToView(deleteTouch)
    .rightSpaceToView(deleteTouch, 40)
    .widthRatioToView(deleteTouch, 1)
    .heightEqualToWidth()
    ;
    goUpTouch.image = UIImageNamed(@"sortContent_up");
    
    goDownTouch.sd_layout
    .centerYEqualToView(deleteTouch)
    .leftSpaceToView(deleteTouch, 40)
    .widthRatioToView(deleteTouch, 1)
    .heightEqualToWidth()
    ;
    goDownTouch.image = UIImageNamed(@"sortContent_down");
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    sortBackView.hidden = !model.isSort;
    if (model.isSort) {
        @weakify(self);
        [sortBackView whenTap:^{
            
        }];
        //排序操作
        [deleteTouch whenTap:^{
            @strongify(self);
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }];
        [goUpTouch whenTap:^{
            @strongify(self);
            if (self.goUpBlock) {
                self.goUpBlock();
            }
        }];
        [goDownTouch whenTap:^{
            @strongify(self);
            if (self.goDownBlock) {
                self.goDownBlock();
            }
        }];
        
    }else{
        sortBackView.gestureRecognizers = nil;
        deleteTouch.gestureRecognizers = nil;
        goUpTouch.gestureRecognizers = nil;
        goDownTouch.gestureRecognizers = nil;
    }
    
    content.text = GetSaveString(model.content);
}

@end
