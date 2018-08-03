# DNSheetAlertView 一种精简的底部弹窗    

使用：    

1.将 DNSheetAlert 文件夹拖入工程文件夹，并添加 Masonry     

2.导入头文件 #import "DNSheetAlert.h"    

3.[[DNSheetAlert shareInstance] alertWithData:@[@[@"相机",@"从相册选取"],@[@"取消"]] Delegate:self];    

4.使用 DNSheetAlertDelegate 代理方法回调点击事件    

