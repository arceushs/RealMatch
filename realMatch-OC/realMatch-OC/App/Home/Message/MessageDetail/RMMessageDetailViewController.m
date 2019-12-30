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
#import "Router.h"
#import "UIDevice+RealMatch.h"
#import "RMSocketManager.h"
#import "realMatch_OC-Swift.h"

@interface RMMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RouterController,UITextViewDelegate,RMSocketManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageDetailTableView;
@property (strong,nonatomic) NSMutableArray<RMMessageDetail*>* modelArrs;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightContraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;


@property (strong,nonatomic) NSString* fromUserId;
@property (strong,nonatomic) NSString* toUserId;
@property (strong,nonatomic) NSString* messageTitle;
@property (strong,nonatomic) NSString* avatar;

@end

@implementation RMMessageDetailViewController

-(instancetype)initWithRouterParams:(NSDictionary *)params{
    if(self = [super init]){
        self.fromUserId = params[@"fromUser"];
        self.toUserId = [NSString stringWithFormat:@"%ld",[params[@"toUser"] intValue]];
        self.messageTitle = params[@"fromUserName"];
        self.avatar = params[@"avatar"];
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
    
    NSDictionary* dict = @{@"fromUser":self.fromUserId,
                           @"toUser":self.toUserId,
                           @"timestamp":@([[NSDate date] timeIntervalSinceReferenceDate]),
                           @"count":@(10),
                           @"direction":@"front"
                           };
    NSArray<RMMessageDetail*>* messageDetailArr = [[RMDatabaseManager shareManager] getData:[[RMMessageParams alloc] init:dict]];
    
    
    for (RMMessageDetail* messageDetail in messageDetailArr) {
        if([messageDetail.toUser isEqualToString:self.fromUserId]){
            messageDetail.messageFrom = MessageFromMessageFromOther;
        }else{
            messageDetail.messageFrom = MessageFromMessageFromMe;
        }
        [self.modelArrs addObject:messageDetail];
    }
    
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottom:self.messageDetailTableView WithAnimation:NO];
    });
    
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
    [self.messageDetailTableView addGestureRecognizer:tapGest];
    
    self.messageTitleLabel.text = self.messageTitle;
    // Do any additional setup after loading the view from its nib.
}

-(void)tapGest{
    [self.textView resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[RMSocketManager shared] addDelegate:self];
}

-(void)viewDidDisapper:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[RMSocketManager shared] removeDelegate:self];
}

-(void)didReceiveMessage{

    
    NSDictionary* dict = @{@"fromUser":self.fromUserId,
                           @"toUser":self.toUserId,
                           @"timestamp":@([[NSDate date] timeIntervalSinceReferenceDate]),
                           @"count":@(1),
                           @"direction":@"front"
                           };
    NSLog(@"%lf",[((NSNumber*)dict[@"timestamp"]) doubleValue]);
    NSArray<RMMessageDetail*>* messageDetailArr = [[RMDatabaseManager shareManager] getData:[[RMMessageParams alloc] init:dict]];
    
    
    for (RMMessageDetail* messageDetail in messageDetailArr) {
        if([messageDetail.toUser isEqualToString:self.fromUserId]){
            messageDetail.messageFrom = MessageFromMessageFromOther;
        }else{
            messageDetail.messageFrom = MessageFromMessageFromMe;
        }
        [self.modelArrs addObject:messageDetail];
    }
    [self.messageDetailTableView reloadData];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottom:self.messageDetailTableView WithAnimation:YES];
    });
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
    if(self.modelArrs[indexPath.row].messageFrom == MessageFromMessageFromMe){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageFromMeTableViewCell" forIndexPath:indexPath];
        RMMessageFromMeTableViewCell* _cell =(RMMessageFromMeTableViewCell*) cell;
        _cell.LabelContent.text = self.modelArrs[indexPath.row].msg;
        _cell.contentHeightStraint.constant = self.modelArrs[indexPath.row].rowHeight - 16;
        [_cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[RMUserCenter shared].avatar] placeholderImage:[UIImage imageNamed:@"default.jpeg"]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageToMeTableViewCell" forIndexPath:indexPath];
        RMMessageToMeTableViewCell* _cell =(RMMessageToMeTableViewCell*) cell;
        _cell.LabelContent.text = self.modelArrs[indexPath.row].msg;
        _cell.contentHeightConstraint.constant = self.modelArrs[indexPath.row].rowHeight - 16;
        [_cell.avatarimageView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"default.jpeg"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.modelArrs[indexPath.row].rowHeight;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArrs.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -100){
        if([self.modelArrs count]>0){
            RMMessageDetail* messageDetailIndex0 = self.modelArrs[0];
            NSDictionary* dict = @{@"fromUser":self.fromUserId,
                                   @"toUser":self.toUserId,
                                   @"direction":@"front",
                                   @"timestamp":@(messageDetailIndex0.timestamp),
                                   @"count":@(10)
                                   };
            NSArray<RMMessageDetail*>* messageDetailArr = [[RMDatabaseManager shareManager] getData:[[RMMessageParams alloc] init:dict]];
            
            
            for (RMMessageDetail* messageDetail in [messageDetailArr reverseObjectEnumerator]) {
                if([messageDetail.toUser isEqualToString:self.fromUserId]){
                    messageDetail.messageFrom = MessageFromMessageFromOther;
                }else{
                    messageDetail.messageFrom = MessageFromMessageFromMe;
                }
                [self.modelArrs insertObject:messageDetail atIndex:0];
            }
            [self.messageDetailTableView reloadData];
        }
        
    }
}


-(void)textViewDidChange:(UITextView *)textView{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.inputViewHeightContraint.constant = size.height + 51;
    [self.inputView setNeedsLayout];
    [self.inputView layoutIfNeeded];
}



-(void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)scrollToBottom:(UIScrollView*)scrollView WithAnimation:(BOOL)animate{
    CGFloat contentOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if(contentOffset>0){
        [scrollView setContentOffset:CGPointMake(0, contentOffset) animated:animate];
    }
}

- (IBAction)sendMessageButtonClicked:(id)sender {
    if([self.textView.text  length]<=0)
        return;
    NSDictionary* dict = @{@"fromUser":self.fromUserId,
                           @"toUser":self.toUserId,
                           @"msg":self.textView.text,
                           @"msg_type":@"text",
                           @"uploadId":@(-1)
                           };
    
    RMMessageDetail* messageDetail = [[RMMessageDetail alloc]init:dict];
    [[RMSocketManager shared] messageSend:messageDetail];
    if([[RMDatabaseManager shareManager] insertData:messageDetail]){
        self.textView.text = @"";
        self.inputViewHeightContraint.constant = 65;
        [self.inputView setNeedsLayout];
        [self.inputView layoutIfNeeded];
        [self didReceiveMessage];
    }
    
}


@end
