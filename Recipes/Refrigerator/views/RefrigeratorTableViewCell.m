//
//  RefrigeratorTableViewCell.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/27.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RefrigeratorTableViewCell.h"

@implementation RefrigeratorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
-(void)setFood:(FoodModel *)food
{
    _food = food;
    self.naleLabel.text = food.name;
    self.amountLabel.text = [NSString stringWithFormat:@"%.1f%@",food.amount,food.unit];
    if (food.remainingDays<3) {
        self.flagImgView.hidden = NO;
        [self.flagImgView setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
//        self.flagImgView.image = [UIImage imageNamed:@"warning"];
        if (food.remainingDays<0) {
            [self.flagImgView setImage:[UIImage imageNamed:@"didExp"] forState:UIControlStateNormal];
//            self.flagImgView.image = [UIImage imageNamed:@"didExp"];
        }
    }else{
        self.flagImgView.hidden = YES;
    }
    self.expDayLabel.text =  [self maxDay];
    self.imgView.image = [UIImage imageNamed:food.name];
}
- (IBAction)onDeleteClick:(UIButton *)sender {
    if (self.clickDeleteBtn) {
        self.clickDeleteBtn(self.food);
    }
}


-(NSString *)maxDay{
    //过期的日期
    NSInteger  remainDays = [self.food remainingDays];
    if (self.food.remainingDays<0) {
        return @"已过期";
    }
    return [NSString stringWithFormat:@"%ld天",(long)remainDays];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkImgView.selected = selected;
    // Configure the view for the selected state
}

@end
