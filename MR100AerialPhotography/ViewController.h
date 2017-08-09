//
//  ViewController.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/8/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TcpManager.h"
#import "FlyControlManager.h"
@class PGQCAEAGLLayer;

@protocol calibDelegate <NSObject>

@optional

-(void)getProgress:(int)progress MagXY:(BOOL)magXY MagZ:(BOOL)magZ Acc:(BOOL)acc;

@end

@interface ViewController : UIViewController

singleton_interface(ViewController)
- (void)makeScreenFull;
-(void)setNewDelegate:(PGQCAEAGLLayer *)newLayer;
-(TcpManager *)getTcpManager;
-(FlyControlManager *)getFlyManager;
-(BOOL)rtspIsValidate;

@property(nonatomic,assign) id <calibDelegate>deleate;
@end

