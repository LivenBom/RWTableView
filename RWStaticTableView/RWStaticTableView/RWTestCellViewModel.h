//
//  RWTestCellViewModel.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import <Foundation/Foundation.h>
#import "RWCellViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWTestCellViewModel : NSObject<RWCellViewModel>
@property (nonatomic, copy ) NSString *title;
@property (nonatomic, strong) UIImage *headerImage;
@end

NS_ASSUME_NONNULL_END
