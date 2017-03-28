//
//  Person.h
//  03-03
//
//  Created by GavinHe on 16/2/25.
//  Copyright © 2016年 UDIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerInfo : NSObject

@property (nonatomic,assign) int pid;
@property (nonatomic,copy)NSString *ipaddress;//****不能设成assign
@property (nonatomic,assign) int port;


@end
