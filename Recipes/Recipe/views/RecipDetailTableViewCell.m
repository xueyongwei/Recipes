//
//  RecipDetailTableViewCell.m
//  Recipes
//
//  Created by xueyognwei on 2017/9/8.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipDetailTableViewCell.h"

@implementation RecipDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
