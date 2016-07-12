//
//  WPStretchButton.m
//  WPStretchButton
//
//  Created by wupeng on 16/7/7.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPStretchButton.h"


@interface WPStretchButton ()
@property (nonatomic,strong) UIButton *bigCirCle;
@property (nonatomic,strong) UIView *smallCircle;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign) CGFloat kCornerRadius;
@property (nonatomic,assign) CGFloat kRatio;
@property (nonatomic,strong) NSArray *images;
@end

@implementation WPStretchButton

-(CGFloat)kCornerRadius {
    return MIN(self.bounds.size.width, self.bounds.size.height) * 0.5;
}
-(CGFloat)kRatio {
    return 0.6;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxDistance = 300;
        self.bgColor = [UIColor redColor];
        [self reloadUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxDistance = 300;
        self.bgColor = [UIColor redColor];
        [self reloadUI];
        [self.bigCirCle setTitle:@"999" forState:UIControlStateNormal];
    }
    return self;
}

-(CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.bgColor.CGColor;
        [self.layer insertSublayer:_shapeLayer below:self.smallCircle.layer];
    }
    return _shapeLayer;
}
-(void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.bigCirCle  setTitleColor:titleColor forState:UIControlStateNormal];
}
-(UIButton *)bigCirCle {
    if (!_bigCirCle) {
        _bigCirCle = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigCirCle.backgroundColor = self.bgColor;
        _bigCirCle.layer.masksToBounds = true;
        _bigCirCle.layer.cornerRadius = self.kCornerRadius;
        _bigCirCle.userInteractionEnabled = true;
        [_bigCirCle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_bigCirCle addGestureRecognizer:pan];
        [_bigCirCle addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_bigCirCle];
    }
    return _bigCirCle;
}
-(void)reloadUI {
    self.smallCircle.frame = CGRectMake(CGFLOAT_MIN, CGFLOAT_MIN, self.bounds.size.width * self.kRatio, self.bounds.size.height * self.kRatio);
    self.smallCircle.center = CGPointMake(self.bounds.size.width * 0.5 , self.bounds.size.height * 0.5);
    self.bigCirCle.frame = self.bounds;
    self.bigCirCle.center = CGPointMake(self.bounds.size.width * 0.5 , self.bounds.size.height * 0.5);
}
-(void)buttonDidClick:(UIButton *)sender {
    
}
-(UIView *)smallCircle {
    if (!_smallCircle) {
        _smallCircle = [UIView new];
        _smallCircle.backgroundColor = self.bgColor;
        _smallCircle.layer.masksToBounds = true;
        _smallCircle.layer.cornerRadius = self.kCornerRadius * self.kRatio;
        [self addSubview:_smallCircle];
    }
    return _smallCircle;
}

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    [self reloadUI];
//}

-(void)panAction:(UIPanGestureRecognizer *)gesture {
    CGPoint panPoint = [gesture translationInView:self];
    
    CGPoint changeCenter = self.bigCirCle.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.bigCirCle.center = changeCenter;
    [gesture setTranslation:CGPointZero inView:self];
    CGFloat distance = [self distanceFromPoint:self.bigCirCle.center toPoint:self.smallCircle.center];
    if (self.maxDistance > distance) {
        if (self.smallCircle.hidden == false && distance > 0) {
            self.shapeLayer.path = [self drawPathWithCircleView:self.bigCirCle andSmall:self.smallCircle].CGPath;
        }
    } else {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        self.smallCircle.hidden = true;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (distance > self.maxDistance) {
            //死亡
            [self killAll];
        } else {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.bigCirCle.center = CGPointMake(self.bounds.size.width * 0.5 , self.bounds.size.height * 0.5);
            } completion:^(BOOL finished) {
                self.smallCircle.hidden = NO;
            }];
        }
    }
}
-(void)killAll {
    [self.bigCirCle removeFromSuperview];
    self.bigCirCle = nil;
    [self.smallCircle removeFromSuperview];
    self.smallCircle = nil;
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
}
-(UIBezierPath *)drawPathWithCircleView:(UIView *)big andSmall:(UIView *)small {
    CGPoint bigCenter = big.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = big.bounds.size.width / 2;
    
    CGPoint smallCenter = small.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = small.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat d = [self distanceFromPoint:big.center toPoint:small.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
    
    
}
-(NSArray *)images {
    if (!_images) {
        _images = [NSArray array];
    }
    return _images;
}
- (void)startDestroyAnimations
{
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:self.frame];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.5;
    [ainmImageView startAnimating];
    
    [self.superview addSubview:ainmImageView];
}

-(CGFloat)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB {
    CGFloat offsetX = pointA.x - pointB.x;
    CGFloat offsetY = pointA.y - pointB.y;
    return sqrtf(offsetX *offsetX + offsetY * offsetY);
}

@end
