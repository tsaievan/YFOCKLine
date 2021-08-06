//
//  CCMinMaxModel.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CCMinMaxModel : NSObject

@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;

- (CGFloat)distance;
+ (instancetype)modelWithMin:(CGFloat)min max:(CGFloat)max;
- (void)combine:(CCMinMaxModel *)m;

@end

NS_ASSUME_NONNULL_END
