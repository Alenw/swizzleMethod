//
//  UIViewController+AOP.m
//  Localization
//
//  Created by soyoung on 16/1/4.
//  Copyright © 2016年 RW. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/runtime.h>

@implementation UIViewController (AOP)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class=[self class];
        swizzleMethod(class,@selector(viewDidLoad),@selector(aop_viewDidLoad));
#pragma 界面即将显示
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
//        swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
#pragma 界面即将消失
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
//        swizzleMethod(class, @selector(viewDidDisappear:), @selector(aop_viewDidDisappear:));
    });
    
   
}
void swizzleMethod(Class class,SEL originalSelector,SEL swizzledSelector){
    Method originalMethod=class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod=class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
-(void)aop_viewDidLoad{
    [self aop_viewDidLoad];
    NSLog(@"viewDidLoad :%@",NSStringFromClass([self class]));
}

-(void)aop_viewWillAppear:(BOOL)animated{
    [self aop_viewWillAppear:animated];
    
}
//-(void)aop_viewDidAppear:(BOOL)animated{
//    [self aop_viewDidAppear:animated];
//#warning 填写附加的代码
//}

-(void)aop_viewWillDisappear:(BOOL)animated{
    [self aop_viewWillDisappear:animated];

}
//-(void)aop_viewDidDisappear:(BOOL)animated{
//    [self aop_viewDidDisappear:animated];
//#warning 填写附加的代码
//}
@end
