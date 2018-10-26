

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KCGradientLabelGradientDirection) {
    KCGradientLabelGradientDirectionHorizontal,
    KCGradientLabelGradientDirectionVertical,
    KCGradientLabelGradientDirectionTopLeftToBottomRight,
    KCGradientLabelGradientDirectionBottomLeftToTopRight
};

@interface KCGradientLabel : UIView

/**
 *  渐变的颜色集合
 */
@property(nonatomic, strong) NSArray <__kindof UIColor *> * gradientColors;

@property (nonatomic, copy) NSString *text;

@property(nonatomic,strong) UIFont *font;

@property(nonatomic) NSTextAlignment textAlignment;

@property(nonatomic) NSInteger numberOfLines;

/**
 *  是否启动动画，默认NO
 */
@property (nonatomic, assign, getter=isAnimate) BOOL animate;
/**
 *  动画时长，默认2秒
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  颜色渐变方向，目前提供四个方向
 */
@property (nonatomic, assign) KCGradientLabelGradientDirection gradientDirection;

@end
