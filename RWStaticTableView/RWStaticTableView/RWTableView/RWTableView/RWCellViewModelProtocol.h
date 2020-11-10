//
//  RWCellViewModel.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

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
