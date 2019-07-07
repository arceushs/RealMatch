//
//  RMMessageDetailViewController.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMMessageDetailViewController.h"
#import "RMMessageToMeTableViewCell.h"
#import "RMMessageFromMeTableViewCell.h"
#import "RMMessageDetailModel.h"
#import "Router.h"
#import "UIDevice+RealMatch.h"

@interface RMMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RouterController,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageDetailTableView;
@property (strong,nonatomic) NSMutableArray<RMMessageDetailModel*>* modelArrs;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightContraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation RMMessageDetailViewController

-(instancetype)initWithRouterParams:(NSDictionary *)params{
    if(self = [super init]){
    
    }
    return self;
}

- (BOOL)animation {
    return YES;
}

- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArrs = [NSMutableArray array];
    self.messageDetailTableView.dataSource = self;
    self.messageDetailTableView.delegate = self;
    [self.messageDetailTableView registerNib:[UINib nibWithNibName:@"RMMessageFromMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMMessageFromMeTableViewCell"];
    [self.messageDetailTableView registerNib:[UINib nibWithNibName:@"RMMessageToMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMMessageToMeTableViewCell"];
    self.messageDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    RMMessageDetailModel* model1 = [[RMMessageDetailModel alloc]init];
    model1.text = @"Nice to meet you!";
    
    RMMessageDetailModel* model2 = [[RMMessageDetailModel alloc]init];
    model2.text = @"But before you unpack, just check to make sure whether the Island has been affected. We have had many tropical storm warnings over the years, but unlike Florida we’ve been extremely fortunate.";
    [self.modelArrs addObject:model1];
    [self.modelArrs addObject:model2];
    
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    if(self.modelArrs[indexPath.row].messageFrom == MessageFromMe){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageFromMeTableViewCell" forIndexPath:indexPath];
        RMMessageFromMeTableViewCell* _cell =(RMMessageFromMeTableViewCell*) cell;
        _cell.LabelContent.text = self.modelArrs[indexPath.row].text;
        _cell.contentHeightStraint.constant = self.modelArrs[indexPath.row].rowHeight - 16;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageToMeTableViewCell" forIndexPath:indexPath];
        RMMessageToMeTableViewCell* _cell =(RMMessageToMeTableViewCell*) cell;
        _cell.LabelContent.text = self.modelArrs[indexPath.row].text;
        _cell.contentHeightConstraint.constant = self.modelArrs[indexPath.row].rowHeight - 16;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.modelArrs[indexPath.row].rowHeight;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArrs.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}


-(void)textViewDidChange:(UITextView *)textView{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(148, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.inputViewHeightContraint.constant = size.height + 34;
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.size.height;
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.bottomConstraint.constant =0 - transformY + [UIDevice safeBottomHeight];
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomConstraint.constant = 0 ;
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
