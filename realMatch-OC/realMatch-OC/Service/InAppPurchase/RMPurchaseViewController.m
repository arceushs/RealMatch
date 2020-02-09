//
//  RMPurchaseViewController.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMPurchaseViewController.h"
#import "UIColor+RealMatch.h"
#import "realMatch_OC-Swift.h"
#import "PurchaseManager.h"
#import <TTTAttributedLabel.h>
@interface RMPurchaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RouterController,TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;
@property (strong,nonatomic) NSArray* configBlocks;
@property (strong,nonatomic) UIView* selectedView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *instructionLabel;

@property (assign, nonatomic) NSInteger index;
@end

@implementation RMPurchaseViewController
-(void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purhcaseSuccess) name:@"RMPurchaseSuccess" object:nil];
    
    self.firstView.layer.cornerRadius = 4;
    self.firstView.layer.masksToBounds = YES;
    self.firstView.layer.borderColor = [UIColor colorWithString:@"C9CCD6"].CGColor;
    self.firstView.layer.borderWidth = 1;
    UITapGestureRecognizer* tapGest1 = [[UITapGestureRecognizer alloc]init];
    [tapGest1 addTarget:self action:@selector(tapGest:)];
    
    UITapGestureRecognizer* tapGest2 = [[UITapGestureRecognizer alloc]init];
    [tapGest2 addTarget:self action:@selector(tapGest:)];
    
    UITapGestureRecognizer* tapGest3 = [[UITapGestureRecognizer alloc]init];
    [tapGest3 addTarget:self action:@selector(tapGest:)];
    
    self.secondView.layer.cornerRadius = 4;
    self.secondView.layer.masksToBounds = YES;
    self.secondView.layer.borderColor = [UIColor colorWithString:@"C9CCD6"].CGColor;
    self.secondView.layer.borderWidth = 1;

    self.thirdView.layer.cornerRadius = 4;
    self.thirdView.layer.masksToBounds = YES;
    self.thirdView.layer.borderColor = [UIColor colorWithString:@"C9CCD6"].CGColor;
    self.thirdView.layer.borderWidth = 1;
    
    self.firstView.tag = 1;
    self.secondView.tag = 2;
    self.thirdView.tag = 3;
    [self.firstView addGestureRecognizer:tapGest1];
    [self.secondView addGestureRecognizer:tapGest2];
    [self.thirdView addGestureRecognizer:tapGest3];
    
    self.bannerCollectionView.delegate = self;
    self.bannerCollectionView.dataSource = self;
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"RMPurchaseBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RMPurchaseBannerCollectionViewCell"];
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.bannerCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, 238);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    void(^configBlock1)(RMPurchaseBannerCollectionViewCell* cell) = ^(RMPurchaseBannerCollectionViewCell* cell){
        cell.titleLabel.text = @"See Who Likes You";
        cell.subtitleLabel.text = @"Match with them instantly";
        CAGradientLayer* layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        layer.colors = @[(__bridge id)[UIColor colorWithString:@"ff0052"].CGColor,(__bridge id)[UIColor colorWithString:@"ffbb00"].CGColor];
        layer.frame = cell.bounds;
        [cell.layer insertSublayer:layer atIndex:0];
    };
    
    void(^configBlock2)(RMPurchaseBannerCollectionViewCell* cell) = ^(RMPurchaseBannerCollectionViewCell* cell){
        cell.titleLabel.text = @"Unlimited Likes";
        cell.subtitleLabel.text = @"Swipe right as much as you want";
        CAGradientLayer* layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        layer.colors = @[(__bridge id)[UIColor colorWithString:@"ff5df7"].CGColor,(__bridge id)[UIColor colorWithString:@"ff0000"].CGColor];
        layer.frame = cell.bounds;
        [cell.layer insertSublayer:layer atIndex:0];

    };
    
    void(^configBlock3)(RMPurchaseBannerCollectionViewCell* cell) = ^(RMPurchaseBannerCollectionViewCell* cell){
        cell.titleLabel.text = @"More Likely To Be Liked";
        cell.subtitleLabel.text = @"2X chance of being recommended";
        CAGradientLayer* layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        layer.colors = @[(__bridge id)[UIColor colorWithString:@"00d5ff"].CGColor,(__bridge id)[UIColor colorWithString:@"001cff"].CGColor];
        layer.frame = cell.bounds;
        [cell.layer insertSublayer:layer atIndex:0];

    };
    
    self.configBlocks = @[configBlock1,configBlock2,configBlock3,configBlock1];
    self.bannerCollectionView.userInteractionEnabled = NO;
    [self tapGest:nil];

    [self scrollBanner];
    
    self.instructionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.instructionLabel.delegate = self;
    NSRange range1 = [self.instructionLabel.text rangeOfString:@"Terms"];
    [self.instructionLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/terms.html"] withRange:range1];
    NSRange range2 = [self.instructionLabel.text rangeOfString:@"Privacy Policy"];
    [self.instructionLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/policy.html"] withRange:range2];
    // Do any additional setup after loading the view from its nib.
}

- (void)scrollBanner{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.index == self.configBlocks.count - 1) {
            self.index = 0;
            [self.bannerCollectionView setContentOffset:CGPointMake(self.index * self.bannerCollectionView.frame.size.width, 0) animated:NO];
            
        }
        self.index = self.index + 1;
        [self.bannerCollectionView setContentOffset:CGPointMake(self.index * self.bannerCollectionView.frame.size.width, 0) animated:YES];
//        if (self.index == self.configBlocks.count - 1) {
//            self.index = 0;
//            [self.bannerCollectionView setContentOffset:CGPointMake(self.index * self.bannerCollectionView.frame.size.width, 0) animated:NO];
//
//        }
        [self scrollBanner];
    });
}


-(void)tapGest:(UITapGestureRecognizer*)gest{
    
    NSArray* viewArr = @[self.firstView,self.secondView,self.thirdView];
    
    for(int i = 0;i<viewArr.count;i++){
        UIView* view = viewArr[i];
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor colorWithString:@"C9CCD6"].CGColor;
        view.layer.borderWidth = 1;
    }
    
    if (gest == nil){
        self.selectedView = self.secondView;
    }else {
        self.selectedView = gest.view;
    }
    
    UIView * view = self.selectedView;
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor colorWithString:@"FA008E"].CGColor;
    view.layer.borderWidth = 2;
}

//- (void)setViewStyle:(UIView *)
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)purhcaseSuccess{
    [self.navigationController popViewControllerAnimated:NO];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RMPurchaseBannerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RMPurchaseBannerCollectionViewCell" forIndexPath:indexPath];
    void(^block)(RMPurchaseBannerCollectionViewCell* cell) = self.configBlocks[indexPath.row];
    block(cell);
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.configBlocks.count;
}

- (IBAction)continueButtonClicked:(id)sender {
    NSArray* premiumArr = [PurchaseManager shareManager].premiumArr;
    [[PurchaseManager shareManager] startPurchaseWithID:premiumArr[self.selectedView.tag-1]];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)restoreButtonClicked:(id)sender {
    [[PurchaseManager shareManager] restorePurchase];
}

- (BOOL)animation {
    return YES;
}

- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (instancetype)initWithRouterParams:(NSDictionary *)params {
    if(self = [super init]){
    }
    return self;
}

#pragma mark - TTTAtrributelabel
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [[Router shared] routerTo:@"RMWebViewController" parameter:@{@"url":url.absoluteString}];
}

@end
