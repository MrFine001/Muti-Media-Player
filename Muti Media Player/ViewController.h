//
//  ViewController.h
//  Muti Media Player
//
//  Created by FineRui on 16/7/30.
//  Copyright © 2016年 FanRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreImage/CoreImage.h>

//为了使用UIImagePickerController，必须遵守以下两个协议。
@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *toggleFullscreen;
@property (strong, nonatomic) IBOutlet UIButton *recordButtion;
@property (strong, nonatomic) IBOutlet UISwitch *toggleCamera;
@property (strong, nonatomic) IBOutlet UILabel *displayNowPlaying;
@property (strong, nonatomic) IBOutlet UIButton *musicPlayButton;
@property (strong, nonatomic) IBOutlet UIImageView *displayImageView;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) MPMusicPlayerController *musicPlayer;

- (IBAction)playMovie:(id)sender;
- (IBAction)recordAudio:(id)sender;
- (IBAction)applyFilter:(id)sender;
- (IBAction)chooseMusic:(id)sender;
- (IBAction)chooseImage:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)playAudio:(id)sender;
@end

