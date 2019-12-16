//
//  WJContainerScrollView.m
//  WJContainerScrollView
//
//  Created by wangjie on 2019/11/26.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "WJContainerScrollView.h"
#import <objc/runtime.h>

@interface UIScrollView (WJCanScroll)

@property (nonatomic) BOOL wj_canScroll;

@property (nonatomic) BOOL wj_recognizeSimultaneously;//同时识别滑动

@end

@implementation UIScrollView (WJCanScroll)

- (void)setWj_canScroll:(BOOL)wj_canScroll {
    objc_setAssociatedObject(self, @selector(wj_canScroll), @(wj_canScroll), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)wj_canScroll {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWj_recognizeSimultaneously:(BOOL)wj_recognizeSimultaneously {
    objc_setAssociatedObject(self, @selector(wj_recognizeSimultaneously), @(wj_recognizeSimultaneously), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)wj_recognizeSimultaneously {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@interface WJRecognizeSimultaneouslyScrollView : UIScrollView

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation WJRecognizeSimultaneouslyScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && ((UIScrollView *)otherGestureRecognizer.view).wj_recognizeSimultaneously) {
        return YES;
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _headerView.frame = CGRectMake(0, 0, self.frame.size.width, _headerView.frame.size.height);
    _contentView.frame = CGRectMake(0, _headerView.frame.size.height, self.frame.size.width, _contentView.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width, _headerView.frame.size.height + _contentView.frame.size.height);
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        if (_contentView) [self addSubview:_contentView];
    }
}

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        _headerView = headerView;
        if (_headerView) [self addSubview:_headerView];
    }
}

@end

@interface WJContainerScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) WJRecognizeSimultaneouslyScrollView *scrollView;

@end

@implementation WJContainerScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self addSubview:self.scrollView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)reloadData {
    self.scrollView.headerView = [self.dataSource headerViewInContainerScrollView:self];
    self.scrollView.contentView = [self.dataSource listContainerViewInContainerScrollView:self];
    [[self.dataSource listViewsInContainerScrollView:self] enumerateObjectsUsingBlock:^(id<WJContainerListViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf = self;
        obj.listScrollView.wj_recognizeSimultaneously = YES;
        [obj listViewDidScrollCallback:^(UIScrollView * _Nonnull scrollView) {
            [weakSelf listScrollViewDidScroll:scrollView];
        }];
    }];
}

- (void)listScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.wj_canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makePageViewControllerScroll:scrollView canScroll:NO];
            self.scrollView.wj_canScroll = NO;
        }
    } else {
        [self makePageViewControllerScroll:scrollView canScroll:NO];
    }
}

//设置子视图中UIScrollView是否可以滚动
- (void)makePageViewControllerScroll:(UIScrollView *)scrollView canScroll:(BOOL)canScroll {
    scrollView.wj_canScroll = canScroll;
    scrollView.showsVerticalScrollIndicator = canScroll;
    if (!canScroll) scrollView.contentOffset = CGPointZero;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(containerScrollViewDidScroll:)]) {
        [self.delegate containerScrollViewDidScroll:scrollView];
    }
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat headerHeight = self.scrollView.headerView.frame.size.height - [self.dataSource contentHoverEdgeTop];
    if (contentOffsetY >= headerHeight) {
        scrollView.wj_canScroll = YES;
        scrollView.contentOffset = CGPointMake(0, headerHeight);
        [self makePageViewControllerScroll:[[self.dataSource currentListViewInContainerScrollView:self] listScrollView] canScroll:YES];
    } else {
        if (scrollView.wj_canScroll) {
            scrollView.contentOffset = CGPointMake(0, headerHeight);
        } else {
            UIScrollView *pageScrollView = [[self.dataSource currentListViewInContainerScrollView:self] listScrollView];
            if (pageScrollView.contentOffset.y > 0 && contentOffsetY < 0) scrollView.contentOffset = CGPointZero;
        }
    }
}

#pragma mark Getter

- (WJRecognizeSimultaneouslyScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[WJRecognizeSimultaneouslyScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.alwaysBounceVertical = YES;
        if (@available(iOS 11.0, *)) _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _scrollView;
}

- (UIScrollView *)mj_scrollView {
    return self.scrollView;
}

@end
