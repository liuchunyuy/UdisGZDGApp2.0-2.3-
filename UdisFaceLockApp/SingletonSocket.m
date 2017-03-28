//
//  SingletonSocket.m
//  LcySingletonSocket
//
//  Created by GavinHe on 16/11/22.
//  Copyright © 2016年 Liu Chunyu. All rights reserved.
//

#import "SingletonSocket.h"
#import "MBProgressHUD.h"
#import "Config.h"

@implementation SingletonSocket

//@property(nonatomic)BOOL isLogined;
+ (SingletonSocket *)sharedInstance{
    
    static SingletonSocket *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstace = [[self alloc] init];
        //sharedInstace.socket = [[AsyncSocket alloc]initWithDelegate:self];
    });
    return sharedInstace;
}

-(void)getSocketData:(NSDictionary *)jsonDictionary{

    if (self.socket == nil) {
        if ([self startConnectSocket]) {
            [self sendMessage:jsonDictionary];
        }
    }else{
    
        self.socket = nil;
        [self sendMessage:jsonDictionary];
    }
}

- (BOOL)startConnectSocket{
    
    if (self.socket == nil) {
        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error = nil;
        NSString *address = [self.socket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![self.socket connectToHost:address onPort:_SERVER_PORT withTimeout:3 error:&error]){
            self.socket = nil;
            NSLog(@"连接服务器失败");
            return FALSE;
        }else{
            NSLog(@"Connect success!");
            //[Utils showAlert:@"连接服务器成功!!"];
            self.totalmessage = @"";
            return TRUE;
        }
    }else{
        NSLog(@"Connected!---");
        self.totalmessage = @"";
        NSLog(@"------");
        return TRUE;
    }
    //[self.socket connectToHost:HOST onPort:PORT withTimeout:20 error:&error];
}

- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port{
    
    if (![self.socket isConnected]){
        NSError *error = nil;
        [self.socket connectToHost:addr onPort:port withTimeout:20 error:&error];
    }
    return 0;
}

-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
}

- (void)sendMessage:(NSDictionary *)jsonDictionary{
    
    if ([self startConnectSocket]) {
        NSLog(@"已经连接上服务器");
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
        NSLog(@"send action is －－－: %@",content);
        NSData *sendata = [content dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:sendata withTimeout:20 tag:0];
    }else{
        NSLog(@"服务器还未链接");
    }        
}

#pragma AsyncScoket Delagate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"didConnectToHost:onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData");
    //self.isLogined = YES;
    //NSLog(@"data is-----------: %@",data);
    [self receiveData:data];
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag{
    
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    NSLog(@"willDisconnectWithError: onSocket:%p willDisconnectWithError:%@", sock, err);
}


#pragma mark - Delegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    NSLog(@"7878 sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self startConnectSocket];
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
        
        // wifi断开,重连
        [self startConnectSocket];
    }
}

-(void)returnDictionary:(void (^)(NSDictionary *))block{

    self.block = ^(NSDictionary * dic){
        if (block) {
            block(dic);
        }
    };
}

//接受消息成功之后回调
-(void)receiveData :(NSData *)data{
    
   // NSLog(@"data is %@",data);
    /*
     1.data为接收到的数据
     2.通过通知，block，代理等方法传出去
     */
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"recvMessage is: %@",recvMessage);
        if(recvMessage){
            self.totalmessage=[self.totalmessage stringByAppendingString:recvMessage];
          //  NSLog(@"totalmessage is: %@",self.totalmessage);
            NSRange rangeStart = [self.totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [self.totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {// Receipt of a complete data
                // Interception sign out front udis
                NSString *needmessage=[[self.totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
               // NSLog(@"--------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
               // NSLog(@"dic=%@",dic);
                //NSLog(@"修改密码dic ---1 %@",dic);
                if (self.block) {
                    self.block(dic);
                }
            }
        }
    }
}

@end
