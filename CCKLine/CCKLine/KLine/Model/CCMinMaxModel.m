//
//  CCMinMaxModel.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import "CCMinMaxModel.h"

@implementation CCMinMaxModel

+ (instancetype)modelWithMin:(CGFloat)min max:(CGFloat)max {
    CCMinMaxModel *m = [[CCMinMaxModel alloc] init];
    m.min = min;
    m.max = max;
    return m;
}

- (CGFloat)distance {
    return self.max - self.min;
}

- (void)combine:(CCMinMaxModel *)m {
    self.min = MIN(self.min, m.min);
    self.max = MAX(self.max, m.max);
}

@end
