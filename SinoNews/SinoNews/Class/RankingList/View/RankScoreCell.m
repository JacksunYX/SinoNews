//
//  RankScoreCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/17.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankScoreCell.h"
#import "RankingModel.h"

@interface RankScoreCell ()
@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;
@end

@implementation RankScoreCell

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
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    
    CGFloat chartViewWidth  = ScreenW;
    CGFloat chartViewHeight = 220;
    self.aaChartView = [[AAChartView alloc]init];
    self.aaChartView.frame = CGRectMake((ScreenW - chartViewWidth)/2, 0, chartViewWidth, chartViewHeight);
    //    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    //    设置aaChartVie 的内容高度(content height)
    //    self.aaChartView.contentHeight = chartViewHeight*2;
    //    设置aaChartVie 的内容宽度(content  width)
    //    self.aaChartView.contentWidth = chartViewWidth*2;
    [self.contentView addSubview:self.aaChartView];
    
    
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    GCDAfterTime(1.2, ^{
        [self addDashCircle];
    });
    
}

-(void)addDashCircle
{
    //画个虚线圆
    CAShapeLayer *line =  [CAShapeLayer layer];
    CGMutablePathRef   path =  CGPathCreateMutable();
    line.lineWidth = 1.0f ;
    line.strokeColor = HexColor(#B2C5FA).CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.lineDashPhase = 1.0f;
    //设置虚线线宽，线间距
    [line setLineDashPattern:@[@3, @1]];
    CGFloat diameter = 44;
//        CGPathAddEllipseInRect(path, nil, CGRectMake((ScreenW - diameter)/2, (220-diameter)/2 - 15, diameter, diameter));
    CGPathAddEllipseInRect(path, nil, CGRectMake(self.aaChartView.centerX - diameter/2, self.aaChartView.centerY - diameter/5 * 4, diameter, diameter));
    line.path = path;
    CGPathRelease(path);

    [self.contentView.layer insertSublayer:line below:self.aaChartView.layer];
    //    [self.contentView.layer addSublayer:line];
}

-(void)setModelArr:(NSArray *)modelArr
{
    NSInteger maxNum = 10;
    NSArray *dataArr = [RankingModel mj_objectArrayWithKeyValuesArray:modelArr];
    NSMutableArray *categories = [NSMutableArray new];
    NSMutableArray *data = [NSMutableArray new];
    NSMutableArray *backdata = [NSMutableArray new];
    for (RankingModel *model in dataArr) {
        //分类
        NSString *categoryStr = [GetSaveString(model.rankingName) stringByAppendingString:[NSString stringWithFormat:@" %ld  分",model.score]];
        [categories addObject:categoryStr];
        
        //分数
        [data addObject:@(model.score)];
        [backdata addObject:@(maxNum)];
    }
    
    //mark样式
    AAMarker *aaMarker = AAObject(AAMarker)
    .radiusSet(@1)//曲线连接点半径，默认是4
    .symbolSet(AAChartSymbolTypeCircle)
    ;
    
    //构造参数
    self.aaChartModel = AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeArea)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .polarSet(true)
    .symbolStyleSet(AAChartSymbolStyleTypeInnerBlank) //设置折线连接点样式为:内部白色
    //    .gradientColorEnabledSet(true) //启用渐变色
    .animationTypeSet(AAChartAnimationEaseOutQuart) //图形的渲染动画为 EaseOutQuart 动画
    .xAxisCrosshairColorSet(@"#FFE4C4") //(浓汤)乳脂,番茄色准星线
    .xAxisCrosshairDashStyleTypeSet(AALineDashSyleTypeLongDashDot)
    .xAxisCrosshairWidthSet(@0.9)
    //    .yAxisGridLineWidthSet(@0)//y轴横向分割线宽度为0(即是隐藏分割线)
    //    .yAxisTickIntervalSet(@33)   //y分割的间距
    .yAxisLineWidthSet(@0)      //x轴轴线线宽为0即是隐藏Y轴轴线
    .yAxisLabelsEnabledSet(NO)  //是否显示y轴上的文字
    .tooltipEnabledSet(NO)      //点击不显示浮窗
    //    .tooltipValueSuffixSet(@"分")//设置浮动提示框单位后缀
    .legendEnabledSet(NO)       //不显示下方的可选图例
    .yAxisMinSet(@0)
    .yAxisMaxSet(@(maxNum))
    //x轴文字属性
    .xAxisLabelsFontSizeSet(@11)
    .xAxisLabelsFontWeightSet(@"80")
    .xAxisLabelsFontColorSet(@"#989898")
    .markerRadiusSet(@3)    //折线连接点的半径
    .colorsThemeSet(@[@"#B2C5FA",@"#248AED"])//设置主体颜色数组
    .yAxisTickPositionsSet(@[@(0), @(maxNum/3*2) , @(maxNum)])
    .categoriesSet(categories)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"评分")
                 .typeSet(AAChartTypeArea)
                 .dataSet(backdata)
                 .dashStyleSet(AALineDashSyleTypeShortDash)
                 .lineWidthSet(@0.8)
                 .fillOpacitySet(@0)
                 .markerSet(aaMarker)
                 ,
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"评分")
                 .typeSet(AAChartTypeArea)
                 .dataSet(data)
                 .fillOpacitySet(@0.3)
                 
                 ])
    ;
    
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
}









@end
