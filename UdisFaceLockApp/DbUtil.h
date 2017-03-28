//
//  DbUtil.h
//  03-03
//
//  Created by GavinHe on 16/2/25.
//  Copyright © 2016年 UDIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerInfo.h"
#import "sqlite3.h"
#define kDbName @"data.db"

@interface DbUtil : NSObject

//获取数据库文件路径
-(NSString*)getPath;

-(sqlite3*)open;

-(void) close:(sqlite3*) db;

-(void) createTable:(sqlite3*) db;

-(BOOL) insertServerInfo:(ServerInfo*) per;

-(NSMutableArray*)queryServerInfo;

//-(BOOL) del:(int) pid;

//-(BOOL) update:(ServerInfo*) per;

//-(ServerInfo*)findPerson:(int)pid;

@end
