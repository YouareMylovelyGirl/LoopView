//
//  YGLoopViewCell.m
//  UI 图片轮播器
//
//  Created by 阳光 on 2017/1/30.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "YGLoopViewCell.h"

@implementation YGLoopViewCell {
    UIImageView *_imageView;
}

//collectionViewCell 的 frame 是根据之前的layout 已经确定好了
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       //添加图像视图
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self.contentView addSubview:_imageView];
        _imageView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    //1. 现根据URL 获取二进制数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    //2. 将二进制数据转换成图像
    UIImage *image = [UIImage imageWithData:data];
    
    _imageView.image = image;
}

@end
