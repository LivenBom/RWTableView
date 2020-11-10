//
//  UIResponder+RWEvent.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import <UIKit/UIKit.h>
#import "RWEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (RWEvent)

- (void)respondEvent:(NSObject<RWEvent> *)event;

@end

NS_ASSUME_NONNULL_END
