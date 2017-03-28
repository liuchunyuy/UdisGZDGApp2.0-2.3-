//
//  Person.h
//  03-03
//
//  Created by GavinHe on 16/2/25.
//  Copyright © 2016年 UDIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic,assign) int pid;
@property (nonatomic,copy)NSString *snid;
@property (nonatomic,copy)NSString *shortaddress;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *deviceid;
@property (nonatomic,copy)NSString *endpoint;
@property (nonatomic,copy)NSString *parentaddress;
@property (nonatomic,copy)NSString *sendrssi;
@property (nonatomic,copy)NSString *receiverssi;
@property (nonatomic,copy)NSString *ieee;
@property (nonatomic,copy)NSString *number;//虚拟字段，例如1号锁、2号锁


@end
