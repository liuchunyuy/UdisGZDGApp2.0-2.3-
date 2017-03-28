

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "AsyncSocket.h"
#import "Config.h"
#import "MBProgressHUD.h"


@interface ModiPasswordController : UIViewController

@property (nonatomic, strong) NSString *szSignal;
- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal;

@end
