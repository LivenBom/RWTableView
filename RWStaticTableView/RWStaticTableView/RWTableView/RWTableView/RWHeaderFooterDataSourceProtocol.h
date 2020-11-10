//
//  RWHeaderFooterDataSourceProtocol.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/9.
//

#ifndef RWHeaderFooterDataSourceProtocol_h
#define RWHeaderFooterDataSourceProtocol_h

@protocol RWHeaderFooterDataSource <NSObject>

/// Cell 赋值方法
/// @param data data
- (void)rw_setData:(id)data;

@end

#endif /* RWHeaderFooterDataSourceProtocol_h */
