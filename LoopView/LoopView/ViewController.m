//
//  ViewController.m
//  LoopView
//
//  Created by 阳光 on 2017/1/30.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "ViewController.h"
#import "YGLoopView.h"
//类扩展 / 匿名分类, 定义私有属性 / 方法
@interface ViewController ()

@end


@implementation ViewController
{
    NSArray <NSURL *>* _urls;
}
/**
 属性和成员变量的区别
 属性:提供了 getter / setter / 成员变量
 成员变量:
 
 真正保存数据的是`成员变量`
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDidLoad];
    NSLog(@"%@", _urls);
    
    YGLoopView *loopView = [[YGLoopView alloc] initWithURLs:_urls];
    loopView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:loopView];
}

- (void)loadDidLoad
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NSString *fileName = [NSString stringWithFormat:@"welcome%d.PNG", (i + 1)];
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        [array addObject:url];
    }
    _urls = array.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
