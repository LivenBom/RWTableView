//
//  RWEvent.h
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIResponder;

@protocol RWEvent <NSObject>
@property (nonatomic, strong) __kindof UIResponder *sender;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@end


@interface RWEvent : NSObject<RWEvent>

@end



NS_ASSUME_NONNULL_END
