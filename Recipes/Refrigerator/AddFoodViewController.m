//
//  AddFoodViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "AddFoodViewController.h"
#import "DataBaseManager.h"
#import "FoodTableViewCell.h"
@interface AddFoodViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *datas;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation AddFoodViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"FoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.rowHeight = 50;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加食材";
    [self custonNavi];
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
   
    
    [self prepareData];
  
    // Do any additional setup after loading the view from its nib.
}
/**
 自定义导航
 */
-(void)custonNavi{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = -10;
    self.navigationItem.leftBarButtonItems = @[fix,itm];
}

/**
 返回到上一层
 */
-(void)backHandle{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareData{
//    NSArray *data =  [DataBaseManager defaultManager].allFoods;
//    NSLog(@"%@",data);
//    self.datas = [NSMutableArray arrayWithArray:data];
    self.datas = [DataBaseManager defaultManager].allFoods;
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        FoodModel *food = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = food.name;
        return cell;
    } else {
        FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodTableViewCell"];
        FoodModel *food = [self.datas objectAtIndex:indexPath.row];
        cell.nameLabel.text = food.name;
        cell.imgView.image = [UIImage imageNamed:food.name];
        cell.jLabel.text = [NSString stringWithFormat:@"能量:%ldJ",food.calorie];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
        FoodModel *food = self.results[indexPath.row];
        [self wannaAddFood:food];
    } else {
        FoodModel *food = self.datas[indexPath.row];
        [self wannaAddFood:food];
        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
    }
}
-(void)wannaAddFood:(FoodModel *)food
{
    NSString *message = [NSString stringWithFormat:@"添加多少%@?",food.unit];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:food.name message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //更新这个食材的信息
        food.amount =  alert.textFields.firstObject.text.floatValue;
        food.putRefDate = [NSDate date];
        //放入冰箱新本地数据库
        [food putIntoRefiAndUpdateDataBase];
        //发个通知，添加进了一个食材到冰箱里
        [[NSNotificationCenter defaultCenter] postNotificationName:kHaveAddOneFoodNoti object:food];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alert addAction:sure];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //输入的文字
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //把包含输入文字的食物放到搜索结果数组里
    for (FoodModel *food in self.datas) {
        if ([food.name.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            [self.results addObject:food];
        }
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
