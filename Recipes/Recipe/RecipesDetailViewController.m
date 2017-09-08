//
//  RecipesDetailViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipesDetailViewController.h"
#import "RecipHeaderView.h"
#import "RecipDetailTableViewCell.h"
@interface RecipesDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)RecipHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *topDatas;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation RecipesDetailViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)topDatas
{
    if (!_topDatas) {
        _topDatas = [[NSMutableArray alloc]init];
    }
    return _topDatas;
}
-(RecipHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"RecipHeaderView" owner:self options:nil] lastObject];
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =self.recipe.name;
//    self.navigationController.navigationItem.title =self.recipe.name;
//    self.navigationController.title = self.recipe.name;
    // Do any additional setup after loading the view.
    [self.topDatas addObject:@"主食材："];
    for (NSString *name in self.recipe.ingredients) {
//        [self.topDatas addObject:@" "];
        [self.topDatas addObject: [self getShowStrOfFoodName:name]];
    }
    [self.topDatas addObject:[NSString stringWithFormat:@"调味：\n    %@",self.recipe.seasoning]];
    [self.topDatas addObject:@""];
    
    for (NSString *step in self.recipe.steps) {
        [self.dataSource addObject:@" "];
        [self.dataSource addObject:step];
    }
    [self.dataSource addObject:@" "];
    [self.dataSource addObject:@" "];
    [self customTableView];
    
    [self custonNavi];
}

/**
 tableview初始化
 */
-(void)customTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipDetailTableViewCell"];
    
    self.headerView .frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().width);
    self.headerView.imgView.image = [UIImage imageNamed:self.recipe.name];
    self.headerView.nameLabel.text = self.recipe.name;
    self.tableView.tableHeaderView = self.headerView;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section ==0?self.topDatas.count:self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipDetailTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section ==0) {
        cell.titleLabel.text = self.topDatas[indexPath.row];
//        if (indexPath.row == 0) {
//            cell.titleLabel.text = self.topDatas[indexPath.row];
//            
//        }else if (indexPath.row == self.recipe.ingredients.count+1){
//            cell.titleLabel.text = self.recipe.seasoning;
//        }else{
//            NSString *text = [self getShowStrOfFoodName:self.recipe.ingredients[indexPath.row-1]];
////            [NSString stringWithFormat:@"%@:%@",indexPath.row+1,self.recipe.ingredients[indexPath.row-1],[self getShowStrOfFoodName:<#(NSString *)#>]];
//            cell.titleLabel.text = text;
//        }
    }else{
        NSString *showStr = self.dataSource[indexPath.row];
        if (showStr.length>2) {
             showStr = [NSString stringWithFormat:@"%ld:%@",indexPath.row+1,showStr];
        }
        
        cell.titleLabel.text = showStr;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0.1:30;
}
-(NSString *)getShowStrOfFoodName:(NSString *)foodName{
    FoodModel *food = [self.recipe getfoodModelWithFoodName:foodName];
    NSString *str = [NSString stringWithFormat:@"    %@:%d%@",food.name,[food.unit isEqualToString:@"克"]?100:1,food.unit];
    return str;
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
