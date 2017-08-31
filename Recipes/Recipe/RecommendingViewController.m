//
//  RecommendingViewController.m
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecommendingViewController.h"

@interface RecommendingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RecommendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSMutableArray *images = [[NSMutableArray alloc]init];;
//    
//    for (NSInteger i = 24; i<127; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",i]];
//        [images addObject:image];
//    }
//    self.imageView.animationImages = images;
//    self.imageView.animationRepeatCount = 1;
//    self.imageView.animationDuration = 3;
//    [self.imageView startAnimating];
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
