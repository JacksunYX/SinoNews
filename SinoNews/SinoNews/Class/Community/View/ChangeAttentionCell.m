//
//  ChangeAttentionCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ChangeAttentionCell.h"

NSString *const ChangeAttentionCellID = @"ChangeAttentionCellID";

@interface ChangeAttentionCell ()
{
    UIImageView *logo;
    UIImageView *selectedImage;
    UILabel *name;
}
@end

@implementation ChangeAttentionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUI];
        
    }
    return self;
}


-(void)setUI
{
    logo = [UIImageView new];
    
    selectedImage = [UIImageView new];
//    selectedImage.backgroundColor = HexColor(#1282ee);
//    selectedImage.contentMode = 4;
    
    name = [UILabel new];
    name.textAlignment = NSTextAlignmentCenter;
    name.font = PFFontL(12);
    name.textColor = HexColor(#465867);
    
    [self.contentView sd_addSubviews:@[
                                       logo,
                                       name,
                                       ]];
    logo.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 0)
    .widthIs(41)
    .heightEqualToWidth()
    ;
    [logo updateLayout];
    logo.sd_cornerRadius = @(logo.width/2);
    logo.layer.borderColor = HexColor(#CED3D8).CGColor;
    logo.layer.borderWidth = 1.0f;
    
    name.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(logo, 10)
    .heightIs(14)
    ;
    name.text = @"测试标题";
    
    [logo addSubview:selectedImage];
    selectedImage.sd_layout
    .bottomEqualToView(logo)
    .centerYEqualToView(logo)
//    .widthRatioToView(logo, 1)
//    .heightRatioToView(logo, 0.5)
    .widthIs(39)
    .heightIs(13.5)
    ;
    [selectedImage updateLayout];
    selectedImage.image = UIImageNamed(@"section_selected");
//    [selectedImage cornerWithRadius:selectedImage.height/2 direction:CornerDirectionTypeBottom];
    selectedImage.hidden = YES;
}

-(void)setData:(NSDictionary *)model
{
    logo.image = UIImageNamed(model[@"logo"]);
    name.text = model[@"name"];
    if ([model[@"attention"] integerValue]) {
        selectedImage.hidden = NO;
    }else{
        selectedImage.hidden = YES;
    }
}




@end
