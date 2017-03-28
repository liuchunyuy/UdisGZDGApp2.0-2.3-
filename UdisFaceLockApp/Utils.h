
#import <Foundation/Foundation.h>

//#import "UIView+Util.h"
//#import "UIColor+Util.h"
//#import "UIImageView+Util.h"
//#import "UIImage+Util.h"
//#import "NSTextAttachment+Util.h"
//#import "AFHTTPRequestOperationManager+Util.h"
//#import "UINavigationController+Router.h"
//#import "NSDate+Util.h"
//#import "NSString+Util.h"


typedef NS_ENUM(NSUInteger, hudType) {
    hudTypeSendingTweet,
    hudTypeLoading,
    hudTypeCompleted
};

@class MBProgressHUD;

@interface Utils : NSObject
//@property (nonatomic,assign) int length;
//@property (nonatomic,assign) int characterAtIndex;

//获取一个随机整数，范围在[from,to），包括from，不包括to
+(int)getRandomNumber:(int)from to:(int)to;


//IOS用正则验证手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;


//判断字符串是否为纯数字
+ (BOOL)isPureInt:(NSString*)string;
//show alert
+ (void)showAlert:(NSString *) _message;
//字符串转换成字节数组
+(NSData*)stringToByte:(NSString*)string;
//读取的NSData转换成16进制字符串
+(NSString *)hexStringFromData:(NSData*)data;

//转化数字字符串，为每个数字前补0
+ (NSString*)toHexString:(NSString*)inputstring;


//以下是原来方法
+ (NSDictionary *)emojiDict;
//+ (NSAttributedString *)getAppclient:(int)clientType;
+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews;
+ (NSString *)generateTags:(NSArray *)tags;
//+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString;
//+ (NSAttributedString *)emojiStringFromAttrString:(NSAttributedString*)attrString;
//+ (NSAttributedString *)attributedStringFromHTML:(NSString *)HTML;
+ (NSData *)compressImage:(UIImage *)image;
//+ (NSString *)convertRichTextToRawText:(UITextView *)textView;
+ (BOOL)isURL:(NSString *)string;
//+ (NSInteger)networkStatus;
//+ (BOOL)isNetworkExist;
+ (CGFloat)valueBetweenMin:(CGFloat)min andMax:(CGFloat)max percent:(CGFloat)percent;
//+ (MBProgressHUD *)createHUD;
+ (UIImage *)createQRCodeFromString:(NSString *)string;
//+ (NSAttributedString *)attributedTimeString:(NSDate *)date;
//+ (NSAttributedString *)attributedCommentCount:(int)commentCount;
//+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName;



@end
