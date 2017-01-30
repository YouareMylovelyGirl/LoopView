//
//  YGLoopView.m
//  UI 图片轮播器
//
//  Created by 阳光 on 2017/1/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "YGLoopView.h"
#import "YGFlowLayout.h"
#import "YGLoopViewCell.h"
@interface YGLoopView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

//独立的处理轮播器相关的所有的代码逻辑
@implementation YGLoopView {
    NSArray <NSURL *>*_urls;
}

static NSString * const ID = @"Cell";

- (instancetype)initWithURLs:(NSArray <NSURL *>*)urls
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[[YGFlowLayout alloc] init]];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _urls = urls;
        
        [self registerClass:[YGLoopViewCell class] forCellWithReuseIdentifier:ID];
        
        //初始显示第二组
        //在开发中什么时候使用过多线程, 不要说AFN!
        //主队列:
        //1.安排任务在主线程上执行
        //2.如果主线程当前任务, 主队列暂时不调度任务
        //利用主队列异步, 保证数据源方法执行完毕后, 在滚动collectionView
        //提示:公司的项目中可能会出现 viewDidLoad 中有大量的主队列异步的, 原因:要等所有数据方法都执行完, 主线程空闲以后再做后续任务
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_urls.count inSection:0];
            // 0 1 2 3 4 5 6 7
            //滚动位置
            [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //如果将数据源设置为两倍, 当凶猛的用户手速很快滑动时, 会使得轮播在计算contenOffset时候, 有明显卡顿的bug, 所以设置 * 100, 就会有 400 张备用, 由于collectionView已经很好的解决的服用问题, 所以一般只显示2 个cell, 手速猛地最多3个
    //return _urls.count * 2;
    // 放大数据源
    return _urls.count * 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YGLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1];
    //防止数据越界
    cell.url = _urls[indexPath.row % _urls.count];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //1. 获取当前停止的界面
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    
    //2. 第0页, 跳转到, 第二组的第0页
    //最后一页, 跳转到第0组的最后一页
    if (pageNum == 0 || pageNum == [self numberOfItemsInSection:0] - 1) {
        NSLog(@"%zd", pageNum);
        
        //第 0 页
        if (pageNum == 0) {
            pageNum = _urls.count;
        } else {
            pageNum = _urls.count - 1;
        }
        
        //重新调整 contentOffset
        scrollView.contentOffset = CGPointMake(pageNum * scrollView.bounds.size.width, 0);
    }
}

@end
