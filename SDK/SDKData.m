//
//  SDKData.m
//  SDK
//
//  Created by Cer on 2018/11/7.
//  Copyright © 2018 Cer. All rights reserved.
//

#import "SDKData.h"
#import <UIKit/UIKit.h>

@implementation SDKData

- (void)show
{
    NSBundle *resourceBundle = [NSBundle bundleForClass:[self class]]; // 获取类所在的bundle
    NSString *bundlePath = [resourceBundle pathForResource:@"SDK" ofType:@"bundle"]; // 获取资源bundle路径
    
    // 方式1 直接拼路径
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"user.jpg"];
    
    // 方式2 通过获取bundle来操作
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
//    NSString *imagePath = [bundle pathForResource:@"user.jpg" ofType:nil];
//    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    // 方式3 通过传入bundle来获取数据
    UIImage *image = [UIImage imageNamed:@"user.jpg" inBundle:bundle compatibleWithTraitCollection:nil];

    NSLog(@"bundlePath = %@   resourceBundle = %@  imagePath = %@  bundle = %@", bundlePath, resourceBundle, imagePath, bundle);
    NSLog(@"%s  image = %@", __func__, image);
    
    return;
}

@end
