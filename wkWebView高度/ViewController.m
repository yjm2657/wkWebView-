//
//  ViewController.m
//  wkWebView高度
//
//  Created by WSL on 17/3/9.
//  Copyright © 2017年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate>

@property (strong,nonatomic) UITableView *myTableView;
@property (strong,nonatomic) WKWebView *wkWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (nil == _wkWebView) {
        
        NSString *jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width, initial-scale=0.7, maximum-scale=0.7, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        
        wkWebConfig.userContentController = wkUController;
        
        
        
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.scrollEnabled = NO;
        [_wkWebView loadHTMLString:@"<p>新项目中，遇到了一个新的需求：</p><p>tableview中一个cell里嵌套了web view，对于这个需求，我们只要2步就可以完成。</p><p>想让web view根据内容自适应高度，</p><p>cell根据webView自适应高度。</p>" baseURL:nil];
    }
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_myTableView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_wkWebView];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == 0){
        /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
        return _wkWebView.frame.size.height;
    }
    return 40;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id result, NSError * _Nullable error) {
        CGRect newFrame = self.wkWebView.frame;
        newFrame.size.height = [result intValue];
        self.wkWebView.frame = newFrame;
        
        [self.myTableView reloadData];
    }];
    
}


@end
