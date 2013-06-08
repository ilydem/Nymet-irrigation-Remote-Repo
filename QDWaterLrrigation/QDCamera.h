

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@protocol QDCameraDelegate <NSObject>

@required
-(void)returnCameraOrSelectImage:(UIImage *)currentImage;//当前拍摄或者选取的照片

@end
@interface QDCamera : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
   
}

@property (nonatomic,retain)UIImageView *resImageView;//要呈现的视图
@property(nonatomic,assign)BOOL isAnimated;//是否动态呈现
@property(nonatomic,retain)UIImage *cameraImage;//拍照的图片
@property(nonatomic,retain)UIViewController *presentViewController;
@property(nonatomic,assign)id<QDCameraDelegate> cameraDelegate;

-(void)cameraOrSelectImageToViewController:(UIViewController*)viewC AndSourceType:(UIImagePickerControllerSourceType)sType;
@end
