//
//  ViewController.m
//  ImageFetch
//
//  Created by PARAS MITTAL on 30/03/14.
//  Copyright (c) 2014 PARAS MITTAL. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize searches;
@synthesize searchResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 0;
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"customCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    [imagesCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    UISwipeGestureRecognizer *swipeTopToBottom = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeTopToBottom.direction = UISwipeGestureRecognizerDirectionUp;
    [imagesCollectionView addGestureRecognizer:swipeTopToBottom];
    lastContentOffset = 500;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]==0) {
        return NO;
    }
    count = 3;
    infoArr = [[NSMutableArray alloc]init];
    URLArr = [[NSMutableArray alloc]init];
    lastContentOffset = 500;
    searchText = [textField text];
    [self loadStr];
    [textField resignFirstResponder];
    [imagesCollectionView reloadData];
    return  YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"customCell" owner:self options:nil];
        cell = (CustomCell*)[nib objectAtIndex:0];
    }
    indexPathRow = indexPath.row;
    cell.image.image = [UIImage imageNamed:@"empty.jpg"];
    if (url) {
        if ((count>3 && indexPath.row == count-1)|| count<= 3) {
            [self loadStr];
            NSString *searchURL = [self loadImages];
            if (searchURL) {
            [cell.image setImageURL:[NSURL URLWithString:searchURL]];
            }
        }else{
            if ([URLArr count]>indexPath.row) {
                [cell.image setImageURL:[NSURL URLWithString:[URLArr objectAtIndex:indexPath.row]]];
            }
        }
    }
    cell.imageInfoLbl.text = [NSString stringWithFormat:@"%@",[infoArr objectAtIndex:indexPath.row]];
    if (indexPath.row == count-1) {
        if ([URLArr count]<=indexPath.row) {
            count--;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *newURLStr = [URLArr objectAtIndex:indexPath.row];
    NSString *lastStr = [newURLStr substringWithRange:NSMakeRange([newURLStr length]-4, 4)];
    newURLStr = [newURLStr substringWithRange:NSMakeRange(0, [newURLStr length]-5)];
    newURLStr = [NSString stringWithFormat:@"%@q%@",newURLStr,lastStr];
    [largeImageView setImageURL:[NSURL URLWithString:newURLStr]];
    [self.view addSubview:largeView];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(320, 130);
    return retval;
}

-(void)swipeDown:(id)sender{
    count++;
    [imagesCollectionView reloadData];
}

-(NSString*)loadImages{
    NSError *error = nil;

    NSString *searchResultString = [NSString stringWithContentsOfURL:url
                                                            encoding:NSUTF8StringEncoding
                                                               error:&error];
    NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:kNilOptions
                                                                        error:&error];
    NSString *searchURL;
    NSArray *objPhotosArr = searchResultsDict[@"photos"][@"photo"];
    if ([objPhotosArr count]==0) {
        return nil;
    }
    NSMutableDictionary *objPhoto = [objPhotosArr objectAtIndex:indexPathRow];
    FlickrPhoto *photo = [[FlickrPhoto alloc] init];
    photo.farm = [objPhoto[@"farm"] intValue];
    photo.server = [objPhoto[@"server"] intValue];
    photo.secret = objPhoto[@"secret"];
    photo.photoID = [objPhoto[@"id"] longLongValue];
    searchURL = [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_m.jpg",photo.farm,photo.server,photo.photoID,photo.secret];
    [infoArr addObject:[NSNumber numberWithLongLong:photo.photoID]];
    [URLArr addObject:searchURL];
            return searchURL;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    ScrollDirection scrollDirection;
    scrollDirection = ScrollDirectionUp;
    if (lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (lastContentOffset <= scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    lastContentOffset = scrollView.contentOffset.y;
    if (scrollDirection == ScrollDirectionDown) {
    count++;
    [imagesCollectionView reloadData];
    }
}

-(void)loadStr{
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrl = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9cc84d678328b786bd24b051f6ff3a5a&text=%@&per_page=%d&format=json&nojsoncallback=1",searchText,count];
    url = [NSURL URLWithString:strUrl];
}

-(IBAction)closeBtn:(id)sender{
    largeImageView.image = Nil;
    [largeView removeFromSuperview];
}

-(IBAction)shareTapped{
        CGRect rect=CGRectMake(0, 0, 320, 560);
        UIRectFrame(rect);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context=UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSArray* dataToShare = @[image];
        UIActivityViewController* activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                          applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:^{}];
}

@end
