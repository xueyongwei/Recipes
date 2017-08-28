//
//  RefrigeratorViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RefrigeratorViewController.h"
#import "FoodTableViewController.h"
@interface RefrigeratorViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topMenuScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;

@property (nonatomic,weak) UIButton *currentItemBtn;
@end

@implementation RefrigeratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    
    self.currentItemBtn = btn;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customChildVC];
    
    // Do any additional setup after loading the view.
}
-(void)customChildVC{
    for (NSInteger i=0; i<5; i++) {
        
        FoodTableViewController *fdVC = [[FoodTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [self addChildViewController:fdVC];
        fdVC.foodType = i;
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
    self.bodyScrollView.contentSize = CGSizeMake(YYScreenSize().width*4, 0);
    self.topMenuScrollView.contentSize = CGSizeMake(60*4, 0);
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
