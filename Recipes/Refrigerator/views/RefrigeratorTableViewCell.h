//
//  RefrigeratorTableViewCell.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
@interface RefrigeratorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *naleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *flagImgView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkImgView;
@property (nonatomic,strong) void(^clickDeleteBtn)(FoodModel *model);
@property (nonatomic,strong) FoodModel *food;
@end
