//
//  RWCellDataSourceProtocol.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#ifndef RWCellDataSourceProtocol_h
#define RWCellDataSourceProtocol_h

@protocol RWCellDataSource <NSObject>

/// Cell 赋值方法
/// @param data data
- (void)rw_setData:(id)data;

@end

#endif /* RWCellDataSourceProtocol_h */
