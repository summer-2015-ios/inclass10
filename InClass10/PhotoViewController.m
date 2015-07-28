//
//  PhotoViewController.m
//  InClass10
//
//  Created by student on 7/28/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [self imageFromPath:self.photoPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deleteClicked:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Photo"
                                                                   message:@"Do you really want to delete this photo from this app?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSError* error;
                                                              [[NSFileManager defaultManager] removeItemAtPath:self.photoPath error:&error];
                                                              if(error){
                                                                  NSLog(@"Error deleting photo : %@", error);
                                                                  return;
                                                              }
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];

    [alert addAction:okAction];
     [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(UIImage*) imageFromPath:(NSString*)path{
    NSData *pngData = [NSData dataWithContentsOfFile: path];
    return[UIImage imageWithData:pngData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
