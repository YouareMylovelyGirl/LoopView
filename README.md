# LoopView
##collectionView, 实现高性能图片轮播

![LoopView](/Users/koreyoshi/Desktop/Snip20170130_1.png
)

###获取数据
```objc
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
```

###封装轮播器视图, 设置数据源, 传递数据
```objc
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

```

###自定义Cell
```objc
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
```

### 重写prepareLayout
```objc
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
```

###实现轮播
```objc
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
```

####轮播框架, 流畅易懂 学习就是将大家的知识, 变成自己的知识.
[LoopView - 代码](https://github.com/YouareMylovelyGirl/LoopView)
[博客园](http://www.cnblogs.com/Dog-Ping/)

