//
//  OnkeyRecipesView.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "OnkeyRecipesView.h"

@implementation OnkeyRecipesView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.onkeyBtn.layer.cornerRadius = YYScreenSize().width*0.3;
}
- (IBAction)onOnekeyClick:(UIButton *)sender {
    [self.viewController performSegueWithIdentifier:@"PushRecipesDetailViewController" sender:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
