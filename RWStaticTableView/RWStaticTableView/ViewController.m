//
//  ViewController.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/5.
//

#import "ViewController.h"
#import "RWTableView.h"
#import "RWTestCellViewModel.h"
#import "RWButtonCellViewModel.h"
#import "UIResponder+RWEvent.h"

@interface ViewController ()<RWTableViewDelegate>
@property (nonatomic, strong) RWTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    RWTestCellViewModel *item1 = [[RWTestCellViewModel alloc]init];
    item1.title = @"我是大力";
    item1.headerImage = [UIImage imageNamed:@"11.jpg"];
    
    RWTestCellViewModel *item2 = [[RWTestCellViewModel alloc]init];
    item2.title = @"我是大力2";
    item2.headerImage = [UIImage imageNamed:@"11.jpg"];
    
    RWTestCellViewModel *item3 = [[RWTestCellViewModel alloc]init];
    item3.title = @"我是大力3";
    item3.headerImage = [UIImage imageNamed:@"11.jpg"];
    
    RWButtonCellViewModel *item4 = [[RWButtonCellViewModel alloc]init];
    
    RWSectionModel *section1 = [[RWSectionModel alloc]init];
    section1.sectionHeaderHeight  = 100;
    
    RWSectionModel *section2 = [[RWSectionModel alloc]init];
    section2.sectionHeaderHeight = 50;
    
    RWSectionModel *section3 = [[RWSectionModel alloc]init];
    section3.sectionHeaderHeight = 50;
    
    [section1.itemsArray addObject:item1];
    [section1.itemsArray addObject:item2];
    [section2.itemsArray addObject:item3];
    [section3.itemsArray addObject:item4];
    
    self.dataArray = @[section1,section2,section3];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)respondEvent:(NSObject<RWEvent> *)event {
    if ([event.sender isKindOfClass:UITableViewCell.class]) {
        NSLog(@"%@",event.userInfo);
    }
}

#pragma mark - RWTableView Delegate
- (NSArray<RWSectionModel *> *)tableViewWithMutilSectionDataArray {
    return self.dataArray;
}

- (void)tableViewDidSelectedCellWithDataModel:(id)data indexPath:(NSIndexPath *)indexPath {
    NSLog(@"section:%ld row:%ld 被点击了",indexPath.section,indexPath.row);
}


#pragma mark - Getter
- (RWTableView *)tableView {
    if (!_tableView) {
        _tableView = [[RWTableView alloc]initWithDelegate:self];
        _tableView.rwdelegate = self;
    }
    return _tableView;
}

@end
