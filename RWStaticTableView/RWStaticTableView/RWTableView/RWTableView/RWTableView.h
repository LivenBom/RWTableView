//
//  RWTableView.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import <UIKit/UIKit.h>
#import "RWCellViewModelProtocol.h"
#import "RWSectionModel.h"

@protocol RWTableViewDelegate;

@interface RWTableView : UITableView
/// rwdelegate
@property (nonatomic, weak) id<RWTableViewDelegate> rwdelegate;

/// 构建方法
/// @param delegate 是指rwdelegate
/// 默认是UITableViewStylePlain
- (instancetype)initWithDelegate:(id<RWTableViewDelegate>)delegate;


/// 初始化
/// @param delegate rwdelegate
/// @param style UITableViewStyle
- (instancetype)initWithDelegate:(id<RWTableViewDelegate>)delegate
                  tableViewStyle:(UITableViewStyle)style;

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
@end

