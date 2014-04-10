//
//  FlickrPhoto.h
//  ImageFetch
//
//  Created by PARAS MITTAL on 30/03/14.
//  Copyright (c) 2014 PARAS MITTAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject
@property(nonatomic,strong) UIImage *thumbnail;
@property(nonatomic,strong) UIImage *largeImage;

// Lookup info
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;

@end
