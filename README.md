# RWTableView
![logo_txt](/Users/yyk/Desktop/logo_txt.png)

# 如何写好一个tableView，提高代码复用，提高开发效率

tableview 是开发中项目中常用的视图控件，并且是重复的使用，布局类似，只是数据源及Cell更改，所以会出现很多重复的内容，并且即使新建一个基础的列表也要重复这些固定逻辑的代码，这对于开发效率很不友好。
本文的重点是`抽取重复的逻辑代码`，`简化列表页面的搭建`，达到`数据驱动列表`
![思路草稿](https://upload-images.jianshu.io/upload_images/1923392-fc20e37b16938dc2.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

说明：
首先tableview有两个代理delegate 和 datasource（基于单一职责设计规则）
delegate ：负责交互事件；
datasource ：负责cell创建及数据填充，这也是本文探讨的重点。
（1）基本原则
苹果将tableView的数据通过一个`二维数组构建(组，行)`，这是一个很重要的设计点，要沿着这套规则继续发展，设计模式的继承，才是避免坏代码的产生的基础。
（2）组
`“组”是这套逻辑的根基`，`先有组再有行`，并且列表动态修改的内容都是以`行`为基础，`组`的结构相对固定，因此本文将`组`抽离成一个`数据模型`，`而不是接口`。
```
#import <Foundation/Foundation.h>
#import "RWCellViewModelProtocol.h"

@interface RWSectionModel : NSObject
/// item数组：元素必须是遵守RWCellViewModel协议
@property (nonatomic, strong) NSMutableArray <id<RWCellViewModel>>*itemsArray;

/// section头部高度
@property (nonatomic, assign) CGFloat  sectionHeaderHeight;
/// section尾部高度
@property (nonatomic, assign) CGFloat  sectionFooterHeight;
/// sectionHeaderView： 必须是UITableViewHeaderFooterView或其子类，并且遵循RWHeaderFooterDataSource协议
@property (nonatomic, strong) Class headerReuseClass;
/// sectionFooterView： 必须是UITableViewHeaderFooterView或其子类，并且遵循RWHeaderFooterDataSource协议
@property (nonatomic, strong) Class footerReuseClass;

/// headerData
@property (nonatomic, strong) id headerData;
/// footerData
@property (nonatomic, strong) id footerData;
@end
```
（2）行
`行`最核心的有三大`Cell`、`Cell高度`、`Cell数据`。
这次的设计的基于MVVM设计模式，对于行的要素提取成一个ViewModel，并且`ViewModel`要做成`接口`的方式，因为行除了这三个基本的元素外，可能要需要Cell填充的数据，比如titleString，subTitleString，headerImage等等，这样便于扩展。

```
#ifndef RWCellViewModel_h
#define RWCellViewModel_h

@import UIKit;

@protocol RWCellViewModel <NSObject>
/// Cell 的类型
@property (nonatomic, strong) Class cellClass;
/// Cell的高度:  0 则是UITableViewAutomaticDimension
@property (nonatomic, assign) CGFloat  cellHeight;
@end

#endif /* RWCellViewModel_h */
```

（3）tableView
此处不用使用tableViewController的方式，而使用view的方式，这样嵌入更方便。并且对外提供基本的接口，用于列表数据的获取，及点击事件处理。

备注：
关于数据，这里提供了多组和单组的两个接口，为了减少使用的过程中外部新建RWSectionModel这一步，但是其内部还是基于RWSectionModel这一个模型。

```
#import <UIKit/UIKit.h>
#import "RWCellViewModelProtocol.h"
#import "RWSectionModel.h"

@protocol RWTableViewDelegate;

@interface RWTableView : UITableView
/// rwdelegate
@property (nonatomic, weak) id<RWTableViewDelegate> rwdelegate;

/// 构建方法
/// @param delegate 是指rwdelegate
- (instancetype)initWithDelegate:(id<RWTableViewDelegate>)delegate;

@end


@protocol RWTableViewDelegate <NSObject>
@optional
/// 多组构建数据
- (NSArray <RWSectionModel*>*)tableViewWithMutilSectionDataArray;

/// 单组构建数据
- (NSArray <id<RWCellViewModel>>*)tableViewWithSigleSectionDataArray;


/// cell点击事件
/// @param data cell数据模型
/// @param indexPath indexPath
- (void)tableViewDidSelectedCellWithDataModel:(id)data indexPath:(NSIndexPath *)indexPath;
```



```
RWTableview.m

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /// 数据源始终保持“二维数组的状态”，即SectionModel中包裹items的方式
    if ([self.rwdelegate respondsToSelector:@selector(tableViewWithMutilSectionDataArray)]) {
        self.dataArray = [self.rwdelegate tableViewWithMutilSectionDataArray];
        return self.dataArray.count;
    }
    else if ([self.rwdelegate respondsToSelector:@selector(tableViewWithSigleSectionDataArray)]) {
        RWSectionModel *sectionModel = [[RWSectionModel alloc]init];
        sectionModel.itemsArray = [self.rwdelegate tableViewWithSigleSectionDataArray].mutableCopy;
        self.dataArray = @[sectionModel];
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    return sectionModel.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 此处只做Cell的复用或创建
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellViewModel.cellClass)];
    if (cell == nil) {
        cell = [[cellViewModel.cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellViewModel.cellClass)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
```

（4）Cell上子控件的交互事件处理
腾讯QQ部门的大神[峰之巅](https://juejin.im/post/6844904003633938440)提供了一个很好的解决办法，基于苹果现有的响应链(真的很牛逼)，将点击事件传递给下个响应者，而不需要为事件的传递搭建更多的依赖关系。这是一篇鸡汤文章，有很多营养，比如tableview模块化，这也是我接下来要学习的。

```
#import <UIKit/UIKit.h>
#import "RWEvent.h"

@interface UIResponder (RWEvent)

- (void)respondEvent:(NSObject<RWEvent> *)event;

@end
```
```
#import "UIResponder+RWEvent.h"

@implementation UIResponder (RWEvent)

- (void)respondEvent:(NSObject<RWEvent> *)event {
    [self.nextResponder respondEvent:event];
}

@end
```

#特别感谢以下作者写的文章，给我很多启发
[峰之巅：iOS 高效开发解决方案](https://juejin.im/post/6844904003633938440)
[donggelaile：一站式搭建各种滑动列表(Objective-C)](https://juejin.im/post/6844903925242396685)
[基于MVVM，用于快速搭建设置页，个人信息页的框架](https://juejin.im/post/6844903470638563336)
[利用MVVM设计快速开发个人中心、设置等模块](https://www.shuzhiduo.com/A/LPdoY9OwJ3/)
[如何优雅的插入广告](https://github.com/MeetYouDevs/IMYAOPTableView)
[iOS面向切面的TableView-AOPTableView](https://www.jianshu.com/p/ead76a50f107)
[iOS面向切面的TableView-AOPTableView](https://www.jianshu.com/p/d71767e16562)