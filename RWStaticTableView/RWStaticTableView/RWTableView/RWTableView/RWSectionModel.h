//
//  RWSectionModel.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

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

