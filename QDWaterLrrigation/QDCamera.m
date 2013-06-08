

#import "QDCamera.h"
#import <QuartzCore/QuartzCore.h>
@implementation QDCamera
@synthesize isAnimated = _isAnimated;
@synthesize cameraImage = _cameraImage;
@synthesize cameraDelegate = _cameraDelegate;
@synthesize presentViewController = _presentViewController;
@synthesize resImageView = _resImageView;
- (id)init
{
    self = [super init];
    if (self)
    {
        _isAnimated = NO;
        _cameraImage = nil;
    }
    return self;
}

-(void)dealloc
{
    if (_resImageView)
    {
        [_resImageView release];
    }
    [_cameraImage release];
    [_presentViewController release];
    [super dealloc];
    
}

-(void)cameraOrSelectImageToViewController:(UIViewController*)viewC AndSourceType:(UIImagePickerControllerSourceType)sType
{
    if([UIImagePickerController isSourceTypeAvailable:sType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = sType;
        picker.delegate = self;
        _presentViewController = viewC;
        [_presentViewController presentModalViewController:picker animated:_isAnimated];
        [picker release];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"The device does not support this feature"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
    
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate处理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo)
    {
        
        UIImage *originalImage =  (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        _cameraImage = originalImage;
        
        //转换为jpg格式
        _cameraImage = [UIImage imageWithData:UIImageJPEGRepresentation(_cameraImage, 0)];
        
        if (_resImageView)
        {
            [_resImageView setImage:_cameraImage];
            if(UIGraphicsBeginImageContextWithOptions != NULL)
            {
                UIGraphicsBeginImageContextWithOptions(_resImageView.frame.size, NO, 0.0);
            }
            else
            {
                UIGraphicsBeginImageContext(_resImageView.frame.size);
            }
            
            [_resImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _cameraImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        //写入相册库
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(originalImage,nil,nil,nil);
        }
        if (_cameraImage != nil)
        {
            [picker.view addSubview:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]];
            [_cameraDelegate returnCameraOrSelectImage:_cameraImage];
            [_presentViewController dismissModalViewControllerAnimated:_isAnimated];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"Pictures get an exception"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        [[picker parentViewController] dismissModalViewControllerAnimated:_isAnimated];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_presentViewController dismissModalViewControllerAnimated:_isAnimated];
}

@end
