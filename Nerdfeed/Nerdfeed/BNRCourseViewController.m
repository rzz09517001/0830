//
//  BNRCourseViewController.m
//  Nerdfeed
//
//  Created by macOs on 2018/9/12.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRCourseViewController.h"
#import "BNRWebViewController.h"

@interface BNRCourseViewController ()<NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation BNRCourseViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"BNR Courses";
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //_session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self fetchFeed];
    }
    return self;
}

//请求数据
-(void)fetchFeed
{
    //NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.courses = jsonObject[@"courses"];
        NSLog(@"%@",self.courses);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    //NSURLSessionTask刚创建的时候都是处在暂停状态，调用下面的方法继续；
    [dataTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    return cell;
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

#pragma mark NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
}

@end
