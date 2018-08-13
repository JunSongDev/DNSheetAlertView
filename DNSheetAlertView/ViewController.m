//
//  ViewController.m
//  DNSheetAlertView
//
//  Created by zjs on 2018/8/2.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ViewController.h"
#import "DNSheetAlert.h"

@interface ViewController ()<DNSheetAlertDelegate>
- (IBAction)jumpButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)jumpButton:(id)sender {
    
    [[DNSheetAlert shareInstance] alertWithData:@[@[@"相机",@"从相册选取"],@[@"取消"]] Delegate:self];
}

- (void)dnSheetAlertSelectedIdentifier:(NSString *)identifier selectIndex:(NSIndexPath *)selectIndex {
    
    NSLog(@"%@---%ld--%ld",identifier, (long)selectIndex.section, (long)selectIndex.row);
}
@end
