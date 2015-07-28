//
//  ViewController.m
//  InClass10
//
//  Created by student on 7/28/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource>
@property UIImagePickerController *libraryUI;
@property  NSString *dataPath;
@property NSArray* photoUrls;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    self.dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Photos"];
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
        if(error){
            NSLog(@"There was an error creating Photos directory : %@", error);
        }else{
            NSLog(@"Directory created");
        }
    }else{
        [self getImageURLs];
        NSLog(@"Photos directory exists");
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPhotoBtnClicked:(id)sender {
    [self createPhotoAlbumViewer];
}
-(void) createPhotoAlbumViewer{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"photo library view not available");
        return;
    }
    NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    NSLog(@"media Types %@", mediaTypes);
    self.libraryUI = [[UIImagePickerController alloc] init];
    self.libraryUI.mediaTypes = @[@"public.image"];
    self.libraryUI.allowsEditing = NO;
    self.libraryUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.libraryUI.delegate = self;
    [self presentViewController:self.libraryUI
                       animated:YES
                     completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSLog(@"Got info %@", info);
    [self.libraryUI dismissViewControllerAnimated:YES completion:nil];
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSString* urlOfSelectedImage = [(NSURL*)[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    NSString* destinationUrl= [self absolutePathForFilename:[NSString stringWithFormat:@"%@.png", [[NSDate date] description]]];
    NSLog(@"url %@", destinationUrl);
    [UIImagePNGRepresentation(selectedImage)  writeToFile:destinationUrl atomically:YES];
    [self getImageURLs];
}
-(void) getImageURLs{
    NSError* error;
    self.photoUrls = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.dataPath
                                                        error:&error];
    if(error){
        NSLog(@"%@", error);
        return;
    }
    [self.collectionView reloadData];
    NSLog(@"Contents %@", self.photoUrls);
}
-(NSString*) absolutePathForFilename: (NSString*) filename{
    return [NSString stringWithFormat: @"%@/%@", self.dataPath, filename];
}
-(UIImage*) getImageFromFilename: (NSString*) filename{
    NSData *pngData = [NSData dataWithContentsOfFile: [self absolutePathForFilename: filename]];
    return[UIImage imageWithData:pngData];
}

# pragma mark  - UICollectionView implementation
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    if(!cell){
        
    }
    UIImageView* iv = (UIImageView*)[cell viewWithTag:2000];
    iv.image = [self getImageFromFilename: self.photoUrls[indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoUrls.count;
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PhotoViewController* vc = [segue destinationViewController];
    UICollectionViewCell* cell = (UICollectionViewCell*) sender;
    long row = [self.collectionView indexPathForCell:cell].row;
    vc.photoPath = [self absolutePathForFilename:self.photoUrls[row]];
    NSLog(@"Sending model %@", vc.photoPath);
}
@end
