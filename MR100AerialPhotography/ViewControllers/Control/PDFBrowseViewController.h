//
//  PDFBrowseViewController.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/15.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    PDF_DOCUMENT_TYPE_USER, //快速使用手册
    PDF_DOCUMENT_TYPE_PRODUCT,//产品说明书

} PDF_DOCUMENT_TYPE;

@interface PDFBrowseViewController : UIViewController

/**
 *  PDF类型
 */
@property (nonatomic,assign) PDF_DOCUMENT_TYPE  pdfType;

@end
