
//
//  NSObject_config.h
//  SocketClient
//
//  Created by Simple on 13-4-2.
//  Copyright (c) 2013年 simple. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------上海----------------
//#define _SERVER_ADDRESS @"140.207.101.214"                                          //服务器地址
//#define _SCROOLVIEW_IMAGE_URL @"http://140.207.101.214/UDISGZDG/advertisement.json" //轮播图片地址
//#define _VERSION_URL @"http://140.207.101.214/UDISGZDG/update_IOS.txt"              //版本号地址


//-----------------贵州----------------
//#define _SERVER_ADDRESS @"220.197.186.34"
#define _SERVER_ADDRESS @"www.xn--xhqp9ff9azy4at4fur5a.com"                         //服务器地址
#define _SCROOLVIEW_IMAGE_URL @"http://220.197.186.34:8081/gzdg/advertisement.json" //轮播图片地址
#define _VERSION_URL @"http://220.197.186.34:8081/gzdg/update_IOS.txt"              //版本号地址

#define _SERVER_PORT 20123//网关通讯端口号
#define _APP_NAME @"贵州东冠智慧小区App"
#define _MESSAGE_START @"<UDIS>"
#define _MESSAGE_END @"</UDIS>"

#define _SOCKET_CONNECT_SUCCESS @"服务器连接成功!!"
#define _SOCKET_CONNECT_FAIL @"连接服务器失败，请稍后重试!!"

//登陆
#define _LOGIN_FAIL_USER @"用户不存在";
#define _LOGIN_FAIL_PASSWORD @"密码错误";
#define _LOGIN_FAIL_EXCEPTION @"系统异常请稍候再试!";

//开门
#define _OPEN_LOCK_SUCESS @"开门成功!!!";
#define _OPEN_LOCK_FAIL1  @"设备有问题，开门失败，请联系管理员!";
#define _OPEN_LOCK_FAIL2  @"数据有问题，开门失败，请联系管理员!";
#define _OPEN_LOCK_FAIL3  @"系统异常，开门失败，请联系管理员!";

//延时时间
#define _DELAYTIME 1;




