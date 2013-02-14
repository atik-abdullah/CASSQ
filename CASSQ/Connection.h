//
//  Connection.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, copy) void (^completionBlock)( NSError *err);

- (void)start;
- (id)initWithRequest:(NSURLRequest *)req;

@end
