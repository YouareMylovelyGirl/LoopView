//
//  YGFlowLayout.m
//  UI 图片轮播器
//
//  Created by 阳光 on 2017/1/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "YGFlowLayout.h"

@implementation YGFlowLayout
- (void)prepareLayout
{
    //一定super
    [super prepareLayout];
    //在collectionView的第一次布局的时候, 被调用, 此时collectionView 的frame 已经设置完毕直接利用
    NSLog(@"%@", self.collectionView);
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsZero;
    //设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}
@end
