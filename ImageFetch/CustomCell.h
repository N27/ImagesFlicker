//
//  CustomCell.h
//  ImageFetch
//
//  Created by PARAS MITTAL on 30/03/14.
//  Copyright (c) 2014 PARAS MITTAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;
@interface CustomCell : UICollectionViewCell{
}

@property (nonatomic,strong) IBOutlet UIImageView *image;
@property (nonatomic,strong) IBOutlet UILabel *imageInfoLbl;
@property (nonatomic, strong) FlickrPhoto *photo;
@property (nonatomic) NSString *strCheck;

@end
