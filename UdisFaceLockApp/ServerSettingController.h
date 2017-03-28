

#import <UIKit/UIKit.h>
#import "DbUtil.h"
#import "ServerInfo.h"

@interface ServerSettingController : UIViewController

@property (nonatomic, strong) NSString *szSignal;

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal;

@end
