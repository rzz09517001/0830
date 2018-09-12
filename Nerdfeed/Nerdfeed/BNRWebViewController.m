//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by macOs on 2018/9/12.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController ()

@end

@implementation BNRWebViewController

-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

-(void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark UISplitViewControllerDelegate
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(nonnull UIViewController *)aViewController withBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem forPopoverController:(nonnull UIPopoverController *)pc
{
    //如果某个UIBarButtonItem对象没有标题，该对象就不会有任何显示
    barButtonItem.title = @"Courses";
    //将传入的UIBarButtonItem对象设置为navigationItem的左侧按钮
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end
