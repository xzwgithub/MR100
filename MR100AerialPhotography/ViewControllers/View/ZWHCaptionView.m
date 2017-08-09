//
//  ZWHCaptionView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/11/14.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHCaptionView.h"

@interface ZWHCaptionView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
@property(nonatomic, copy) CancelBlock block1;          //
@property(nonatomic, copy) IssueBlock block2;          //

@end

@implementation ZWHCaptionView

- (void)layoutSubviews {

    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
}

+ (instancetype)viewWithPlatformTitle:(NSString *)title image:(UIImage *)image cancelCallBack:(CancelBlock)blo1 issueCallBack:(IssueBlock)blo2 {
    
    ZWHCaptionView *view = [[NSBundle mainBundle] loadNibNamed:@"ZWHCaptionView" owner:self options:nil][0];
    
    view.titleLable.text = [NSString stringWithFormat:@"发布到%@",title];
    view.imageView.image = image;
    view.block1 = blo1;
    view.block2 = blo2;
    view.contentView.layer.cornerRadius = 12;
    view.contentView.layer.masksToBounds = YES;
    view.contentView.layer.borderColor = kBlackColor.CGColor;
    view.contentView.layer.borderWidth = 1;

    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    
    CGRect rect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat h = rect.size.height;
    CGFloat gap = kHeight/2 - h;
    
    if (gap >= 75) {
        return;
    }
    self.centerY.constant = gap - 75;
    CGFloat duration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)noti {
    
    if (self.centerY.constant == 0) {
        return;
    }
    CGFloat duration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.centerY.constant = 0;
    [UIView animateWithDuration:duration animations:^{
        
        [self layoutIfNeeded];
    }];
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.block1) {
        self.block1();
    }
    [self removeFromSuperview];
}

- (IBAction)issueAction:(id)sender {
    
    if (self.block2) {
        if ([self.textView.text isEqualToString:NSLocalizedString(@"write about the mood!",@"写写心情吧！")] || !self.textView.text) {
            self.block2(@"");
            [self removeFromSuperview];
            return;
        }
        self.block2(self.textView.text);
    }
    [self removeFromSuperview];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self endEditing:YES];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
