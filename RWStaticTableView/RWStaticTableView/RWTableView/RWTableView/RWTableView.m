//
//  RWTableView.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWTableView.h"
#import "RWCellViewModelProtocol.h"
#import "RWSectionModel.h"

#import "UITableViewCell+RWData.h"
#import "UITableViewHeaderFooterView+RWData.h"

@interface RWTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@end


@implementation RWTableView

/// 构建方法
/// @param delegate 是指rwdelegate
/// 默认是UITableViewStylePlain
- (instancetype)initWithDelegate:(id<RWTableViewDelegate>)delegate {
    self = [super init];
    if (self) {
        [self configTableView];
    }
    return self;
}

/// 初始化
/// @param delegate rwdelegate
/// @param style UITableViewStyle
- (instancetype)initWithDelegate:(id<RWTableViewDelegate>)delegate
                  tableViewStyle:(UITableViewStyle)style {
    self = [super initWithFrame:CGRectZero style:style];
    if (self) {
        [self configTableView];
        self.rwdelegate = delegate;
    }
    return self;
}


- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    /// 这里的 estimatedSectionHeaderHeight 和 estimatedSectionFooterHeight 设置为0 是为了iOS11之后版本的适配
    /// 因为iOS11以后，如果只设置heightForHeaderInSection和heightForFooterInSection是不起作用的
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 点击事件处理：返回Cell对应的ViewModel便于操作
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    if ([self.rwdelegate respondsToSelector:@selector(tableViewDidSelectedCellWithDataModel:indexPath:)]) {
        [self.rwdelegate tableViewDidSelectedCellWithDataModel:cellViewModel indexPath:indexPath];
    }
}


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
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellViewModel.cellClass)];
    /// Cell创建
    if (cell == nil) {
        cell = [[cellViewModel.cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellViewModel.cellClass)];
    }
    /// Cell赋值
    [cell rw_setData:cellViewModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    return cellViewModel.cellHeight ? : UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    /// 高度缓存
    /// 此处高度做一个缓存是为了高度自适应的Cell，避免重复计算的工作量，对于性能优化有些帮助
    /// 如果想要在willDisplayCell获取到准确的Cell高度，那么必须在cellForRowAtIndexPath:方法给Cell赋值
    /// 同时可以避免由于高度自适应导致Cell的定位不准确，比如置顶或者滑动到某一个Cell的位置
    /// 如果自动布局要更新高度，可以将cellViewModel设置为0
    cellViewModel.cellHeight = cell.frame.size.height;
}


# pragma mark - 头部和尾部处理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    return sectionModel.sectionHeaderHeight == 0 ? CGFLOAT_MIN : sectionModel.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    return sectionModel.sectionFooterHeight == 0 ? CGFLOAT_MIN : sectionModel.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    if (sectionModel.headerReuseClass == nil){
        return [UIView new];
    }
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(sectionModel.headerReuseClass)];
    if (headerView == nil) {
        headerView = [[sectionModel.headerReuseClass alloc]initWithReuseIdentifier: NSStringFromClass(sectionModel.headerReuseClass)];
    }
    [headerView rw_setData:sectionModel.headerData];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    if (sectionModel.footerReuseClass == nil){
        return [UIView new];
    }
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(sectionModel.footerReuseClass)];
    if (footerView == nil) {
        footerView = [[sectionModel.footerReuseClass alloc]initWithReuseIdentifier: NSStringFromClass(sectionModel.footerReuseClass)];
    }
    [footerView rw_setData:sectionModel.footerData];
    return footerView;
}

@end
