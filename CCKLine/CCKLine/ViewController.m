//
//  ViewController.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "ViewController.h"
#import "CCChartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jumpToKLine:(UIButton *)sender {
    CCChartViewController *stockChartVc = [[CCChartViewController alloc] init];
    stockChartVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:stockChartVc animated:YES completion:nil];
}

@end
