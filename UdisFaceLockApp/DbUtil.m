//
//  DbUtil.m
//  03-03
//
//  Created by GavinHe on 16/2/25.
//  Copyright © 2016年 UDIS. All rights reserved.
//

#import "DbUtil.h"


@implementation DbUtil

- (NSString *)getPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"=======%@",path);
    return [path stringByAppendingPathComponent:kDbName];
}


- (sqlite3*)open {
    sqlite3 *database;
    //获取数据库路径
    NSString *path = [self getPath];
    NSLog(@"path=%@",path);
    NSInteger result= sqlite3_open([path UTF8String], &database);
    if (result==SQLITE_OK) {
        return database;
    }
    return nil;
}


-(void) close:(sqlite3*) db{
    if (db!=nil) {
        sqlite3_close(db);
    }
}

/*
 @property (nonatomic,assign) int pid;
 @property(nonatomic,assign) NSString *name,*pwd;
 */

//创建表
-(void) createTable:(sqlite3*) db {
    char *sql = "create table if not exists tbl_serverinfo (pid INTEGER PRIMARY KEY AUTOINCREMENT, ipaddress VARCHAR(20), port int,  opendatetime timestamp DEFAULT CURRENT_TIMESTAMP)";
    //char *sql = "create table if not exists tbl_serverinfo (pid INTEGER PRIMARY KEY AUTOINCREMENT, ipaddress text,  port int, opendatetime timestamp DEFAULT CURRENT_TIMESTAMP)";
    int result=sqlite3_exec(db, sql, 0, nil, nil);
    if(result == SQLITE_OK) {
        NSLog(@"%@",@"create table ok..");
    }else{
        NSLog(@"%@",@"create table fail..");
    }
}


-(BOOL) insertServerInfo:(ServerInfo*) serverinfo{
    //sqlite3 *db = [self open];
    //sqlite3_stmt *stmt = nil;
    NSMutableArray *serverArr = [NSMutableArray array];
    serverArr=[self queryServerInfo];
    sqlite3 *db = [self open];
    sqlite3_stmt *stmt = nil;
    if (serverArr.count>0) {
        
        //NSString *sqlStr = [NSString stringWithFormat:@"update tbl_serverinfo set ipaddress = '%@' ", serverinfo.ipaddress];
        NSString *sqlStr = [NSString stringWithFormat:@"update tbl_serverinfo set ipaddress = '%@', port='%d' ", serverinfo.ipaddress,serverinfo.port];
        int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            //if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                [self close:db];
                NSLog(@"%@",@"update serverinfo success..");
                return YES;
            }
            //}
        }
        sqlite3_finalize(stmt);
        [self close:db];
        NSLog(@"%@",@"update serverinfo fail..");
        return NO;

    }else{
        //NSString *sqlStr = [NSString stringWithFormat:@"insert into tbl_serverinfo (ipaddress) values ('%@')", serverinfo.ipaddress];
        NSString *sqlStr = [NSString stringWithFormat:@"insert into tbl_serverinfo (ipaddress,port) values ('%@','%d')", serverinfo.ipaddress,serverinfo.port];
        int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            //判断语句执行完成没有
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                [self close:db];
                NSLog(@"%@",@"insert serverinfo ok..");
                return YES;
            }
        }
        sqlite3_finalize(stmt);
        [self close:db];
        NSLog(@"%@",@"insert fail..");
        return NO;
        
    }
}



-(NSMutableArray*)queryServerInfo{
    //打开数据库
    sqlite3 *db = [self open];
    //数据库操作指针 stmt:statement
    sqlite3_stmt *stmt = nil;
    /*
     //验证SQL的正确性
     参数1: 数据库指针,
     参数2: SQL语句,
     参数3: SQL语句的长度 -1代表无限长(会自动匹配长度),
     参数4: 返回数据库操作指针,
     参数5: 为未来做准备的, 预留参数, 一般写成NULL
     */
    int result = sqlite3_prepare_v2(db, "select * from tbl_serverinfo", -1, &stmt, NULL);
    NSMutableArray *serverArr = [NSMutableArray array];
    //判断SQL执行的结果
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {//存在一行数据
            //列数从0开始
            int ID = sqlite3_column_int(stmt, 0);
            //const unsigned char *ipaddress = sqlite3_column_text(stmt, 1);
            //char *ipaddress   = (char*)sqlite3_column_text(stmt, 1);
            //sqlList.sqlText = [NSString stringWithUTF8String:ipaddress];
            //NSLog(@"queryServerInfo:ipaddress is %s",ipaddress);
            int port=sqlite3_column_int(stmt, 2);
            NSLog(@"queryServerInfo:port is %d",port);
            
            NSString *ipaddress = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            //classname.text = classnameField;
            NSLog(@"queryServerInfo:ipaddress is %@",ipaddress);
            
            
            
            ServerInfo *serverInfo = [[ServerInfo alloc] init];
            serverInfo.pid= ID;
            //serverInfo.ipaddress = [NSString stringWithUTF8String:(const char *)ipaddress];
            //serverInfo.ipaddress = [NSString stringWithUTF8String:ipaddress];
            serverInfo.ipaddress =ipaddress;
            serverInfo.port=port;
            //添加到数组
            [serverArr addObject:serverInfo];
            
            //const unsigned char *sex = sqlite3_column_text(stmt, 2);
            //int age = sqlite3_column_int(stmt, 3);
            /*
             //blob类型的获取
             //1 获取长度
             //int length = sqlite3_column_bytes(stmt, 4);
             //2 获取数据
             //const void *photo = sqlite3_column_blob(stmt, 4);
             //3 转成NSData
             //NSData *photoData = [NSData dataWithBytes:photo length:length];
             //4 转成UIImage
             //UIImage *image = [UIImage imageWithData:photoData];
             */
            
            
        }
    }
    //释放stmt指针
    sqlite3_finalize(stmt);
    //关闭数据库
    [self close:db];
    return serverArr;
}



/*
 -(ServerInfo*)findPerson:(int)pid{
 sqlite3 *db = [self open];
 sqlite3_stmt *stmt = nil;
 NSString *sqlStr = [NSString stringWithFormat:@"select * from Student where id = %d", pid];
 int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
 Person *per = nil;
 if (result == SQLITE_OK) {
 if (sqlite3_step(stmt) == SQLITE_ROW) {
 int ID = sqlite3_column_int(stmt, 0);
 const unsigned char *name = sqlite3_column_text(stmt, 1);
 //const unsigned char *sex = sqlite3_column_text(stmt, 2);
 //int age = sqlite3_column_int(stmt, 3);
 //int length = sqlite3_column_bytes(stmt, 4);
 //const unsigned char *photo = sqlite3_column_blob(stmt, 4);
 //NSData *photoData = [NSData dataWithBytes:photo length:length];
 //UIImage *image = [UIImage imageWithData:photoData];
 per = [[ServerInfo alloc] init];
 per.pid = ID;
 per.name = [NSString stringWithUTF8String:(const char *)name];
 //student.sex = [NSString stringWithUTF8String:(const char *)sex];
 //student.age = age;
 //student.photo = image;
 }
 }
 sqlite3_finalize(stmt);
 [self  close:db];
 return per;
 }
 */


/*
 -(BOOL) del:(int) pid{
 sqlite3 *db = [self open];
 sqlite3_stmt *stmt = nil;
 NSString *sqlStr = [NSString stringWithFormat:@"delete from tbl_serverinfo where pid = %d", pid];
 int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
 if (result == SQLITE_OK) {
 if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则删除
 if (sqlite3_step(stmt) == SQLITE_DONE) {
 sqlite3_finalize(stmt);
 [self close:db];
 return YES;
 }
 }
 }
 sqlite3_finalize(stmt);
 [self close:db];
 return NO;
 }
 */

/*
 -(BOOL) update:(ServerInfo*) server{
 sqlite3 *db = [self open];
 sqlite3_stmt *stmt = nil;
 //NSString *sqlStr = [NSString stringWithFormat:@"update tbl_serverinfo set ipaddress = '%@' where id = %d", per.name, per.pid];
 NSString *sqlStr = [NSString stringWithFormat:@"update tbl_serverinfo set ipaddress = '%@' ", server.ipaddress];
 int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
 if (result == SQLITE_OK) {
 if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
 if (sqlite3_step(stmt) == SQLITE_DONE) {
 sqlite3_finalize(stmt);
 [self close:db];
 return YES;
 }
 }
 }
 sqlite3_finalize(stmt);
 [self close:db];
 return NO;
 }
 */



@end
