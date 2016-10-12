//
//  ZZAdCirculatePlay.m
//  iOSWebApp
//

#import "ZZAdCirculatePlay.h"
#import "UIImageView+WebCache.h"

@interface ZZAdCirculatePlay ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    NSInteger _currentIndex;
    NSTimer *_timer;
    
    UIImageView *_currentImageView;
    UIImageView *_rightImageView;
    UIImageView *_leftImageView;
    
    UIImageView *_currentBgImageView;
    UIImageView *_rightBgImageView;
    UIImageView *_leftBgImageView;
}
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,assign) CGSize itemSize;

@end

@implementation ZZAdCirculatePlay

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createScrollView];
        [self createPageControl];
        [self createView];
    }
    return self;
}

- (void)createView
{
    _currentBgImageView = [[UIImageView alloc] init];
    _currentBgImageView.frame = CGRectMake(self.width, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_currentBgImageView];
    
    _rightBgImageView = [[UIImageView alloc] init];
    _rightBgImageView.frame = CGRectMake(self.width * 2, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_rightBgImageView];
    
    _leftBgImageView = [[UIImageView alloc] init];
    _leftBgImageView.frame = CGRectMake(0, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_leftBgImageView];
    
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.frame = CGRectMake(self.width, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_currentImageView];
    
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.frame = CGRectMake(self.width * 2, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_rightImageView];
    
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.frame = CGRectMake(0, 0, self.width, self.frame.size.height);
    [self.scrollView addSubview:_leftImageView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewHorizontalCanScrollName:)
                                                 name:kScrollViewHorizontalCanScrollName
                                               object:nil];
}

- (void)scrollViewHorizontalCanScrollName:(NSNotification *)noti
{
    BOOL flag = [noti.object boolValue];
    _scrollView.scrollEnabled = flag;
    if (flag) {
        [self addTimer];
    }
    else {
        if (!self.isScrollEnabled) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.width, self.frame.size.height);
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapClick:)];
    [scrollView addGestureRecognizer:tap];
    self.scrollView = scrollView;
    _currentIndex = 0;
}


- (void)setIsScrollEnabled:(BOOL)isScrollEnabled
{
    _isScrollEnabled = isScrollEnabled;
    [_timer invalidate];
    _timer = nil;
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(adCirculatePlay:didClickIndex:)]) {
        [self.delegate adCirculatePlay:self didClickIndex:_currentIndex];
    }
}

/** 载滚动内容 */
- (void)loadImageView
{
    if (!self.dataArray.count) {
        [_currentBgImageView removeFromSuperview];
        [_rightBgImageView removeFromSuperview];
        [_leftBgImageView removeFromSuperview];
    }
    
    NSString *imageName = self.adArray[_currentIndex];
    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    [self.scrollView addSubview:_currentImageView];
    
    NSInteger index = _currentIndex + 1 < self.adArray.count ? _currentIndex + 1 : 0;
    imageName = self.adArray[index];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    
    
    index = _currentIndex - 1 >= 0 ? _currentIndex - 1 : self.adArray.count - 1;
    imageName = self.adArray[index];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
}

- (void)loadDictImageView
{
    NSDictionary *dict = self.dataArray[_currentIndex];
    if (dict[@"front_image_url"]) {
        [_currentImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"front_image_url"]]];
    }
    if (dict[@"back_image_url"]) {
        [_currentBgImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"back_image_url"]]];
    }
    
    NSInteger index = _currentIndex + 1 < self.dataArray.count ? _currentIndex + 1 : 0;
    dict = self.dataArray[index];
    if (dict[@"front_image_url"]) {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"front_image_url"]]];
    }
    if (dict[@"back_image_url"]) {
        [_rightBgImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"back_image_url"]]];
    }
    
    index = _currentIndex - 1 >= 0 ? _currentIndex - 1 : self.dataArray.count - 1;
    dict = self.dataArray[index];
    if (dict[@"front_image_url"]) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"front_image_url"]]];
    }
    if (dict[@"back_image_url"]) {
        [_leftBgImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"back_image_url"]]];
    }
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark - 添加视图页码和代理
- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
}

- (void)setIsPageHiden:(BOOL)isPageHiden
{
    _isPageHiden = isPageHiden;
    _pageControl.hidden = isPageHiden;
    _pageControl = nil;
}
#pragma mark - 属性的set方法
- (void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    _currentIndex = 0;
    _scrollView.contentOffset = CGPointMake(0, 0);
    _pageControl.currentPage = 0;
    if (!adArray.count) {
        return;
    }
    
    [self loadImageView];
    [self setParamsWithArray:adArray];
}

- (void)setParamsWithArray:(NSArray *)array
{
    [self addTimer];
    
    CGFloat scale = 0.8;
    CGFloat pageW = 15 * array.count * scale;
    CGFloat pageX = self.bounds.size.width -  pageW - 10;
    CGFloat pageH = 20;
    CGFloat pageY = self.bounds.size.height - 20;
    _pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    _pageControl.transform = CGAffineTransformMakeScale(scale, scale);
    _pageControl.numberOfPages = array.count;
    
    switch (self.position) {
        case PageControlPositionLeft:
            _pageControl.x = 10;
            break;
        case PageControlPositionCenter:
            _pageControl.center = CGPointMake(ScreenWidth / 2, pageY + pageH / 2);
            _pageControl.transform = CGAffineTransformMakeScale(1, 1);
            break;
        case PageControlPositionRight:
            break;
    }
    
    NSInteger count = array.count == 2 ? 3 : array.count;
    _scrollView.contentSize = CGSizeMake(self.width * count, 0);
    _pageControl.hidden = array.count == 1 ? YES : NO;
}

/**  传过来的是字典 */
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    _currentIndex = 0;
    _scrollView.contentOffset = CGPointMake(0, 0);
    _pageControl.currentPage = 0;
    if (!dataArray.count) {
        return;
    }
    
    [self loadDictImageView];
    [self setParamsWithArray:dataArray];
}

#pragma mark - 添加定时器和相应方法
- (void)addTimer
{
    [_timer invalidate];
    _timer = nil;
    
    if (self.isScrollEnabled) {
        return;
    }
    NSArray *array = self.dataArray.count ? self.dataArray : self.adArray;
    if (array.count > 1) {
        __weak typeof(self) weakself = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:weakself selector:@selector(timerChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerChange
{
    [UIView animateWithDuration:1.0 animations:^{
    // 让滚动视图动画
        self.scrollView.contentOffset = CGPointMake(self.width * 2, 0);
    } completion:^(BOOL finished) {
        NSArray *array = self.dataArray.count ? self.dataArray : self.adArray;
        _currentIndex = _currentIndex + 1 < array.count ? (_currentIndex + 1) : 0;
        if (self.dataArray.count) {
            [self loadDictImageView];
        }
        else {
            [self loadImageView];
        }
        _pageControl.currentPage = _currentIndex;
    }];
}

#pragma mark - scrollView 代理方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.width;
    NSArray *array = self.dataArray.count ? self.dataArray : self.adArray;
    if (index == 0) {
        _currentIndex = (_currentIndex - 1) >= 0 ? (_currentIndex - 1) : (array.count - 1);
    }
    else if (index == 2){
        _currentIndex = (_currentIndex + 1) < array.count ? (_currentIndex + 1) : 0;
    }
    
    if (self.dataArray.count) {
        [self loadDictImageView];
    }
    else {
        [self loadImageView];
    }
    _pageControl.currentPage = _currentIndex;
    if ([self.delegate respondsToSelector:@selector(adCirculatePlay:didScrollIndex:)]) {
        [self.delegate adCirculatePlay:self didScrollIndex:_currentIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kScrollViewVerticalCanScrollName object:@(1)];
    if (!self.isScrollEnabled) {
        [self addTimer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kScrollViewVerticalCanScrollName object:@(0)];
    if (!self.isScrollEnabled) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
