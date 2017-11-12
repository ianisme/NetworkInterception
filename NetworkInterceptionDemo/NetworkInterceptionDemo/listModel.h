//
//  listModel.h
//  NetworkInterceptionDemo
//
//  Created by ian on 2017/10/30.
//

#import <JSONModel/JSONModel.h>

@protocol listModel
@end

@interface listModel : JSONModel

@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *year;

@end
