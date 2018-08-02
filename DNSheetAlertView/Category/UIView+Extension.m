//
//  UIView+Extension.m
//  163Music
//
//  Created by zjs on 2018/7/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)dn_x{
    
    return self.frame.origin.x;
}
- (void)setDn_x:(CGFloat)dn_x{
    
    CGRect frame = self.frame;
    frame.origin.x = dn_x;
    self.frame = frame;
}

- (CGFloat)dn_y{
    
    return self.frame.origin.y;
}

- (void)setDn_y:(CGFloat)dn_y{
    
    CGRect frame = self.frame;
    frame.origin.y = dn_y;
    self.frame = frame;
}

- (CGFloat)dn_right{
    
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setDn_right:(CGFloat)dn_right{
    
    CGRect frame = self.frame;
    frame.origin.x = dn_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dn_bottom{
    
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setDn_bottom:(CGFloat)dn_bottom{
    
    CGRect frame = self.frame;
    
    frame.origin.y = dn_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)dn_width{
    
    return self.frame.size.width;
}
- (void)setDn_width:(CGFloat)dn_width{
    
    CGRect frame = self.frame;
    frame.size.width = dn_width;
    self.frame = frame;
}

- (CGFloat)dn_height{
    
    return self.frame.size.height;
}
- (void)setDn_height:(CGFloat)dn_height{
    
    CGRect frame = self.frame;
    frame.size.height = dn_height;
    self.frame = frame;
}


- (CGFloat)dn_centerX{
    
    return self.center.x;
}
- (void)setDn_centerX:(CGFloat)dn_centerX{
    
    self.center = CGPointMake(dn_centerX, self.center.y);
}

- (CGFloat)dn_centerY{
    
    return self.center.y;
}
- (void)setDn_centerY:(CGFloat)dn_centerY{
    
    self.center = CGPointMake(self.center.x, dn_centerY);
}

- (CGPoint)dn_origin{
    
    return self.frame.origin;
}
- (void)setDn_origin:(CGPoint)dn_origin{
    
    CGRect frame = self.frame;
    frame.origin = dn_origin;
    self.frame = frame;
}

- (CGSize)dn_size{
    
    return self.frame.size;
}
- (void)setDn_size:(CGSize)dn_size{
    
    CGRect frame = self.frame;
    frame.size = dn_size;
    self.frame = frame;
}

// 创建屏幕快照
- (UIImage *)dn_createSnapshotImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)dn_createSnapshotPDF {
    
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

// 设置阴影
- (void)dn_setLayerShadowColor:(UIColor *)color offset:(CGSize)offset shadowRadius:(CGFloat)radius {
    
    self.layer.shadowColor        = color.CGColor;
    self.layer.shadowOffset       = offset;
    self.layer.shadowRadius       = radius;
    self.layer.shadowOpacity      = 1;
    self.layer.shouldRasterize    = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
