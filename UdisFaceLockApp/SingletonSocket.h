//
//  SingletonSocket.h
//  LcySingletonSocket
//
//  Created by GavinHe on 16/11/22.
//  Copyright © 2016年 Liu Chunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "Utils.h"

enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

//typedef void(^ReturnDictionary)(NSDictionary *dic); //回调请求的数据的block

@interface SingletonSocket : NSObject<AsyncSocketDelegate>

-(void)returnDictionary:(void (^)(NSDictionary *dic))block;
@property (nonatomic,copy) void(^block)(NSDictionary *dic);

@property(nonatomic,strong)AsyncSocket *socket;
@property(nonatomic,retain)NSTimer *heartTimer;
@property(nonatomic,strong)NSString *totalmessage;
//@property(nonatomic)BOOL isLogined;

+(SingletonSocket *)sharedInstance;
-(BOOL)startConnectSocket;
-(void)cutOffSocket;
-(void)sendMessage:(NSDictionary *)jsonDictionary;
-(void)getSocketData:(NSDictionary *)jsonDictionary;
@end
