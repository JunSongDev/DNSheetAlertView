//
//  DNSheetAlert.m
//  163Music
//
//  Created by zjs on 2018/7/31.
//  Copyright © 2018年 zjs. All rights reserved.
//


// 屏幕宽高
#define SCREEN_W    [UIScreen mainScreen].bounds.size.width
#define SCREEN_H    [UIScreen mainScreen].bounds.size.height
//IphoneX适配
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#import "DNSheetAlert.h"
#import "UIView+Extension.h"
#import <Masonry.h>


@interface DNSheetAlert ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    UIView    *lineView;
    NSInteger alert_W;
    NSInteger alert_H;
}
/** 标题数组 */
@property (nonatomic,   copy) NSArray * titleArray;

/** 颜色数组 */
@property (nonatomic,   copy) NSArray * colorArray;

/** 包含 tableView 的 view */
@property (nonatomic, strong) UIView  * containView;

/** tableView */
@property (nonatomic, strong) UITableView * tableView;

/** 是否为数组 */
@property (nonatomic, assign, getter=isDataArr) BOOL dataArr;
@end

static DNSheetAlert * _sheetAlert = nil;

@implementation DNSheetAlert
// 单例创建
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sheetAlert) {
            _sheetAlert = [[self alloc] init];
        }
    });
    return _sheetAlert;
}
// 重写 allocWithZone:
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sheetAlert) {
            _sheetAlert = [super allocWithZone:zone];
        }
    });
    return _sheetAlert;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sheetAlert;
}
// 创建方法
- (void)alertWithData:(NSArray *)data Delegate:(id<DNSheetAlertDelegate>)delegate {
    
    self.titleArray = data;
    self.delegate = delegate;
    [self dn_showAlertSheet];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        // 添加单击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dn_dismissAlertSheet)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
// 添加控件
- (void)setControlForSuper {
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    [self addSubview:self.containView];
    [self.containView addSubview:self.tableView];
    [self.containView addSubview:lineView];
}
// 添加约束
- (void)addConstraintsForSuper {
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.mas_equalTo(self);
        if (self.isDataArr) {
            make.height.mas_offset(170+HOME_INDICATOR_HEIGHT);
        }
        else {
            make.height.mas_offset(110+HOME_INDICATOR_HEIGHT);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_equalTo(self.containView);
        make.bottom.mas_equalTo(self.containView.mas_bottom).inset(HOME_INDICATOR_HEIGHT);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.containView.mas_top).inset(55);
        make.left.right.mas_equalTo(self.containView).inset(5);
        make.height.mas_equalTo(@0.8);
    }];
    // 获取 containView 的高度
    alert_H = self.containView.dn_height;
}

#pragma mark - UIGestureRecognizerDelegate
// 解决 tap 手势和 tableViewCell 点击的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark -- UITableView Delegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.isDataArr ? self.titleArray.count:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.isDataArr ? [self.titleArray[section] count]:self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNSheetAlertCell * cell = [tableView dequeueReusableCellWithIdentifier:@"alertCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[DNSheetAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alertCell"];
    }
    cell.textLabel.text = self.isDataArr ? self.titleArray[indexPath.section][indexPath.row]:self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 点击 cell 使用代理传递点击事件
    DNSheetAlertCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(dnSheetAlertSelectedIdentifier:selectIndex:)]) {
            
        [_delegate dnSheetAlertSelectedIdentifier:cell.textLabel.text selectIndex:indexPath];
    }
    // 消失
    [self dn_dismissAlertSheet];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * head = [[UIView alloc] init];
    head.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0.01:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

///===============================================================
///===============================================================

// 显示动画
- (void)dn_showAlertSheet {
    
    CATransition *transition = [CATransition animation];
    // 动画时长
    transition.duration = 0.35f;
    // 动画类型
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.containView.layer addAnimation:transition forKey:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
// 消失动画
- (void)dn_dismissAlertSheet {
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.containView.frame = CGRectMake(0, SCREEN_H-self->alert_H, SCREEN_W, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.containView removeFromSuperview];
    }];
}

///===============================================================
///===============================================================

- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    // 判断 titleArray 是否为空
    if (titleArray.count != 0) {
        // 遍历数组
        for (int i = 0; i < titleArray.count; i++) {
            // 判断数组元素是否为 NSArray
            if ([titleArray[i] isKindOfClass:[NSArray class]]) {
                
                self.dataArr = YES;
            }
            // 判断数组元素是否为 NSString
            else if ([titleArray[i] isKindOfClass:[NSString class]]) {
                self.dataArr = NO;
            }
            // 既不是数组，也不是字符串则抛出异常
            else {
                @throw [NSException exceptionWithName:NSStringFromClass([self class])
                                               reason:@"标题数组无法读取"
                                             userInfo:nil];
            }
        }
        [self setControlForSuper];
        [self addConstraintsForSuper];
    }
    else {
        // 数组为空，抛出异常
        @throw [NSException exceptionWithName:NSStringFromClass([self class])
                                       reason:@"标题数组不能为空"
                                     userInfo:nil];
    }
}
#pragma mark -- 懒加载控件

- (UIView *)containView {
    
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = UIColor.whiteColor;
    }
    return _containView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];_tableView = [[UITableView alloc]init];
        // 背景颜色
        _tableView.backgroundColor = [UIColor colorWithRed:225/225.0
                                                     green:225/225.0
                                                      blue:225/225.0
                                                     alpha:0.6];
        // 数据源、代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 是否可滑动
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        // 预估行高，（若实现了 heightForRowAtIndexPath: 方法，则返回真是行高无效)
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 去除分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[DNSheetAlertCell class] forCellReuseIdentifier:@"alertCell"];
    }
    return _tableView;
}

- (void)dealloc {
    self.delegate = nil;
}

@end

@implementation DNSheetAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 文字居中显示
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end
