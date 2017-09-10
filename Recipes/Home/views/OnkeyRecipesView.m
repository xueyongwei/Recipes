//
//  OnkeyRecipesView.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "OnkeyRecipesView.h"
#import "RecipesManager.h"
#import "RecommendingViewController.h"
#import "RecipesDetailViewController.h"
#import "RecipersRecomendHelper.h"

@implementation OnkeyRecipesView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.onkeyBtn.layer.cornerRadius = YYScreenSize().width*0.3;
}
- (IBAction)onOnekeyClick:(UIButton *)sender {
    //检查冰箱中是否有食材
    if ([DataBaseManager defaultManager].foodsInRefigerator.count==0) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"冰箱中没有食材！" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alv show];
        return;
    }
    //智能分析冰箱中的食材，并生成菜单
    RecommendingViewController *ring = [[RecommendingViewController alloc]initWithNibName:@"RecommendingViewController" bundle:nil];
    ring.view.frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height);
    [self.viewController.tabBarController.view addSubview:ring.view];
    
    //根据选择的食材，推荐生成一个菜谱
    RecipesModel *receip = [RecipersRecomendHelper recommendRecipWithIntelligentAnalysis];
    if (receip) {//成功推荐了菜谱
        RecipesDetailViewController *recipesDetailVC = [[RecipesDetailViewController alloc]initWithNibName:@"RecipesDetailViewController" bundle:nil];
        recipesDetailVC.recipe = receip;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            [self.viewController.navigationController pushViewController:recipesDetailVC animated:YES];
        });
    }else{//推荐失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ring.view removeFromSuperview];
            [ring.view removeFromSuperview];
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"无法给出推荐菜单" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alv show];
        });
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
