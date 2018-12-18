//
//  DGImagePickerManager.m
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGImagePickerManager.h"
#import "DGIP_Header.h"
//选图
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "DGImageSelectVC.h"
#import <CoreLocation/CoreLocation.h>

@interface DGImagePickerManager()
@property (nonatomic,strong) ALAssetsLibrary * assetsLibrary;

@end

@implementation DGImagePickerManager
#pragma mark - lazy load
-(ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark - init
-(instancetype)initWithMaxImageCount:(NSInteger)maxImageCount{
    self = [super init];
    if (self) {
        self.maxImageCount = maxImageCount;
    }
    return self;
}

#pragma mark - setter
-(void)setMaxImageCount:(NSInteger)maxImageCount{
    if (maxImageCount < 1) {
        _maxImageCount = 1;
        return;
    }
    _maxImageCount = maxImageCount;
}

#pragma mark - 调用代理方法
- (void)callDelegateWithImageArray:(NSArray *)imageArray {
    //在主线程 传图片
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegateViewController manager:self didSlectedImages:imageArray];
    });
}

#pragma mark - jump
- (void)showImagePicker{
    
    //1.授权
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted
        || author == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问照片的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        return;
    }
    
    //2.相册权限
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL photoAlbumAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    if(photoLibraryAvailable && photoAlbumAvailable){
        
        //3.加载图片
        DGIP_WeakS(weakSelf);
        [self loadAssetsGroup:^(NSArray *assetsGroups) {
            
            //4.跳转
            [weakSelf presentToSelectedImageVC:assetsGroups];
        }];
    }
}


-(void)presentToSelectedImageVC:(NSArray *)assetsGroups {
    
    DGIP_WeakS(weakSelf);
    //1.创建
    DGImageSelectVC *imageSelectedVC = [[DGImageSelectVC alloc] init];
    
    //2.设置属性
    if(self.needCircle){
        imageSelectedVC.needClip = YES;
        imageSelectedVC.needCircle = YES;
    }else if(self.needRectangle){
        imageSelectedVC.needClip = YES;
        imageSelectedVC.needRectangle = YES;
        imageSelectedVC.rectangleSize = weakSelf.rectangleSize;
    }
    imageSelectedVC.maxCount = weakSelf.maxImageCount;
    imageSelectedVC.assertsGroupArray = assetsGroups;
    
    //3.设置block
    imageSelectedVC.finishHandler = ^(BOOL isCanceled, BOOL isCamera, NSArray *assets) {
        
        if(!isCanceled){
            //1.相机, assets是包含一个image的数组
            if (isCamera) {
                [weakSelf callDelegateWithImageArray:[assets copy]];
            }else{//2.相册, assets是包含ALAsset的数组
                [weakSelf dealWithAssets:assets];
            }
        }
    };
    
    //4.跳转
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:imageSelectedVC];
    //设置导航,
    [naviC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor}];
    naviC.navigationBar.barTintColor = DGIP_RGB(0, 205, 145);
    naviC.navigationBar.tintColor = UIColor.whiteColor;
    //只有设为UIBarStyleBlack时,子VC的preferredStatusBarStyle才会被调用
    naviC.navigationBar.barStyle = UIBarStyleBlack;
    //naviC.modalPresentationCapturesStatusBarAppearance = YES;
    
    [weakSelf.delegateViewController presentViewController:naviC animated:YES completion:NULL];
}


#pragma mark - 选图片相关
/** 将ALAsset转换成image */
- (void)dealWithAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSMutableArray *mutableArr = [NSMutableArray array];
        for(ALAsset *asset in assets){
            
            UIImage *image;
            if ([asset defaultRepresentation]) {
                //这里把图片压缩成fullScreenImage分辨率上传，可以修改为fullResolutionImage使用原图上传
                image = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage] scale:[asset.defaultRepresentation scale] orientation:UIImageOrientationUp];
            } else {
                image = [UIImage imageWithCGImage:[asset thumbnail]];
                image = [self compressImage:image];
            }
            
            //添加图片
            if (image) {
                [mutableArr addObject:image];
            }
        }
        
        //调代理方法
        [self callDelegateWithImageArray:[mutableArr copy]];
    });
}

/** 获取相册数据 */
- (void)loadAssetsGroup:(void (^)(NSArray *assetsGroups))completion{
    
    NSArray *groupTypes = @[@(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupPhotoStream),
                            @(ALAssetsGroupAlbum)];
    
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in groupTypes) {
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue] usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            
            if (assetsGroup) {
                // Filter the assets group
                [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                
                if (assetsGroup.numberOfAssets > 0) {
                    // Add assets group
                    [assetsGroups addObject:assetsGroup];
                }
            } else {
                numberOfFinishedTypes++;
            }
            
            // Check if the loading finished
            if (numberOfFinishedTypes == groupTypes.count) {
                // Sort assets groups
                NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:groupTypes];
                
                // Call completion block
                if (completion) {
                    completion(sortedAssetsGroups ) ;
                }
            }
        } failureBlock:^(NSError *error) {
            DGIP_Log(@"Error: %@", [error localizedDescription]);
        }];
    }
}

/** 对相册进行排序 */
- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder{
    
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}


/** 压缩图片 */
- (UIImage *)compressImage:(UIImage *)image{
    
    UIImage *resultImage  = image;
    if (resultImage.CGImage) {
        NSData *tempImageData = UIImageJPEGRepresentation(resultImage,0.9);
        if (tempImageData) {
            resultImage = [UIImage imageWithData:tempImageData];
        }
    }
    return resultImage;
}

@end
