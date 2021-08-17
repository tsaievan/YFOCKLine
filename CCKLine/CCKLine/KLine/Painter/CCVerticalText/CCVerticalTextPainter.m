//
//  CCVerticalTextPainter.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/10.
//

#import "CCVerticalTextPainter.h"

@implementation CCVerticalTextPainter

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area minMax:(CCMinMaxModel *)minMaxModel {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    CCVerticalTextPainter *sublayer = [[CCVerticalTextPainter alloc] init];
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    /// 数字40只是一个magic数字, 没啥特殊意义
    NSInteger count = maxH / 40;
    count++;
    CGFloat lineH = [UIFont systemFontOfSize:12.f].lineHeight;
    CGFloat textGap = (maxH - lineH) / (count - 1);
    
}

@end
