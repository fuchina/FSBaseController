//
//  FSSelectImageController.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2020/1/18.
//

#import "FSSelectImageController.h"
#import "FSIPImageCell.h"
#import "FSUIKit.h"

@interface FSSelectImageController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView   *collectionView;

@end

@implementation FSSelectImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectImageDesignViews];
}

- (void)bbiClick {
    static NSString *camera = @"拍照";
    static NSString *photo = @"从相册选择";
    static NSString *save = @"保存图片";
    NSNumber *type = @(UIAlertActionStyleDefault);
    [FSUIKit alert:UIAlertControllerStyleActionSheet controller:self title:nil message:nil actionTitles:@[camera,photo,save] styles:@[type,type,type] handler:^(UIAlertAction *action) {
        
    }];
}

- (void)selectImageDesignViews {
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width + 20, self.view.bounds.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.bounds.size.width + 20, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake((self.view.frame.size.width + 20), 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[FSIPImageCell class] forCellWithReuseIdentifier:@"FSIPImageCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (FSIPImageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FSIPImageCell";
    FSIPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:@"weInfo_header"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSIPImageCell class]]) {
        [(FSIPImageCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSIPImageCell class]]) {
        [(FSIPImageCell *)cell recoverSubviews];
    }
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
