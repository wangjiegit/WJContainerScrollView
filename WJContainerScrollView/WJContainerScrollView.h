//
//  WJContainerScrollView.h
//  WJContainerScrollView
//
//  Created by wangjie on 2019/11/26.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJContainerScrollView;

NS_ASSUME_NONNULL_BEGIN

@protocol WJContainerListViewDelegate <NSObject>

@required

/**
返回listView内部所持有的UIScrollView或UITableView或UICollectionView

@return UIScrollView
*/
- (UIScrollView *)listScrollView;

/**
当listView所持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，
   需要调用该代理方法传入callback

@param callback `scrollViewDidScroll`回调时调用的callback
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     !self.scrollCallback ? : self.scrollCallback(scrollView);
 }

 - (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
     self.scrollCallback = callback;
 }
 
*/
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

@end

@protocol WJContainerScrollViewDelegate <NSObject>

//scrollViewDidScroll:(UIScrollView *)scrollView 最外层的scrollView 附加滚动是nav渐变
- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@protocol WJContainerScrollViewDataSource <NSObject>

@required
//内容悬停离屏幕距离 //一般是navHeight
- (CGFloat)contentHoverEdgeTop;

//头部
- (UIView *)headerViewInContainerScrollView:(WJContainerScrollView *)containerScrollView;

//子视图容器
- (UIView *)listContainerViewInContainerScrollView:(WJContainerScrollView *)containerScrollView;

//当前子视图
- (id<WJContainerListViewDelegate>)currentListViewInContainerScrollView:(WJContainerScrollView *)containerScrollView;

//获取所有可以滚动的子视图
- (NSArray<id<WJContainerListViewDelegate>> *)listViewsInContainerScrollView:(WJContainerScrollView *)containerScrollView;

@end

@interface WJContainerScrollView : UIView

@property (nonatomic, strong, readonly) UIScrollView *mj_scrollView;//添加下拉刷新

@property (nonatomic, weak) id<WJContainerScrollViewDataSource> dataSource;

@property (nonatomic, weak) id<WJContainerScrollViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
