//
//  DKGuaidViewController.m
//  DKGuaidView
//
//  Created by 雪凌 on 2018/8/24.
//  Copyright © 2018年 雪凌. All rights reserved.
//

#import "DKGuaidViewController.h"

NSString * const kGuaidViewCellId = @"DKGuaidViewCell";

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
    CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DKGuaidViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation DKGuaidViewCell

#pragma mark- *** LayoutSubviews ***

- (void)layoutSubviews {
    
    if (_imageView) {
        _imageView.frame = self.bounds;
    }
    
    [super layoutSubviews];
}

#pragma mark- *** Setters And Getters ***

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end

#pragma mark-

@interface DKGuaidViewController ()<UICollectionViewDelegate,
                                 UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation DKGuaidViewController

@synthesize showPageIndicator = _showPageIndicator;
@synthesize imageNames = _imageNames;
@synthesize shouldHiddenBlock = _shouldHiddenBlock;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

#pragma mark- *** View Init ***

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 创建FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.view.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 创建CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                         collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 注册Cell
    [_collectionView registerClass:[DKGuaidViewCell class]
        forCellWithReuseIdentifier:kGuaidViewCellId];
    
    [self.view addSubview:_collectionView];
    
    // 添加PageControl
    CGFloat fixIphoneXValue = kDevice_Is_iPhoneX ? 34 : 0;
    self.pageControl.frame = CGRectMake(15, CGRectGetHeight(self.view.frame) - 30-fixIphoneXValue,
                                    CGRectGetWidth(self.view.frame) - 15 * 2,30);
    [self.view addSubview:self.pageControl];
    
    // 添加进入按钮
    CGPoint centerP = CGPointMake(0.5, 0.88);
    self.enterButton.frame = CGRectMake(0, 0, 160, 40);
    self.enterButton.layer.cornerRadius = 20;
    self.enterButton.clipsToBounds = YES;
    self.enterButton.hidden = YES;
    self.enterButton.center = CGPointMake(CGRectGetWidth(self.view.frame) * centerP.x,
                                    CGRectGetHeight(self.view.frame) * centerP.y);
    
    [self.view addSubview:self.enterButton];
}

#pragma mark- *** UICollectionView Delegate And DataSource ***

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _imageNames ? _imageNames.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DKGuaidViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuaidViewCellId
                                                                      forIndexPath:indexPath];
    
    NSString *imageName = _imageNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark- *** UIScrollView Delegate  ***

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger current = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.pageControl.currentPage = lroundf(current);
    self.enterButton.hidden = (_imageNames.count - 1 != current);
}

#pragma mark- *** Button Actions ***

- (void)hideGuaid {
    if (_shouldHiddenBlock) {
        _shouldHiddenBlock();
    }
}

#pragma mark- *** Setters And Getters ***

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.hidden = YES;
        _enterButton.backgroundColor = [UIColor greenColor];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton setTitle:@"立即开启" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(hideGuaid)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (void)setShowPageIndicator:(BOOL)showPageIndicator {
    if (_showPageIndicator != showPageIndicator) {
        _showPageIndicator = showPageIndicator;
        self.pageControl.hidden = !_showPageIndicator;
    }
}

- (void)setImageNames:(NSArray<NSString *> *)imageNames {
    if (_imageNames != imageNames) {
        _imageNames = [imageNames copy];
        self.pageControl.numberOfPages = _imageNames.count;
        [self.collectionView reloadData];
    }
}

#pragma mark- *** Overridden ***

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
