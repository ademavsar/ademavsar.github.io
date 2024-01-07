---
title: Automatic Temperature Control
categories: [project]
tags: [pic18f46k22]     ## TAG names should always be lowercase
---

## Proje Hakkında
Sistem, insan müdahalesi olmadan belirli bir alanın sıcaklığını izleme ve kontrol etme özelliğine sahiptir. Birincil amaç; sistemin bir kullanıcı tarafından yapılan ayarlara dayalı olarak belirli bir alanın sıcaklığını yönetmektir.

<img src="/assets/images/blockdiagram.png" alt="automatic temperature control block diagram" width="">

Proje, bir alanın sıcaklığını otomatik olarak kontrol etmek için bir mikrodenetleyici kullanıyor. Bu alan, kontrollü bir sıcaklık gerektiren küçük bir bitki, bir ev veya herhangi bir cihaz olabilir. Şekil 1, tasarlanacak sistemin blok diyagramını göstermektedir.

İstenilen sıcaklık ayarı bir keypad kullanılarak girilir. Alanın sıcaklığı analog bir sıcaklık sensörü (LM35) kullanılarak ölçülür. Mikrodenetleyici sıcaklığı sürekli olarak okur ve istenen değerle karşılaştırır. İstenen değer ölçülen değerden yüksek ise ısıtıcı alanı ısıtmak için açılır. İstenilen sıcaklığa ulaşıldığında ısıtıcı kapatılır. Öte yandan ölçülen değer istenen değerden yüksek ise, istenen sıcaklığa ulaşılana kadar alanı soğutmak için fan devreye girer. Sıcaklık 40 derece veya daha yüksek bir kritik değere ulaşırsa sesli uyarı sürekli olarak çalacak ve sıcaklık 40 derece nin altına düşene kadar bir led yanıp sönecek. LCD ekran sürekli olarak ölçülen sıcaklığı gösterecektir.

Cihaz çalışmaya başladığında PIC dahili EEPROM'dan referans sıcaklığını okuyacak ve kayıtlı bir değer yoksa kullanıcıdan yeni bir referans sıcaklığı girmesini isteyecektir. PIC bu değeri dahili EEPROM'a kaydettiği için sistem tekrar başladığında önceki girilen referans sıcaklığı aynı kalacaktır. Yeni bir referans sıcaklığı ayarlamak istendiğinde, kurulum menüsüne tekrar erişmek için * tuşuna 3 saniye basılı tutulması, tamam için ise # tuşuna basılması gerekir.

Projeyle ilgili tüm kaynak dosyaları -yazının sonunda- paylaşıyorum. Kodlarda fazlasıyla yorum göreceksiniz. Anlaşılır olacaktır.

## Projeye Kodları
<br>

```C
deneme 123
```

```C
char keypadPort at PORTC;				// Keypad bağlantı portu tanımı

sbit LCD_RS at RB4_bit;					// LCD pinleri için bit tanımlamaları
sbit LCD_EN at RB5_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D4 at RB0_bit;

sbit LCD_RS_Direction at TRISB4_bit;	// LCD pinlerinin yönlendirilmesi
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

#define HEATER PORTD.RD0				// Tanımlamalar
#define FAN PORTD.RD1
#define LED PORTD.RD3
#define ENTER 15
#define CLEAR 13
#define ON 1
#define OFF 0

void main() {
	unsigned short kp,Txt[14];   // Keypad'den okunan değeri saklayacak değişken, LCD
    unsigned int Temp_Ref;       // Kullanıcının ayarladığı referans sıcaklık değeri
    unsigned char inTemp;        // LCD ekranında gösterilecek sıcaklık değeri
    unsigned int temp;           // ADC'den okunan ham sıcaklık değeri
    float mV, ActualTemp;        // mV cinsinden gerçek sıcaklık değeri
    
	OSCCON=0X76;                     // Osilatör frekansını 8MHz olarak ayarlar
	ANSELB=0;                        // PORTB pinlerini dijital giriş/çıkış olarak ayarlar
	ANSELC=0;                        // PORTC pinlerini dijital giriş/çıkış olarak ayarlar
	ANSELD=0;                        // PORTD pinlerini dijital giriş/çıkış olarak ayarlar
	TRISA=0X01;                      // PORTA'nın RA0 pinini analog giriş olarak ayarlar
	TRISB=0;                         // PORTB pinlerini çıkış olarak ayarlar (LCD için)
	TRISD0_bit=0;                    // PORTD'nin RD0 pinini çıkış olarak ayarlar (heater için)
	TRISD1_bit=0;                    // PORTD'nin RD1 pinini çıkış olarak ayarlar (fan için)
	TRISD3_bit=0;                    // PORTD'nin RD3 pinini çıkış olarak ayarlar (LED için)
	TRISD3_bit=0;                    // PORTD'nin RD3 pinini çıkış olarak ayarlar (kullanılmıyor)
	LATC.B3=0;                       // RC3 pinini düşük seviyeye çeker
	Keypad_Init();                   // Keypad modülünü başlatır
	Lcd_Init();                      // LCD modülünü başlatır
	Sound_Init(&PORTD,2);            // Ses modülünü RD2 pininde başlatır
	Lcd_Cmd(_LCD_CLEAR);             // LCD ekranını temizler
	Lcd_Cmd(_LCD_CURSOR_OFF);        // LCD imlecini gizler
	Lcd_Out(1,4,"Automatic");        // LCD'nin 1. satırına "Automatic" yazar
	Lcd_Out(2,2,"Temp Control");     // LCD'nin 2. satırına "Temp Control" yazar
	Lcd_Out(3,1,"Mesleki");          // LCD'nin 3. satırına "Mesleki" yazar
	Lcd_Out(4,1,"Uygulama1");        // LCD'nin 4. satırına "Uygulama1" yazar
	delay_ms(2000);                  // 2 saniye bekler
	
	HEATER=OFF;                      // Isıtıcıyı kapalı duruma getirir
	FAN=OFF;                         // Fanı kapalı duruma getirir
	
	Temp_Ref=EEPROM_Read(0x2);       // EEPROM'un 2. adresinden referans sıcaklığını okur
	if((Temp_Ref>0)&(Temp_Ref<100)){ // Referans sıcaklık 0'dan büyük ve 100'den küçükse
	    goto START_PROGRAM;          // START_PROGRAM etiketine atlar
	} 
	else{                          
	    START:                       
	    Lcd_Cmd(_LCD_CLEAR);           // LCD ekranını temizler
	    Lcd_Out(1,1,"Enter Temp Ref"); // LCD'ye kullanıcıdan referans sıcaklık girmesini ister
	    Temp_Ref=0;                    // Referans sıcaklık değerini sıfırlar
	    Lcd_Out(2,1,"Temp Ref: ");     // LCD'nin 2. satırına "Temp Ref: " yazar
	
	    while(1){                      // Kullanıcıdan giriş alınana kadar döngüye devam eder
	        // Yeni referans sıcaklığı değeri
	        do
	        kp=Keypad_Key_Click();     // Keypad'den tuş değeri okur
	        while(!kp);                // Bir tuşa basılana kadar döngü devam eder
	        if (kp==ENTER)break;       // ENTER tuşuna basıldıysa döngüyü kırar
	        if (kp>3 && kp<8) kp=kp-1;
	        if (kp>8 && kp<12) kp=kp-2;
	        if (kp==14) kp=0;
	        if (kp==CLEAR) goto START;  // CLEAR tuşuna basıldıysa START etiketine gider
	        Lcd_Chr_Cp(kp+'0');         // Girilen rakamı LCD ekranında gösterir
	        Temp_Ref=(10*Temp_Ref)+kp;  // Girilen yeni rakamı referans sıcaklık değerine ekler
	    }
	}
	
	Lcd_Cmd(_LCD_CLEAR);             // LCD ekranını temizler
	Lcd_Out(1,1,"Temp Ref: ");       // LCD'nin 1. satırına "Temp Ref: " yazar
	intToStr(Temp_Ref,Txt);          // Temp_Ref değerini string'e çevirir
	inTemp=Ltrim(Txt);               // Sol boşlukları temizler
	Lcd_Out_CP(inTemp);              // Temizlenmiş string'i LCD'de gösterir
	EEPROM_Write(0x02,Temp_Ref);     // Girilen referans sıcaklığı EEPROM'un 2. adresine yazar
	Lcd_Out(2,1,"Press # to Cont."); // Kullanıcıya devam etmek için # tuşuna basmasını söyler
	
	// # tuşuna basılana kadar bekle
	kp =0;                            
	while(kp!=ENTER){                
	    do                            
	    kp=Keypad_Key_Click();       // Keypad'den tuş değeri okur
	    while(!kp);                  // Bir tuşa basılana kadar döngü devam eder
	}
	
	START_PROGRAM:                    
	Lcd_Cmd(_LCD_CLEAR);             // LCD ekranını temizler
	Lcd_Out(1,1,"Temp Ref: ");       // LCD'nin 1. satırına "Temp Ref: " yazar
	Lcd_Chr(1,15,223);               // LCD'ye derece simgesi yazar
	Lcd_Chr(1,16,'C');               // LCD'ye 'C' (Celsius) harfini yazar
	
	// Program döngüsü
	while(1) {
    
    // Referans sıcaklığı ve gerçek sıcaklığı görüntüleme
    temp=ADC_Read(0);               // AN0'dan sıcaklığı oku
    mV=temp*5000.0/1023.0;          // mV'a dönüştür
    ActualTemp=mV/10.0;             // Dereceyi celsius'a dönüştür
    intToStr(Temp_Ref,Txt);         // Referans sıcaklık değerini stringe çevir
    inTemp=Ltrim(Txt);              // Stringin solundaki boşlukları temizle

    Lcd_Out(1,1,"Temp Ref: ");      // LCD'nin 1. satırına 'Temp Ref: ' yaz
    Lcd_Out(1,11,inTemp);           // LCD'nin 1. satırına referans sıcaklık değerini yaz
    FloatToStr(ActualTemp,Txt);     // Gerçek sıcaklık değerini stringe çevir
    Txt[4]=0;                       // Stringin 4. karakterini NULL yap (belki bir temizlik amaçlı)
    Lcd_Out(2,7,Txt);               // LCD'nin 2. satırına gerçek sıcaklık değerini yaz
    Lcd_Out(2,12,"   ");            // LCD'nin 2. satırına boşluk bırak

    // Referans sıcaklık ile gerçek sıcaklığın karşılaştırılması
    if(Temp_Ref>ActualTemp){
        HEATER=ON;                 // Eğer referans sıcaklık gerçek sıcaklıktan yüksekse ısıtıcıyı aç
        FAN=OFF;                   // Fanı kapat
    }

    if(Temp_Ref<ActualTemp){
        HEATER=OFF;                // Eğer referans sıcaklık gerçek sıcaklıktan düşükse ısıtıcıyı kapat
        FAN=ON;                    // Fanı aç
    }

    if(Temp_Ref==ActualTemp){
        HEATER = OFF;              // Eğer referans sıcaklık gerçek sıcaklıkla aynıysa ısıtıcıyı kapat
        FAN = OFF;                 // Fanı kapat
    }

    // * tuşuna basılıp basılmadığına kontrol et
    kp=Keypad_Key_Press();        // Keypad'den tuş değeri oku
    if(kp==CLEAR){
        delay_ms(3000);           // 3 saniye bekle
        kp=Keypad_Key_Press();    // Keypad'den tuş değeri tekrar oku
        if(kp==CLEAR){
            goto START;           // Eğer CLEAR tuşuna basıldıysa START'a git
        }}

    // Buzzer kontrolü
    if (ActualTemp>=40){
        Sound_Play(880,300);       // Eğer sıcaklık 40 derece veya üzerindeyse ses çal
        LED=~LED;                  // LED'i yanıp söndür
        delay_ms(200);             // 200 ms bekle
    }
    else{
        LED = OFF;                 // Değilse LED'i kapat
    	}
	}
}
```
<br>

## Simülasyon Görüntüleri
## Kaynak Dosyalar