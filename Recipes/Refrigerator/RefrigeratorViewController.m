//
//  RefrigeratorViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RefrigeratorViewController.h"
#import "FoodTableViewController.h"
#import "AddFoodViewController.h"
#import "RecipesTableViewController.h"
#import "RecipersRecomendHelper.h"
#import "RecommendingViewController.h"
@interface RefrigeratorViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topMenuScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (weak, nonatomic) IBOutlet UIButton *choseThoseFoodBtn;

@property (nonatomic,weak) UIButton *currentItemBtn;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *selectedFoods;
@end

@implementation RefrigeratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedFoods = [[NSMutableArray alloc]init];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    
    self.currentItemBtn = btn;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customChildVC];
    
    [self addNotiObser];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)addNotiObser{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedFoodNoti:) name:kSelectedFoodNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deSelectedFoodNoti:) name:kDeSelectedFoodNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewFoodNoti:) name:kHaveAddOneFoodNoti object:nil];
    
    //监听食材的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeleteFoodNoti:) name:kFoodTableChangedNoti object:nil];;
}


-(void)receiveDeleteFoodNoti:(NSNotification *)noti{
    FoodModel *food = noti.object;
    [self.dataSource enumerateObjectsUsingBlock:^(FoodModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (food.foodid == obj.foodid ) {
            *stop = YES;
            [self.dataSource removeObject:obj];
        }
    }];
    for (FoodTableViewController *fvc in self.childViewControllers) {
        NSLog(@"fvc.foodType =%ld",(long)fvc.foodType);
        if (fvc.foodType == food.species) {//是这个抽屉里食材的类型
            //跟新这个类型的数据
            [fvc refreshData];
        }
    }
}
/**
 选择了一个食材

 @param noti 通知
 */
-(void)selectedFoodNoti:(NSNotification *)noti{
    [self.selectedFoods addObject:noti.object];
    NSLog(@"选中了食物%@",noti.object);
    [self updateChoseFoodCount];
}

/**
 选择了一个食材
 
 @param noti 通知
 */
-(void)deSelectedFoodNoti:(NSNotification *)noti{
    [self.selectedFoods removeObject:noti.object];
    NSLog(@"取消选中了食物%@",noti.object);
    [self updateChoseFoodCount];
}

/**
 接收到添加新的食材到冰箱了
 
 @param noti 通知
 */
-(void)addNewFoodNoti:(NSNotification *)noti{
    FoodModel *food = noti.object;
        NSLog(@"收到通知:新添加了食物%@ ",noti.object);
    [self.dataSource addObject:food];
    for (FoodTableViewController *fvc in self.childViewControllers) {
        NSLog(@"fvc.foodType =%ld",(long)fvc.foodType);
        if (fvc.foodType == food.species) {//是这个抽屉里食材的类型
            //跟新这个类型的数据
            [fvc refreshData];
        }
    }
}

/**
 更新已选食物的状态
 */
-(void)updateChoseFoodCount{
    if (self.selectedFoods.count>0) {
        self.choseThoseFoodBtn.enabled = YES;
        NSString *choseTitle = [NSString stringWithFormat:@"选好了(%ld)",self.selectedFoods.count];
        [self.choseThoseFoodBtn setTitle:choseTitle forState:UIControlStateNormal];
    }else{
        self.choseThoseFoodBtn.enabled = NO;
        [self.choseThoseFoodBtn setTitle:@"请选择食材" forState:UIControlStateNormal];
    }
    
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [DataBaseManager defaultManager].foodsInRefigerator;
    }
    return _dataSource;
}

/**
 请求食材的数据
 */
-(void)reQueryFoodDatas{
//     self.dataSource = [NSMutableArray arrayWithArray:[[DataBaseManager defaultManager]quryAllFoodsInRefigerator]];
    [self.childViewControllers enumerateObjectsUsingBlock:^(FoodTableViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [obj refreshData];
        }
    }];
}


- (IBAction)onAddFoodClick:(id)sender {
    AddFoodViewController *addvc = [[AddFoodViewController alloc]initWithNibName:@"AddFoodViewController" bundle:nil];
    [self.navigationController pushViewController:addvc animated:YES];
}


/**
 点击推荐菜单

 @param sender 按钮
 */
- (IBAction)onRecommend:(UIButton *)sender {
    RecommendingViewController *ring = [[RecommendingViewController alloc]initWithNibName:@"RecommendingViewController" bundle:nil];
    ring.view.frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height);
    [self.tabBarController.view addSubview:ring.view];
    
    //找出选择的食材能做的菜单
    
    NSArray *cotainRecs = [RecipersRecomendHelper recipesCotainFoods:self.selectedFoods];
    NSArray *canMakeRecs = [RecipersRecomendHelper findCanMakeByRefifoodsWithRecipes:cotainRecs];
    if (canMakeRecs.count==0) {
        dispatch_after(1.0, dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"无法给出菜谱" message:@"根据您选择的食材，和冰箱里现有的食材，并不能做出来一道菜" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alv show];
        });
      
    }else{
        dispatch_after(1.0, dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            RecipesTableViewController *rectv = [sb instantiateViewControllerWithIdentifier:@"RecipesTableViewController"];
            
            rectv.dataSource = [NSMutableArray arrayWithArray:canMakeRecs];
            [self.navigationController pushViewController:rectv animated:YES];
        });
        
    }
    
    
    /*
    
    //根据选择的食材，推荐生成一个菜谱
    RecipesModel *receip = [RecipersRecomendHelper recommendRecipWithFoods:self.selectedFoods];
    
    if (receip) {//成功推荐了菜谱
        RecipesDetailViewController *recipesDetailVC = [[RecipesDetailViewController alloc]initWithNibName:@"RecipesDetailViewController" bundle:nil];
        recipesDetailVC.recipe = receip;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            [self.navigationController pushViewController:recipesDetailVC animated:YES];
        });
    }else{//推荐失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            [ring.view removeFromSuperview];
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"找不到该所选食材的做法" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alv show];
        });
        
    }
    */
}


/**
 定制各种食材的界面
 */
-(void)customChildVC{
    NSArray *types = @[@1,@4,@2,@3,@5];
    for (NSInteger i=0; i<5; i++) {
        
        FoodTableViewController *fdVC = [[FoodTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [self addChildViewController:fdVC];
        fdVC.foodType = ((NSNumber *)types[i]).integerValue;
        fdVC.allFoods = self.dataSource;
        fdVC.view.frame = CGRectMake(i*YYScreenSize().width, 0, YYScreenSize().width, YYScreenSize().height-64-49-50);
        [self.bodyScrollView addSubview:fdVC.view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*60, -60, 60, 50);
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitle:[fdVC foodStringOfType:i] forState:UIControlStateNormal];
        [btn setTitle:[fdVC foodStringOfType:i] forState:UIControlStateSelected];
        [self.topMenuScrollView addSubview:btn];
    }
    self.bodyScrollView.contentSize = CGSizeMake(YYScreenSize().width*5, 0);
    self.topMenuScrollView.contentSize = CGSizeMake(60*5, 0);
    self.bodyScrollView.delegate = self;
}

- (IBAction)onItmClick:(UIButton *)sender {
    self.currentItemBtn.selected = NO;
    self.currentItemBtn = sender;
    sender.selected = YES;
    [self.bodyScrollView setContentOffset:CGPointMake((sender.tag-100)*YYScreenSize().width, 0) animated:YES];
}

#pragma mark --scrollView的代理方式
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/YYScreenSize().width;
    if (index == self.currentItemBtn.tag-100) {
        return;
    }
    self.currentItemBtn.selected = NO;
    UIButton *btn = (UIButton *)[self.view viewWithTag:index+100];
    btn.selected = YES;
    self.currentItemBtn = btn;
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
