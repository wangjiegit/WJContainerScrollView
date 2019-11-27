//
//  ViewController.m
//  WJContainerScrollView
//
//  Created by wangjie on 2019/11/26.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "ViewController.h"
#import "WJContainerScrollView.h"
#import "TableViewController.h"

@interface ViewController ()<WJContainerScrollViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) WJContainerScrollView *containerView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray *listViews;

@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic, strong) id<WJContainerListViewDelegate> currentVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.containerView];
    [self addContentView];
}

- (void)addContentView {
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn1.selected = YES;
    btn1.frame = CGRectMake(0, 0, self.view.frame.size.width / 2.0, 44);
    [btn1 setTitle:@"未选中" forState:(UIControlStateNormal)];
    [btn1 setTitle:@"已选中" forState:(UIControlStateSelected)];
    [btn1 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn2.frame = CGRectMake(self.view.frame.size.width / 2.0, 0, self.view.frame.size.width / 2.0, 44);
    [btn2 setTitle:@"未选中" forState:(UIControlStateNormal)];
    [btn2 setTitle:@"已选中" forState:(UIControlStateSelected)];
    [btn2 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    self.btn1 = btn1;
    self.btn2 = btn2;
    
    for (int i = 0; i<self.listViews.count; i++) {
        UIViewController *vc = self.listViews[i];
        vc.view.frame = CGRectMake(self.scrollView.frame.size.width *i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vc.view];
    }
    self.currentVC = self.listViews.firstObject;
    [self.contentView addSubview:self.scrollView];
    [self.containerView reloadData];
}

- (void)click:(UIButton *)btn {
    self.btn2.selected = (btn == self.btn2);
    self.btn1.selected = (btn == self.btn1);
    self.currentVC = (btn==self.btn1?self.listViews.firstObject:self.listViews.lastObject);
    [self.scrollView setContentOffset:CGPointMake(btn==self.btn1?0:self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x / scrollView.frame.size.width == 0) {
        self.currentVC = self.listViews.firstObject;
        self.btn1.selected = YES;
        self.btn2.selected = NO;
    } else {
        self.currentVC = self.listViews.lastObject;
        self.btn1.selected = NO;
        self.btn2.selected = YES;
    }
}

#pragma mark WJContainerScrollViewDataSource

- (CGFloat)contentHoverEdgeTop {
    return 0;
}

- (UIView *)headerViewInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

- (UIView *)listContainerViewInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    return self.contentView;
}

- (id<WJContainerListViewDelegate>)currentListViewInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    return self.currentVC;
}

- (NSArray<id<WJContainerListViewDelegate>> *)listViewsInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    return self.listViews;
}


#pragma mark Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = self.view.bounds;
        _contentView.backgroundColor = [UIColor grayColor];
    }
    return _contentView;
}

- (WJContainerScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[WJContainerScrollView alloc] init];
        _containerView.frame = self.view.bounds;
        _containerView.dataSource = self;
    }
    return _containerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height- 44);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSArray *)listViews {
    if (!_listViews) {
        TableViewController *vc1 = [[TableViewController alloc] init];
        vc1.hidesBottomBarWhenPushed = YES;
        
        TableViewController *vc2 = [[TableViewController alloc] init];
        vc2.hidesBottomBarWhenPushed = YES;
        _listViews = @[vc1, vc2];
    }
    return _listViews;
}

@end
