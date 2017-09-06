//
//  MainNavigationController.m
//  YouxiniFood
//
//  Created by youxin on 2017/7/26.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "MainNavigationController.h"


@interface MainNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController

/**
 只加载一次
 */
+(void)load
{
    //设置bar字体
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    dict[NSForegroundColorAttributeName] =  [UIColor greenColor];
    [bar setTitleTextAttributes:dict];
   
    //设置bar背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"Rectangle 5"] forBarMetrics:UIBarMetricsDefault];
    
    //设置item的字体和颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
    itemDict[NSForegroundColorAttributeName] = [UIColor greenColor];
    itemDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:itemDict forState:UIControlStateNormal];
    
    NSMutableDictionary *itemDisableDict = [NSMutableDictionary dictionary];
    itemDisableDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisableDict  forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    //全屏滑动手势
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
//    
//    pan.delegate = self;
//    //禁止之前的手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//    [self.view addGestureRecognizer:pan];
//    //导航栏颜色
    self.navigationBar.barTintColor =  [UIColor greenColor];
//   ;
    
    //平移返回上级页面
    [self panBackUpPage];
    
}

- (void)panBackUpPage{
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//此方法拖拽过快 导航栏容易遮挡
        if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }else{
    
        return YES;
    }
    
    
    // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
//
//    if(self.visibleViewController == self.viewControllers[0]){
//        
//        return NO;
//        
//    }else{
//        
//    // 判断pan手势的各个阶段
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            // 开始拖拽阶段
//           return NO;
//            break;
//            
//        case UIGestureRecognizerStateEnded:
//            // 结束拖拽阶段
//            return YES;
//            break;
//            
//        default:
//            // 正在拖拽阶段
//         return NO;
//            break;
//    }
//   
//    }
    
}
//消除方法警告
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
{
    
}


#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //是否出发手势
    return self.childViewControllers.count > 1;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {//非根控制器
        //影藏BottomBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        //返回按钮自定义
        viewController.navigationItem.leftBarButtonItem = [self backItemWithImage:[UIImage imageNamed:@"icon_houtui"] WithHighlightedImage:[UIImage imageNamed:@"icon_houtui"] Target:self action:@selector(backViewController) title:@" "];
        
    }
    //跳转(自定义以后在这里真正跳转)
    [super pushViewController:viewController animated:animated];
}


-(void)backViewController
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem *)backItemWithImage:(UIImage *)image WithHighlightedImage:(UIImage *)HighlightedImage Target:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:HighlightedImage forState:UIControlStateHighlighted];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -20);
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
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
