//
//  ViewController.m
//  WSNetworking
//
//  Created by 魏山 on 2018/4/28.
//  Copyright © 2018年 yyhj. All rights reserved.
//

#import "ViewController.h"
#import "WSNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[WSNetworking sharedInstance] requestWithRequestType:WSRequestTypeGet
//                                                      url:@"http://api.beta.vding.cn/v1/guide/group-list/list?access-token=23257E32463A9B80B46E54DFD01FFFAF9645D3119A72D69DADC609F81629114697A1E9D19844BD17E04DB66E8D00A9852762BA40519796258C069547B932ABD96D0A2B6D3DB27477C134BDDF4A4364FE1F4CF725D0C727703F109638F39B0571721DF27952085A6D7C7AD411561DC3B9C00B510512D651EFB5DAC6B11860AEC4"
//                                                   params:@{@"company_id":@"298",
//                                                            @"type":@"2"
//                                                            }
//                                                  success:^(id responseObject) {
//                                                      if (responseObject) {
//                                                          NSLog(@"%@",responseObject);
//                                                      }
//                                                  }
//                                                  failure:^(NSError *error) {
//
//                                                  }];
//    UIImage *iamge = [UIImage imageNamed:@"zzpic11417"];
//    UIImage *iamge1 = [UIImage imageNamed:@"zzpic11417"];
//    UIImage *iamge2 = [UIImage imageNamed:@"zzpic11417"];
//    [[WSNetworking sharedInstance] uploadImagesWithUrl:@"http://api.beta.vding.cn/v1/guide/accounting/tally-enclosure?access-token=391130A32D218E5F59EF12714D86CCEDA7971803EB12099F4FA6FBA8FCF4C85CA28A34436F594C72693BAB3C5DBD086EC2F7200A689E16F900EA9DC1491DB0F5A3E6979A971F83AE73F0F3780BDA3D4EF38E2829CEAE29E108237A0690C3353ADC1BDA18959246D62A6836ADD5C7D4E71260B4E95BCC0E5BAD3CD8FBB8058DEA" fileName:@"file" params: @{@"file_id":@"",
//                                                                                                                                                                                                                                                                                                                                                                                                                                @"file_type":@"13",
//                                                                                                                                                                                                                                                                                                                                                                                                                                @"company_id":@"298",
//                                                                                                                                                                                                                                                                                                                                                                                                                                @"op_type":@(1)} imageArray:@[iamge,iamge1,iamge2] progress:^(int64_t completedUnitCount, int64_t totalUnitCount) {
//        NSLog(@"%lld--%lld--%f%%", completedUnitCount, totalUnitCount,completedUnitCount/(float)totalUnitCount * 100);
//    } success:^(id responseObject) {
//        if (responseObject) {
//                                  NSLog(@"%@",responseObject);
//                              }
//    } failure:^(NSError *error) {
//        if (error) {
//                                  NSLog(@"%@",error);
//                              }
//    }];
    
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/b.jpg"];
//    [[WSNetworking sharedInstance] downloadFileWithUrl:@"http://img02.tooopen.com/images/20150703/tooopen_sy_132700671385.jpg" params:nil saveToPath:path progress:^(int64_t completedUnitCount, int64_t totalUnitCount) {
//        NSLog(@"%lld--%lld--%f%%", completedUnitCount, totalUnitCount,completedUnitCount/(float)totalUnitCount * 100);
//    } success:^(id responseObject) {
//        if (responseObject) {
//            NSLog(@"%@",responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
