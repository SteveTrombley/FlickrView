//
//  ViewController.m
//  FlickrView
//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import "Photo.h"
#import "SinglePhotoController.h"
#import "PhotoViewController.h"
#import "FlickrKit.h"
#import "PhotoCell.h"
#import "ImageDownloader.h"


@interface PhotoViewController ()

@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic) UIVisualEffectView *vibrancyEffectView;
 @property (strong, nonatomic) UIImage *pictureView;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) UIImageView *imageView;
@property  (strong, nonatomic) UITapGestureRecognizer *singleFingerTap;




@end




#define kAPIKey @"717937bd63ec54fdcd4be61742e5444b"


@implementation PhotoViewController
@synthesize downloadManager = _downloadManager, blurEffectView, vibrancyEffectView, imageData , activity, imageView, singleFingerTap;





- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDownloadManager:nil];
    _searchBar.delegate=self;
    _photosToDisplay=[NSMutableArray new];
    [self loadFlickrPublicFeed];

}

- (DownloadManager *)downloadManager {
    if (!_downloadManager) {
        _downloadManager = [[DownloadManager alloc] init];
    }
    return _downloadManager;
}


//**************************************************************************************
// CollectionView Delegate Methods
//**************************************************************************************

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_photosToDisplay count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCell  *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image=nil;
    cell.backgroundColor = [UIColor blackColor];
    Photo *photoForDisplay=[_photosToDisplay objectAtIndex:indexPath.row];

    if (photoForDisplay.hasImage ) {
        cell.activity.hidden=YES;
        cell.imageView.image=photoForDisplay.thumbnail;
    }
    else
    {

        cell.activity.center=CGPointMake(50, 50);
        [cell.activity startAnimating];
        cell.activity.hidden=NO;
        [self startOperationsForPhotoRecord:photoForDisplay atIndexPath:indexPath];
    }

    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photoForSizing=[_photosToDisplay objectAtIndex:indexPath.row];


    if (photoForSizing.hasImage) { CGSize cellSize = photoForSizing.thumbnail.size; return cellSize; }
    else
    { CGSize cellSize=CGSizeMake(100, 100);

        return cellSize; }


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _photoToShow=[_photosToDisplay objectAtIndex:indexPath.row];
    [self showPicture];
}



- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{  [_collectionView layoutIfNeeded];} completion:^(BOOL finished) {}];}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(void)showPictureView {
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *image=[UIImage imageWithData:imageData];
    imageView=[[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor=[UIColor clearColor];
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
        imageView.layer.masksToBounds = NO;
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0.0f, 6.0f);
        imageView.layer.shadowOpacity = 0.7f;
        imageView.layer.shadowPath = shadowPath.CGPath;
        imageView.center=self.view.center;

        [self.view addSubview:imageView];
        singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePhoto)];
        [self.view addGestureRecognizer:singleFingerTap];


    [activity stopAnimating];
 });

}

-(void)removePhoto {
     [blurEffectView removeFromSuperview];
    [vibrancyEffectView removeFromSuperview];
    [imageView removeFromSuperview];
    [self.view removeGestureRecognizer:singleFingerTap];
     [_collectionView isFirstResponder];
    }

-(void)loadPictureData {
    imageData=[NSData dataWithContentsOfURL:_photoToShow.largeImageUrl];
    NSLog(@"gotData");
}

-(void)showPicture {
    dispatch_async(dispatch_get_main_queue(), ^{



    if(NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.view.frame];
        vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:self.view.frame];
        [self.view addSubview:blurEffectView];
        [self.view addSubview:vibrancyEffectView];}


         activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
         activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
         activity.center=self.view.center;
         [self.view addSubview:activity];});

    NSInvocationOperation *loadPhoto=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadPictureData) object:nil];

    NSInvocationOperation *showPhoto=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showPictureView) object:nil];
    [showPhoto addDependency:loadPhoto];
    NSOperationQueue *q=[[NSOperationQueue alloc] init];
    [q addOperation:loadPhoto];
    [q addOperation:showPhoto];





}



//**************************************************************************************
//  Download Photo and Update Cell When Finished
//**************************************************************************************

- (void)startOperationsForPhotoRecord:(Photo *)photo atIndexPath:(NSIndexPath *)indexPath {


    if (!photo.hasImage) {
        [self startImageDownloadingForRecord:photo atIndexPath:indexPath];

    }
}

- (void)startImageDownloadingForRecord:(Photo *)photo atIndexPath:(NSIndexPath *)indexPath {

    if (![self.downloadManager.downloadsInProgress.allKeys containsObject:indexPath]) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:photo atIndexPath:indexPath delegate:self];
        [self.downloadManager.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.downloadManager.downloadQueue addOperation:imageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {

    NSIndexPath *indexPath = downloader.indexPathInCollectionView;
    PhotoCell *cell=[_collectionView cellForItemAtIndexPath:downloader.indexPathInCollectionView];

    [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    [self.downloadManager.downloadsInProgress removeObjectForKey:indexPath];
}


//***************************
// SearchBar Delegate Methods
//***************************

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    if (searchBar.text.length < 1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your must enter a tag to search for"
                                                     delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [searchBar resignFirstResponder];
    [_photosToDisplay removeAllObjects];
    [_collectionView reloadData];

    [self searchPhotosWithTags:searchBar.text];


}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    [_photosToDisplay removeAllObjects];
    [_collectionView reloadData];
    [self loadFlickrPublicFeed];

}



//**************************************************************************************
//   Flickr API Calls
//  Uses FlickrKit: Documentation can be found at: https://github.com/devedup/FlickrKit
//**************************************************************************************


-(void)loadFlickrPublicFeed {
    FKFlickrPhotosGetRecent *recent = [[FKFlickrPhotosGetRecent alloc] init];
    recent.per_page = @"500";
    self.recentPhotosOp = [[FlickrKit sharedFlickrKit] call:recent completion:^(NSDictionary *response, NSError *error) {
        if (response) {
            for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *thumbUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeThumbnail100 fromPhotoDictionary:photoDictionary];
                NSURL *largeUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall320 fromPhotoDictionary:photoDictionary];
                Photo *newPhoto=[[Photo alloc] init];
                newPhoto.thumbnailUrl=thumbUrl;
                newPhoto.largeImageUrl=largeUrl;
                [_photosToDisplay addObject:newPhoto];
					       }
            dispatch_async(dispatch_get_main_queue(), ^{

                [_collectionView reloadData];
            });

        } else {
            switch (error.code) {
                case FKFlickrPhotosGetRecentError_ServiceCurrentlyUnavailable:

                    break;
                default:
                    break;
					       }

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }

    }];
}


-(void)searchPhotosWithTags:(NSString *)tags {

    tags=[tags stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.flickrSearchOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"tags": tags} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error)  {
        if (response) {
            for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *thumbUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeThumbnail100 fromPhotoDictionary:photoDictionary];
                NSURL *largeUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeVideoMobileMP4 fromPhotoDictionary:photoDictionary];
                Photo *newPhoto=[[Photo alloc] init];
                newPhoto.thumbnailUrl=thumbUrl;
                newPhoto.largeImageUrl=largeUrl;
                [_photosToDisplay addObject:newPhoto];
					       }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });

        } else {
            switch (error.code) {
                case FKFlickrPhotosGetRecentError_ServiceCurrentlyUnavailable:

                    break;
                default:
                    break;
					       }

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

//**************************************************************************************
// UIScrollview Delegate - cancels downloading nonvisible cells
//**************************************************************************************

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self suspendDownloading];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeDownloading];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self loadImagesForOnscreenCells];
    [self resumeDownloading];
}


//**************************************************************************************
// Cancel Off-Screen Downloads - call by scrollview delegate
//**************************************************************************************

- (void)loadImagesForOnscreenCells {


    NSSet *visibleRows = [NSSet setWithArray:[_collectionView indexPathsForVisibleItems]];
    NSMutableSet *pendingDownloads = [NSMutableSet setWithArray:[self.downloadManager.downloadsInProgress allKeys]];
    NSMutableSet *toBeCancelled = [pendingDownloads mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];


    [toBeStarted minusSet:pendingDownloads];
    [toBeCancelled minusSet:visibleRows];

    for (NSIndexPath *anIndexPath in toBeCancelled) {

        ImageDownloader *pendingDownload = [self.downloadManager.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.downloadManager.downloadsInProgress removeObjectForKey:anIndexPath];

    }
    toBeCancelled = nil;

    for (NSIndexPath *anIndexPath in toBeStarted) {

        Photo *photoToProcess = [self.photosToDisplay objectAtIndex:anIndexPath.row];
        [self startOperationsForPhotoRecord:photoToProcess atIndexPath:anIndexPath];
    }
    toBeStarted = nil;

}

- (void)suspendDownloading {
    [self.downloadManager.downloadQueue setSuspended:YES];
}

- (void)resumeDownloading {
    [self.downloadManager.downloadQueue setSuspended:NO];
}

- (void)cancelDownloading {
    [self.downloadManager.downloadQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
@end
