//
//  UIResponder+RWEvent.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "UIResponder+RWEvent.h"

@implementation UIResponder (RWEvent)

- (void)respondEvent:(NSObject<RWEvent> *)event {
    [self.nextResponder respondEvent:event];
}

@end
