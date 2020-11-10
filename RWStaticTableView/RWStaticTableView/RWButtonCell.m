//
//  RWButtonCell.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWButtonCell.h"
#import "UIResponder+RWEvent.h"

@implementation RWButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth - 200, 0, 200, 44);
    btn.backgroundColor = UIColor.greenColor;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
}

- (void)btnAction {
    NSLog(@"我被点了");
    
    RWEvent *event = [[RWEvent alloc]init];
    event.sender = self;
    [event.userInfo setObject:@"我被点击了" forKey:@"btn"];
    [self.nextResponder respondEvent:event];
}

- (void)rw_setData:(id)data {
    self.backgroundColor = UIColor.lightGrayColor;
}

@end
