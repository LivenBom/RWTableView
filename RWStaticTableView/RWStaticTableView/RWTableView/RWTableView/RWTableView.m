//
//  RWTableView.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWTableView.h"
#import "RWCellViewModelProtocol.h"
#import "RWCellDataSourceProtocol.h"
#import "RWHeaderFooterDataSourceProtocol.h"

#import "RWSectionModel.h"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    if (cellViewModel.cellHeight == 0) {
        return UITableViewAutomaticDimension;
    }
    return cellViewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell <RWCellDataSource>*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    id<RWCellViewModel>cellViewModel = [sectionModel.itemsArray objectAtIndex:indexPath.row];
    /// Cell赋值
    if ([cell respondsToSelector:@selector(rw_setData:)]) {
        [cell rw_setData:cellViewModel];
    }
    /// 高度缓存
    /// 此处高度做一个缓存是为了高度自适应的Cell，重复计算的工作量，
    /// 同时可以避免由于高度自适应导致Cell的定位不准确，比如置顶或者滑动到某一个Cell的位置
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
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:NSStringFromClass(sectionModel.headerReuseClass)];
    if (headerView == nil) {
        headerView = [[sectionModel.headerReuseClass alloc]initWithReuseIdentifier: NSStringFromClass(sectionModel.headerReuseClass)];
    }
    if ([headerView respondsToSelector:@selector(rw_setData:)]) {
        [headerView performSelector:@selector(rw_setData:) withObject:sectionModel.headerData];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    RWSectionModel *sectionModel = [self.dataArray objectAtIndex:section];
    if (sectionModel.footerReuseClass == nil){
        return [UIView new];
    }
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:NSStringFromClass(sectionModel.footerReuseClass)];
    if (footerView == nil) {
        footerView = [[sectionModel.footerReuseClass alloc]initWithReuseIdentifier: NSStringFromClass(sectionModel.footerReuseClass)];
    }
    if ([footerView respondsToSelector:@selector(rw_setData:)]) {
        [footerView performSelector:@selector(rw_setData:) withObject:sectionModel.footerData];
    }
    return footerView;
}

@end