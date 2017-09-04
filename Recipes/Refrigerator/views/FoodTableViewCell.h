//
//  FoodTableViewCell.h
//  Recipes
//
//  Created by 薛永伟 on 2017/9/4.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jLabel;

@end
