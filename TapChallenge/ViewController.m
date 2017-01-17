//
//  ViewController.m
//  TapChallenge
//
//  Created by Luca Campara on 13/01/17.
//  Copyright © 2017 Luca Campara. All rights reserved.
//

#import "ViewController.h"

#define GameTimer 1
#define GameTime 5
#define FirstAppLaunch @"FirsrAppLaunch"

@interface ViewController () {
    int _tapsCount;
    int _timeCount;
    
    NSTimer *_gameTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeGame];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if ([self firstAppLaunch] == false) {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:FirstAppLaunch];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        int ultimoRisultato = [self getRisultato];
        if (ultimoRisultato > 0) {
            [self mostraUltimoRisultato: ultimoRisultato];
        }
    }
}

-(void)initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    
    [self.tapsCountLabel setText:@"Tap to play"];
    [self.timeLabel setText:@"Tap Challenge"];
}


#pragma mark - Actions

- (IBAction)buttonPressed:(id)sender {
    
    if (_gameTimer == nil) {
        // @selector invocazione del metodo...
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:nil repeats:true];
    }
    
    _tapsCount++;
    
    [self.tapsCountLabel setText:[NSString stringWithFormat:@"%i", _tapsCount]];
}

-(void)timerTick {
    // stampa il nome della funzione
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _timeCount--;
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%i sec", _timeCount]];
    
    if (_timeCount == 0) {
        // distrugge l'oggetto
        [_gameTimer invalidate];
        _gameTimer = nil;
        // se metto solo quello elimino solo il puntatore e il timer va ancora avanti
        // _gameTimer = nil;
        
        
        NSString *message = [NSString stringWithFormat:@"Hai fatto %i taps", _tapsCount];
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ACTION PREMUTA");
        }];
        
        [alertViewController  addAction:okAction];
        [self presentViewController:alertViewController animated:true completion:nil];
        
        [self salvaRisultato];
        
        [self initializeGame];
        
    }
}

#pragma mark - UI

-(void)mostraUltimoRisultato: (int)risultato {
    NSString *message = [NSString stringWithFormat:@"Ultimo risultato: %i", risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Ultimo risultato" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ACTION PREMUTA");
    }];
    
    [alertViewController  addAction:okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
}

#pragma mark - Persistenza

-(void)salvaRisultato {
    // salvare un dato nelle preferenze dell'app (Shared Preferences in android)
    [[NSUserDefaults standardUserDefaults] setInteger:_tapsCount forKey:@"TapsCount"];
    
    //per sincronizzare subito i dati
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getRisultato {
    // riprendo il valore
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:@"TapsCount"];
    NSLog(@"RISULTATO %i", value);
    
    return value;
}

-(bool)firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

@end
