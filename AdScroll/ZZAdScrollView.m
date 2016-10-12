//
//  ZZAdScrollView.m
//  iOSWebApp
//

#import "ZZAdScrollView.h"
#import <UIImage+GIF.h>
#import "UIImageView+WebCache.h"
#import <YYImage/YYImage.h>
#import "BdbsImage.h"

@interface ZZAdScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *_adScrollView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
}
@end

@implementation ZZAdScrollView

#pragma mark - 初始化

- (void)dealloc
{
    DLog(@"ZZAdScrollView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createAdScrollView];
        [self createPageControl];
    }
    return self;
}

- (void)createAdScrollView
{
    _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height)];
    _adScrollView.delegate = self;
    _adScrollView.bounces = NO;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    _adScrollView.pagingEnabled = YES;
    [self addSubview:_adScrollView];
}

#pragma mark - 创建自定义页码视图
- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = BdbsColor;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
}

- (void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    for (int i = 0; i < adArray.count; i++) {
        
        CGRect frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, self.height);
        if (i == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.image = [UIImage imageNamed:adArray[i]];
            [_adScrollView addSubview:imageView];
        }
        else {
            BdbsImage *image = (BdbsImage *)[BdbsImage imageNamed:adArray[i]];
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, self.height);
            imageView.tag = i + 1000;
            imageView.animationRepeatCount = 1;
            imageView.autoPlayAnimatedImage = YES;
            imageView.userInteractionEnabled = YES;
            [_adScrollView addSubview:imageView];
            [imageView stopAnimating];
            if (i == adArray.count - 1) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchApp)];
                [imageView addGestureRecognizer:tap];
            }
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapClick:)];
    [_adScrollView addGestureRecognizer:tap];
    _adScrollView.contentSize = CGSizeMake(ScreenWidth * adArray.count, 0);
    
    _pageControl.numberOfPages = self.adArray.count;
    
    CGFloat pageW = 15 * self.adArray.count;
    CGFloat pageX = self.bounds.size.width -  pageW - 10;
    CGFloat pageH = 20;
    CGFloat pageY = self.bounds.size.height - 20 * self.height / 200;
    _pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    switch (self.position) {
        case PageControlPositionLeft:
            _pageControl.x = 10;
            break;
        case PageControlPositionCenter:
            _pageControl.center = CGPointMake(ScreenWidth / 2, pageY + pageH * 2);
            _pageControl.transform = CGAffineTransformMakeScale(1, 1);
            break;
        case PageControlPositionRight:
            break;
    }
}

- (void)launchApp
{
        [UIView animateWithDuration:1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}

/**  广告栏按钮的响应事件 */
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = _adScrollView.contentOffset.x / ScreenWidth;
    if ([self.delegate respondsToSelector:@selector(adScrollPlay:index:)]) {
        [self.delegate adScrollPlay:self index:index];
    }
}

#pragma mark - scrollView代理协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = _adScrollView.contentOffset.x / ScreenWidth;
    _adScrollView.contentOffset = CGPointMake(index * ScreenWidth, 0);
    _pageControl.currentPage = index;
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [_adScrollView viewWithTag:1000 + i];
        if (i != index) {
            if ([imageView isKindOfClass:[YYAnimatedImageView class]]) {
                YYAnimatedImageView *yyImageView = (YYAnimatedImageView *)imageView;
                [yyImageView stopAnimating];
            }
        }
        else {
            if ([imageView isKindOfClass:[YYAnimatedImageView class]]) {
                YYAnimatedImageView *yyImageView = (YYAnimatedImageView *)imageView;
                [yyImageView startAnimating];
            }
        }
    }
}

@end
