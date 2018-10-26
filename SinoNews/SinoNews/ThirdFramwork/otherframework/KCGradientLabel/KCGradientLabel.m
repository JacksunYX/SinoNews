
#import "KCGradientLabel.h"
#import <objc/runtime.h>

@implementation CADisplayLink (KCExtension)

static NSString *KCCADisplayLinkBlockKey = @"KCCADisplayLinkBlockKey";

+ (void)kc_block:(CADisplayLink *)link {
    
    void(^Block)(CADisplayLink *link) = objc_getAssociatedObject(self, (__bridge const void *)(KCCADisplayLinkBlockKey));
    
    if (Block) {
        Block(link);
    }
}

+ (CADisplayLink *)kc_displayLinkWithBlock:(void(^)(CADisplayLink *link))block
{
    objc_setAssociatedObject(self, (__bridge const void *)(KCCADisplayLinkBlockKey), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return [CADisplayLink displayLinkWithTarget:self selector:@selector(kc_block:)];
}

@end


@interface KCGradientLabel () 

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation KCGradientLabel

- (void)dealloc
{
    [self removeLink];
}

- (void)addLink
{
    [self removeLink];
    
    __weak typeof(self) weakSelf = self;
    self.link = [CADisplayLink kc_displayLinkWithBlock:^(CADisplayLink *link) {
        [weakSelf performAnimation];
    }];
    
    self.link.frameInterval = self.animationDuration;
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)removeLink
{
    [self.link invalidate];
    self.link = nil;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.mask = self.label.layer;
        _gradientLayer.colors = @[(id)self.label.textColor.CGColor, (id)self.label.textColor.CGColor];
        
    }
    return _gradientLayer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    _animationDuration = 2;
    
    [self addSubview:self.label];
    [self.layer addSublayer:self.gradientLayer];
}

- (CGSize)intrinsicContentSize
{
    [self sizeToFit];
    return self.frame.size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
    
}

- (void)setGradientColors:(NSArray<__kindof UIColor *> *)gradientColors
{
    if (gradientColors.count < 2) {
        NSLog(@"至少需要2种颜色才有渐变效果哦~~~~%s", __func__);
        return;
    }
    
    _gradientColors = gradientColors;
    
    NSMutableArray *colors = @[].mutableCopy;
    for (UIColor *color in gradientColors) {
        [colors addObject:(id)color.CGColor];
    }
    
    
    self.gradientLayer.colors = colors;
    
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = text;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    
    self.label.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    self.label.textAlignment = textAlignment;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    _numberOfLines = numberOfLines;
    
    self.label.numberOfLines = numberOfLines;
}

- (void)setGradientDirection:(KCGradientLabelGradientDirection)gradientDirection
{
    _gradientDirection = gradientDirection;
    
    switch (gradientDirection) {
        case KCGradientLabelGradientDirectionHorizontal:
            
            self.gradientLayer.startPoint = CGPointMake(0, 0.5);
            self.gradientLayer.endPoint = CGPointMake(1, 0.5);
            break;
        case KCGradientLabelGradientDirectionVertical:
            
            self.gradientLayer.startPoint = CGPointMake(0.5, 0);
            self.gradientLayer.endPoint = CGPointMake(0.5, 1);
            break;
        case KCGradientLabelGradientDirectionTopLeftToBottomRight:
            
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 1);
            break;
        case KCGradientLabelGradientDirectionBottomLeftToTopRight:
            
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        default:
            break;
    }
}


- (void)sizeToFit
{
    [super sizeToFit];
    [self.label sizeToFit];
    CGRect frame = self.frame;
    frame.size = self.label.frame.size;
    self.frame = frame;
}

- (void)setAnimate:(BOOL)animate
{
    _animate = animate;
    
    if (animate) {
    
        [self addLink];
        
    }else {
        [self removeLink];
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    if (self.isAnimate) {
        
        [self addLink];
    }
    
}

- (void)performAnimation
{
    CAGradientLayer *layer = self.gradientLayer;
    NSMutableArray *colorArray = [[layer colors] mutableCopy];
    UIColor *lastColor = [colorArray lastObject];
    [colorArray removeLastObject];
    [colorArray insertObject:lastColor atIndex:0];
    NSArray *shiftedColors = [NSArray arrayWithArray:colorArray];
    [layer setColors:shiftedColors];
}


@end
