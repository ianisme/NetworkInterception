//
//  IANHTTPSCheckProtocol.m
//  NetworkInterceptionDemo
//
//  Created by ian on 2017/11/12.
//

#import "IANHTTPSCheckProtocol.h"

static NSString * const hasInitKey = @"CustomDataProtocolKey";

@interface IANHTTPSCheckProtocol()

@property (nonatomic, strong) NSMutableData *myResponseData;
@property (nonatomic, strong) NSURLConnection *myConnection;
@property (nonatomic, strong) NSURLResponse *myResponse;
@property (nonatomic, strong) NSURLRequest *myRequest;

@end

@implementation IANHTTPSCheckProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    if ([mutableReqeust.URL.description containsString:@"api.ianisme.com"]) {
        
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
        NSData *tempData = [self toJSONData:dic];
        NSString *jsonString = [[NSString alloc] initWithData:tempData
                                                     encoding:NSUTF8StringEncoding];
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:@"text/html"
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        
    }
    else {
        self.myConnection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

- (void)stopLoading
{
    [self.myConnection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.myResponseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.myResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.myResponseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end
