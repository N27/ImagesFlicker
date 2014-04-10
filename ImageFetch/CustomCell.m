//
//  CustomCell.m
//  ImageFetch
//
//  Created by PARAS MITTAL on 30/03/14.
//  Copyright (c) 2014 PARAS MITTAL. All rights reserved.
//

#import "CustomCell.h"
#import "FlickrPhoto.h"

@implementation CustomCell
@synthesize image;
@synthesize imageInfoLbl;
//@synthesize photo;
@synthesize strCheck;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setPhoto:(FlickrPhoto *)flickrPhoto {
    
    if(_photo != flickrPhoto) {
        _photo = flickrPhoto;
    }
    self.image.image = flickrPhoto.thumbnail;
    self.imageInfoLbl.text = @"updates";
    strCheck=@"update";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
