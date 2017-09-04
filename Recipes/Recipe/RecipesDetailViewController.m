//
//  RecipesDetailViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipesDetailViewController.h"

@interface RecipesDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecipesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = self.recipe.name;
    // Do any additional setup after loading the view.
    [self customTableView];
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipe.steps.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSString *text = [NSString stringWithFormat:@"%ld:%@",indexPath.row+1,self.recipe.steps[indexPath.row]];
    cell.textLabel.text = text;
    return cell;
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
