//
//  HomeTableViewCell.h
//  Recipes
//
//  Created by 薛永伟 on 2017/9/7.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *flagImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (nonatomic,strong) FoodModel *food;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) void(^clickDeleteBtn)(FoodModel *model);
/**
 设置数据

 @param model 数据模型
 @param indexPath 下标
 */
-(void)setModel:(FoodModel *)model AtIndexPath:(NSIndexPath *)indexPath;
@end
