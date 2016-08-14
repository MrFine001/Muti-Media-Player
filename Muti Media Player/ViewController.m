//
//  ViewController.m
//  Muti Media Player
//
//  Created by FineRui on 16/7/30.
//  Copyright © 2016年 FanRui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize moviePlayer;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize musicPlayer;

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    NSString *movieFile = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"m4v"];
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:movieFile]];
    self.moviePlayer.allowsAirPlay = YES;
    [self.moviePlayer.view setFrame:CGRectMake(45.0, 20.0, 155.0, 100.0)];
    
    //set up the audio recorder
    NSURL *soundFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@" sound.caf"]];
    NSDictionary *soundSetting;
    soundSetting = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:44100.0],AVSampleRateKey,[NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,[NSNumber numberWithInt:2],AVNumberOfChannelsKey,[NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,nil];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:soundSetting error:nil];
    
    //set up the audio player
    NSURL *noSoundFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"norecording" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:noSoundFileURL error:nil];
    
    //set up the music player
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMovie:(id)sender {
    [self.view addSubview:self.moviePlayer.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMovieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    if([self.toggleFullscreen isOn]) {
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    [self.moviePlayer play];
}

- (void) playMovieFinished:(NSNotification*)theNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [self.moviePlayer.view removeFromSuperview];
}

- (IBAction)recordAudio:(id)sender {
    if([self.recordButtion.titleLabel.text isEqualToString:@"录音"])
    {
        [self.audioRecorder record];
        [self.recordButtion setTitle:@"停止录音" forState:UIControlStateNormal];
    }
    else
    {
        [self.audioRecorder stop];
        [self.recordButtion setTitle:@"录音" forState:UIControlStateNormal];
        NSURL *soundFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"sound.caf"]];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    }
}

- (IBAction)applyFilter:(id)sender {
    CIImage *imageToFilter;
    imageToFilter = [[CIImage alloc] initWithImage:self.displayImageView.image];
    
    CIFilter *activeFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [activeFilter setDefaults];
    [activeFilter setValue:[NSNumber numberWithFloat:0.75] forKey:@"inputIntensity"];
    [activeFilter setValue:imageToFilter forKey:@"inputImage"];
    CIImage *filteredImage = [activeFilter valueForKey:@"outputImage"];
    
    //This varies from the book,because the iOS beta is broken
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionary]];
    CGImageRef cgImage = [context createCGImage:filteredImage fromRect:[imageToFilter extent]];
    UIImage *myNewImage = [UIImage imageWithCGImage:cgImage];
    self.displayImageView.image = myNewImage;
    CGImageRelease(cgImage);
}

- (IBAction)chooseMusic:(id)sender {
    MPMediaPickerController *musicPicker;
    
    [self.musicPlayer stop];
    self.displayNowPlaying.text = @"没有播放的音乐";
    [self.musicPlayButton setTitle:@"播放音乐" forState:UIControlStateNormal];
    
    musicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    
    musicPicker.prompt = @"选择歌曲播放";
    musicPicker.allowsPickingMultipleItems = YES;
    musicPicker.delegate = self;
    
    [self presentModalViewController:musicPicker animated:YES];
}

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    if ([self.toggleCamera isOn]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentModalViewController:imagePicker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    self.displayImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)playMusic:(id)sender {
    if ([self.musicPlayButton.titleLabel.text isEqualToString:@"播放音乐"]) {
        [self.musicPlayer play];
        [self.musicPlayButton setTitle:@"暂停音乐" forState:UIControlStateNormal];
        self.displayNowPlaying.text = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    } else {
        [self.musicPlayer pause];
        [self.musicPlayButton setTitle:@"播放音乐" forState:UIControlStateNormal];
        self.displayNowPlaying.text = @"没有播放的音乐";
    }
        
}

- (IBAction)playAudio:(id)sender {
    [self.audioPlayer play];
}
@end
