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
#import "WJSwitchPagesView.h"
#import "PageBarItem.h"

@interface ViewController ()<WJContainerScrollViewDataSource, UIScrollViewDelegate, WJSwitchPagesBarDataSource>

@property (nonatomic, strong) WJContainerScrollView *containerView;

@property (nonatomic, strong) WJSwitchPagesView *switchPagesView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *vcList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.containerView];
    [self addContentView];
}

- (void)addContentView {
   self.vcList = [NSMutableArray array];
   for (int i = 0; i < self.titleArray.count; i++) {
       TableViewController *vc = [TableViewController new];
       [self.vcList addObject:vc];
   }
   self.switchPagesView.controllers = self.vcList;
   [self.switchPagesView completeWithSelectedIndex:0];
    [self.containerView reloadData];
}

#pragma mark UIScrollViewDelegate


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
    return self.switchPagesView;
}

- (id<WJContainerListViewDelegate>)currentListViewInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    TableViewController *vc = (TableViewController *)self.switchPagesView.currentController;
    return vc;
}

- (NSArray<id<WJContainerListViewDelegate>> *)listViewsInContainerScrollView:(WJContainerScrollView *)containerScrollView {
    return self.vcList;
}

#pragma mark WJSwitchPagesBarDataSource

- (UIView *)indexViewInswitchPagesBar:(WJSwitchPagesBar *)switchPagesBar {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, switchPagesBar.height - 3, 20, 3);
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

//每个item的大小
- (CGFloat)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar widthForIndex:(NSUInteger)index {
    return [PageBarItem getWidthByText:self.titleArray[index] height:switchPagesBar.height];
}

//item总数
- (NSInteger)numberOfSwitchPagesBarItem:(WJSwitchPagesBar *)switchPagesBar {
    return self.titleArray.count;
}

//item
- (UIView<WJSwitchPagesBarItemProtocol> *)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar itemForIndex:(NSUInteger)index {
    PageBarItem *item = [[PageBarItem alloc] init];
    item.textLabel.text = self.titleArray[index];
    return item;
}


#pragma mark Getter

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

- (WJSwitchPagesView *)switchPagesView {
    if (!_switchPagesView) {
        _switchPagesView = [[WJSwitchPagesView alloc] init];
        _switchPagesView.frame = self.view.bounds;
        _switchPagesView.barHeight = 40;
        _switchPagesView.dataSource = self;
    }
    return _switchPagesView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"本地", @"浙江"];
    }
    return _titleArray;
}

@end
