//
//  FSConfigCOSController.m
//  FSTututu
//
//  Created by 扶冬冬 on 2022/6/15.
//

#import "FSConfigCOSController.h"
#import "FSAppConfig.h"
#import "FSTapCell.h"
#import "FSUIKit.h"
#import "FSToast.h"
#import "FSCryptor.h"
#import "FSCryptorSupport.h"
#import "FSOSS.h"

static NSString *_appCfg_cosConfig          = @"cosConfig";                     // cos配置（腾讯云）

static  NSString        *_key_appid         =        @"appid";
static  NSString        *_key_region        =        @"region";
static  NSString        *_key_secretid      =        @"secretid";
static  NSString        *_key_secretkey     =        @"secretkey";
static  NSString        *_key_bucket        =        @"bucket";

@interface FSConfigCOSController ()

@property (nonatomic, strong) NSMutableDictionary       *params;

@property (nonatomic, strong) FSTapCell                 *appIDCell;
@property (nonatomic, strong) FSTapCell                 *secretIDCell;
@property (nonatomic, strong) FSTapCell                 *secretKeyCell;
@property (nonatomic, strong) FSTapCell                 *regionCell;
@property (nonatomic, strong) FSTapCell                 *bucketCell;

@end

@implementation FSConfigCOSController

- (void)componentWillMount {
    [super componentWillMount];
    [self cosHandleDatas];
}

- (void)cosHandleDatas {
    NSString *pwd = [self.class pwd];
    NSString *ciphertext = [FSAppConfig objectForKey:_appCfg_cosConfig];
    NSString *cos = [FSCryptor aes256DecryptString:ciphertext password:pwd];
    NSDictionary *params = [FSKit objectFromJSonstring:cos];
    if ([params isKindOfClass:NSDictionary.class]) {
        self.params = params.mutableCopy;
    } else {
        self.params = [[NSMutableDictionary alloc] init];
    }

    [self cosDesignViews];
}

- (void)cosDesignViews {
    self.title = @"配置腾讯云COS";
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    NSString *appid = [self.params objectForKey:_key_appid];
    NSString *region = [self.params objectForKey:_key_region];
    NSString *secretid = [self.params objectForKey:_key_secretid];
    NSString *secretkey = [self.params objectForKey:_key_secretkey];
    NSString *bucket = [self.params objectForKey:_key_bucket];

    __weak typeof(self)this = self;
    self.appIDCell = [self cellWithText:@"APP ID" detailText:appid ? : @"未配置" top:self.view.safeAreaInsets_fs.top block:^(FSTapCell *cell) {
        [this config:@"配置APP ID" message:nil cell:cell key:_key_appid];
    }];
    
    self.secretIDCell = [self cellWithText:@"SECRET ID" detailText:secretid ? : @"未配置" top:self.appIDCell.bottom + 1 block:^(FSTapCell *cell) {
        [this config:@"配置SECRET ID" message:nil cell:cell key:_key_secretid];
    }];
    
    self.secretKeyCell = [self cellWithText:@"SECRET KEY" detailText:secretkey ? : @"未配置" top:self.secretIDCell.bottom + 1 block:^(FSTapCell *cell) {
        [this config:@"配置SECRET KEY" message:nil cell:cell key:_key_secretkey];
    }];
    
    self.regionCell = [self cellWithText:@"REGION（区域）" detailText:region ? : @"未配置" top:self.secretKeyCell.bottom + 1 block:^(FSTapCell *cell) {
        [this config:@"配置REGION（区域）" message:nil cell:cell key:_key_region];
    }];
    
    self.bucketCell = [self cellWithText:@"BUCKET（存储桶）" detailText:bucket ? : @"未配置" top:self.regionCell.bottom + 1 block:^(FSTapCell *cell) {
        [this config:@"配置BUCKET（存储桶）" message:nil cell:cell key:_key_bucket];
    }];
    
    NSArray *buttons = @[@"粘贴", @"导出"];
    CGFloat w = WIDTHFC / buttons.count;
    CGFloat top = HEIGHTFC - self.view.safeAreaInsets_fs.bottom - 50;
    for (int x = 0; x < buttons.count; x ++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(x * w, top, w, 50);
        [b setTitle:buttons[x] forState:UIControlStateNormal];
        b.tag = x;
        [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
    }
}

- (void)buttonClick:(UIButton *)button {
    if (button.tag == 0) {
        [self pasteEvent];
    } else if (button.tag == 1) {
        [self outportEvent];
    }
}

- (void)pasteEvent {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *cos = board.string;
    if ([cos isKindOfClass:NSString.class] && cos.length) {
        NSDictionary *params = [FSKit objectFromJSonstring:cos];
        if (!([params isKindOfClass:NSDictionary.class] && params.count)) {
            [FSToast show:@"没有可以粘贴的数据呀"];
            return;
        }
        NSString *message = [self messageForDictioanry:params];
        [FSUIKit alert:(UIAlertControllerStyleActionSheet) controller:self title:@"粘贴这些内容？" message:message actionTitles:@[@"粘贴"] styles:@[@(UIAlertActionStyleDefault)] handler:^(FSAlertAction *action) {
            self.params = params.mutableCopy;
            self.appIDCell.detailTextLabel.text = params[_key_appid];
            self.secretIDCell.detailTextLabel.text = params[_key_secretid];
            self.secretKeyCell.detailTextLabel.text = params[_key_secretkey];
            self.regionCell.detailTextLabel.text = params[_key_region];
            self.bucketCell.detailTextLabel.text = params[_key_bucket];
        }];
    } else {
        [FSToast show:@"粘贴板中没有内容"];
    }
}

- (void)outportEvent {
    if ([self.params isKindOfClass:NSDictionary.class] && self.params.count == 0) {
        [FSToast show:@"没有数据可以拷贝呀"];
        return;
    }
    NSString *message = [self messageForDictioanry:self.params];
    [FSUIKit alert:(UIAlertControllerStyleActionSheet) controller:self title:@"拷贝这些内容？" message:message actionTitles:@[@"拷贝"] styles:@[@(UIAlertActionStyleDefault)] handler:^(FSAlertAction *action) {
        NSString *cos = [FSKit jsonStringWithObject:self.params];
        [FSKit copyToPasteboard:cos];
        [FSToast show:@"已经拷贝到粘贴板"];
    }];
}

- (NSString *)messageForDictioanry:(NSDictionary *)params {
    NSString *appid = [params objectForKey:_key_appid];
    NSString *region = [params objectForKey:_key_region];
    NSString *secretid = [params objectForKey:_key_secretid];
    NSString *secretkey = [params objectForKey:_key_secretkey];
    NSString *bucket = [params objectForKey:_key_bucket];
    
    NSString *message = [[NSString alloc] initWithFormat:@"APP ID：%@\nSECRET ID：%@\nSECRET KEY：%@\nREGION（区域）：%@\nBUCKET（存储桶）：%@", appid, secretid, secretkey, region, bucket];
    return message;
}

- (void)config:(NSString *)title message:(NSString *)message cell:(FSTapCell *)cell key:(NSString *)key {
    __weak typeof(self)this = self;
    __weak typeof(cell)wc = cell;
    [FSUIKit alertInput:1 controller:self title:title message:message ok:@"确定" handler:^(UIAlertController *bAlert, UIAlertAction *action) {
        NSString *text = bAlert.textFields.firstObject.text;
        if (text.length < 1) {
            [FSToast show:@"请输入有效内容"];
            return;
        }
        [this.params setValue:text forKey:key];
        wc.detailTextLabel.text = text;
    } cancel:@"取消" handler:nil textFieldConifg:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    } completion:nil];
}

- (void)save {
    NSString *appid = [self.params objectForKey:_key_appid];
    NSString *region = [self.params objectForKey:_key_region];
    NSString *secretid = [self.params objectForKey:_key_secretid];
    NSString *secretkey = [self.params objectForKey:_key_secretkey];
    NSString *bucket = [self.params objectForKey:_key_bucket];
    if (appid == nil || region == nil || secretid == nil || secretkey == nil || bucket == nil) {
        [FSToast show:@"请配置好所有数据"];
        return;
    }
    NSString *pwd = [self.class pwd];
    NSString *cos = [FSKit jsonStringWithObject:self.params];
    NSString *ciphertext = [FSCryptor aes256EncryptString:cos password:pwd];
    NSString *error = [FSAppConfig saveObject:ciphertext forKey:_appCfg_cosConfig];
    NSAssert(error == nil, @"存储失败");
    if (error) {
        [FSUIKit showAlertWithMessage:error controller:self];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

+ (NSString *)pwd {
    NSString *pwd = FSCryptorSupport.localUserDefaultsCorePassword;
    if (!pwd) {
        pwd = NSStringFromClass(self.class);
    }
    return pwd;
}

- (FSTapCell *)cellWithText:(NSString *)text detailText:(NSString *)detailText top:(CGFloat)top block:(void(^)(FSTapCell *cell))click {
    FSTapCell *cell = [[FSTapCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
    cell.frame = CGRectMake(0, top, WIDTHFC, 50);
    cell.backgroundColor = UIColor.whiteColor;
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    cell.click = ^(FSTapCell * _Nonnull bCell) {
        if (click) {
            click(bCell);
        }
    };
    [self.view addSubview:cell];
    return cell;
}

+ (BOOL)configOSS:(UIViewController *)controller {
    NSString *pwd = [self pwd];
    NSString *ciphertext = [FSAppConfig objectForKey:_appCfg_cosConfig];
    NSString *cos = [FSCryptor aes256DecryptString:ciphertext password:pwd];
    NSDictionary *params = [FSKit objectFromJSonstring:cos];
    if (!([params isKindOfClass:NSDictionary.class] && params.count == 5)) {
        [FSUIKit alert:(UIAlertControllerStyleActionSheet) controller:controller title:@"重要提示!" message:@"需要去【设置 - 配置COS】中配置好COS数据才可以继续操作" actionTitles:@[@"去配置"] styles:@[@(UIAlertActionStyleDefault)] handler:^(FSAlertAction *action) {
            [FSKit pushToViewControllerWithClass:@"FSConfigCOSController" navigationController:controller.navigationController param:nil configBlock:nil];
        }];
        return NO;
    }
    
    NSString *appid = [params objectForKey:_key_appid];
    NSString *region = [params objectForKey:_key_region];
    NSString *secretid = [params objectForKey:_key_secretid];
    NSString *secretkey = [params objectForKey:_key_secretkey];
    NSString *bucket = [params objectForKey:_key_bucket];
    [FSOSS configAppID:appid regionName:region secretID:secretid secretKey:secretkey bucket:bucket];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
