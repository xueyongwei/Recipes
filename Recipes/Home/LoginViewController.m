//
//  LoginViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/9/7.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomconst;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duraValue =[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomconst.constant = -height/2;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:duraValue.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
   
    NSNumber *duraValue =[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.bottomconst.constant = 0;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:duraValue.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginClick:(UIButton *)sender {
    if (_tf1.text.length<1) {
        CoreSVPCenterMsg(@"请输入用户名");
        return;
    }
    if (_tf2.text.length<1) {
        CoreSVPCenterMsg(@"请输入密码");
        return;
    }
    CoreSVPLoading(@"正在登录..", NO);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CoreSVP dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
