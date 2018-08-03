# DNSheetAlertView 一种精简的底部弹窗    

使用：    

1.将 DNSheetAlert 文件夹拖入工程文件夹，并添加 [Masonry]:https://github.com/SnapKit/Masonry     

2.导入头文件 #import "DNSheetAlert.h"    

3.具体使用支持一维数组和二维数组（即有取消和无取消）    
  <pre><code>[[DNSheetAlert shareInstance] alertWithData:@[@[@"相机",@"从相册选取"],@[@"取消"]] Delegate:self];</code></pre>    
  <pre><code>[[DNSheetAlert shareInstance] alertWithData:@[@"相机",@"从相册选取"] Delegate:self];</code></pre>
  

4.使用 DNSheetAlertDelegate 代理方法回调点击事件    

