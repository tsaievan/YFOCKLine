//
//  CCMAPainter.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/9/1.
//

#import "CCMAPainter.h"
#import "CCKLineGlobalVariable.h"
#import "UIColor+CCKLine.h"

@implementation CCMAPainter

+ (CCMinMaxModel *)getMinMaxValue:(NSArray<CCKLineModel *> *)data {
    if (!data) {
        return [[CCMinMaxModel alloc] init];
    }
    __block CGFloat minAssert = CGFLOAT_MAX;
    __block CGFloat maxAssert = CGFLOAT_MIN;
    
    [data enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(m.MA.MA3.floatValue, MAX(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
        minAssert = MIN(minAssert, MIN(m.MA.MA3.floatValue, MIN(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
    }];
    return [CCMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<CCKLineModel *> *)models minMax:(CCMinMaxModel *)minMaxModel {
    if (!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH / minMaxModel.distance;
    
    CCMAPainter *sublayer = [[CCMAPainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [CCKLineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [CCKLineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x + w / 2, maxH - (m.MA.MA1.floatValue - minMaxModel.min) * unitValue);
        CGPoint point2 = CGPointMake(x + w / 2, maxH - (m.MA.MA2.floatValue - minMaxModel.min) * unitValue);
        CGPoint point3 = CGPointMake(x + w / 2, maxH - (m.MA.MA3.floatValue - minMaxModel.min) * unitValue);
        if (idx == 0) {
            [path1 moveToPoint:point1];
            [path2 moveToPoint:point2];
            [path3 moveToPoint:point3];
        }else {
            [path1 addLineToPoint:point1];
            [path2 addLineToPoint:point2];
            [path3 addLineToPoint:point3];
        }
    }];
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path1.CGPath;
        l.lineWidth = CCKLineLineWidth;
        l.strokeColor = [UIColor line1Color].CGColor;
        l.fillColor = [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path2.CGPath;
        l.lineWidth = CCKLineLineWidth;
        l.strokeColor = [UIColor line2Color].CGColor;
        l.fillColor = [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path3.CGPath;
        l.lineWidth = CCKLineLineWidth;
        l.strokeColor = [UIColor line3Color].CGColor;
        l.fillColor = [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];
}

+ (NSAttributedString *)getText:(CCKLineModel *)model {
    return model.V_MA;
}

@end
