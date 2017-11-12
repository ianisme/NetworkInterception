//
//  TimeModel.h
//  NetworkInterceptionDemo
//
//  Created by ian on 2017/10/30.
//

#import <JSONModel/JSONModel.h>
#import "listModel.h"

@interface TimeModel : JSONModel

@property (nonatomic, copy) NSString *website;
@property (nonatomic, strong) NSArray <listModel> *list;

@end
