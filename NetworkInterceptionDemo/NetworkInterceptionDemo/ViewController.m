//
//  ViewController.m
//  NetworkInterceptionDemo
//
//  Created by ian on 2017/10/30.
//

#import "ViewController.h"
#import <JSONModel.h>
#import <AFNetworking.h>
#import "TimeModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)oneClick:(id)sender
{
    NSDictionary *dic = @{
                          @"code": @0,
                          @"message": @"成功",
                          @"data": @{
                                  @"website": @"https://www.ianisme.com",
                                  @"list": @[
                                          @{
                                              @"day": @"30",
                                              @"month": @"10",
                                              @"year": @"2017"
                                              }
                                          ]
                                  }
                          };
    TimeModel *model = [[TimeModel alloc] initWithDictionary:dic[@"data"] error:nil];
    NSLog(@"%@",model);
}

- (IBAction)twoClick:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.ianisme.com/test.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TimeModel *model = [[TimeModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
        NSLog(@"%@",model);
    } failure:^(AFHTTPRequestOperation *operation, NSError*error) {
        NSLog(@"失败");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
