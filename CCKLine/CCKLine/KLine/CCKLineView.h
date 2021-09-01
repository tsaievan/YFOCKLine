//
//  CCKLineView.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import <UIKit/UIKit.h>
#import "CCKLineRootModel.h"
#import "CCPainterProtocol.h"

@interface CCKLineView : UIView

/// 数据
@property (nonatomic, strong) CCKLineRootModel *rootModel;
@property (nonatomic) Class <CCPainterProtocol> linePainter;
@property (nonatomic) Class <CCPainterProtocol> indicator1Painter;
@property (nonatomic) Class <CCPainterProtocol> indicator2Painter;

/// 重绘
- (void)reDraw;
@end
