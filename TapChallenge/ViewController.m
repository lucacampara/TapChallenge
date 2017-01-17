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
#define Defaults [NSUserDefaults standardUserDefaults]
#define Results @"UserScore"

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
        [Defaults setBool:true forKey:FirstAppLaunch];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        if ([self risultati].count > 0) {
            NSNumber *value = [self risultati].lastObject;
            [self mostraUltimoRisultato: value.intValue];
        }
        
        /*int ultimoRisultato = [self getRisultato];
        if (ultimoRisultato > 0) {
            [self mostraUltimoRisultato: ultimoRisultato];
        }*/
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
    NSString *message = [NSString stringWithFormat:@"Il tuo miglior risultato: %i", risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Migliore risultato" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ACTION PREMUTA");
    }];
    
    [alertViewController  addAction:okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
}

#pragma mark - Persistenza

-(void)salvaRisultato {
    
    NSMutableArray *array = [[Defaults objectForKey:Results] mutableCopy];
    
    if (array == nil) {
        //old
        //array = [[NSMutableArray alloc]init].mutableCopy;
        array = @[].mutableCopy;
    }
    
    // converto l'intero in NSNumber ??
    NSNumber *number = [NSNumber numberWithInt:_tapsCount];
    [array addObject: number];
    
    NSLog(@"array -> %@", array);
    
    NSArray *arrayToBeSaved = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        int value1 = obj1.intValue;
        int value2 = obj2.intValue;
        
        if (value1 == value2) {
            return NSOrderedSame;
        }
        
        if (value1 < value2) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }].mutableCopy;
    
    [Defaults setObject:arrayToBeSaved forKey:Results];
    [Defaults synchronize];
    
    
    /*
    //***vecchia versione per salvare un intero singolo***
     
     
    // salvare un dato nelle preferenze dell'app (Shared Preferences in android)
    [[NSUserDefaults standardUserDefaults] setInteger:_tapsCount forKey:@"TapsCount"];
    
    //per sincronizzare subito i dati
    [[NSUserDefaults standardUserDefaults] synchronize];
     */
}

-(NSArray *)risultati {
    NSArray *array = [Defaults objectForKey:Results];
    
    if (array == nil) {
        
        //inizializzo l'array statico
        array = @[].mutableCopy;
    }
    
    NSLog(@"VALORE  %@", array);
    
    return array;
}

/*-(int)getRisultato {
    // riprendo il valore
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:@"TapsCount"];
    NSLog(@"RISULTATO %i", value);
    
    return value;
}*/

-(bool)firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

@end
