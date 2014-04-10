//
//  ViewController.h
//  ImageFetch
//
//  Created by PARAS MITTAL on 30/03/14.
//  Copyright (c) 2014 PARAS MITTAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"
#import "AsyncImageView.h"

typedef enum ScrollDirection {
    ScrollDirectionUp,
    ScrollDirectionDown,
} ScrollDirection;

@class CustomCell;
@interface ViewController : UIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    IBOutlet UICollectionView *imagesCollectionView;
    NSString *searchText;
    NSURL *url;
    int count,indexPathRow;
    float lastContentOffset;
    NSString *infoStr;
    NSMutableArray *URLArr;
    NSMutableArray *infoArr;
    IBOutlet UIView *largeView;
    IBOutlet UIImageView *largeImageView;
}

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
-(IBAction)closeBtn:(id)sender;
-(IBAction)shareTapped;

@end
