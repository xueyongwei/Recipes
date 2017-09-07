//
//  RecipTableViewCell.h
//  Recipes
//
//  Created by 薛永伟 on 2017/9/4.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
