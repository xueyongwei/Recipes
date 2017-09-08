//
//  HomeTableViewCell.m
//  Recipes
//
//  Created by 薛永伟 on 2017/9/7.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
-(void)setModel:(FoodModel *)model AtIndexPath:(NSIndexPath *)indexPath
{
    _food = model;
    _indexPath = indexPath;
    self.flagImgView.enabled = model.remainingDays<1;
    if (self.flagImgView.enabled) {
        [self.flagImgView setImage:[UIImage imageNamed:@"didExp"] forState:UIControlStateNormal];
    }else{
        [self.flagImgView setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)onDeleteClick:(UIButton *)sender {
    if (self.clickDeleteBtn) {
        self.clickDeleteBtn(self.food);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
