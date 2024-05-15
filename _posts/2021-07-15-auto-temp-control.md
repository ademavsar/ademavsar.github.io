---
title: Otomatik Ortam Sıcaklığı Kontrol Sistemi
categories: [Project]
tags: [pic18f46k22]
pin: true  # gönderinin veya sayfanın, listelerde üstte sabitlenip sabitlenmeyeceğini belirler.
image:  # Gönderi veya sayfa ile ilişkili bir resmi tanımlar.
  path: /assets/attachment/autotempcontrol1.png  # resmin yolu.
  lqip:   # düşük kaliteli resim yer tutucusu (low quality image placeholder).
  alt: Project  # resmin alternatif metni, görüntüleyici resmi göremediğinde gösterilir.
---

## Proje Hakkında
Sistem, insan müdahalesi olmadan belirli bir alanın sıcaklığını izleme ve kontrol etme yeteneğine sahiptir. Birincil amacı, sistem ayarlarını bir kullanıcının belirlediği değerlere göre belirli bir alanın sıcaklığını düzenlemektir.

<img src="/assets/attachment/autotempcontrol2.png" alt="project" width="480">

Proje, bir alanın sıcaklığını otomatik olarak kontrol etmek için bir mikrodenetleyici (PIC18F46K22) kullanmaktadır. Bu alan, kontrollü bir sıcaklık gerektiren küçük bir bitki, bir ev veya herhangi bir cihaz olabilir.

İstenilen sıcaklık ayarı bir keypad kullanılarak girilmektedir. Alanın sıcaklığı, analog bir sıcaklık sensörü (LM35) kullanılarak ölçülmektedir. Mikrodenetleyici sürekli olarak sıcaklığı okur ve istenen değerle karşılaştırır. İstenilen değer, ölçülen değerden yüksekse, ısıtıcı alanı ısıtmak için açılır. İstenilen sıcaklığa ulaşıldığında ısıtıcı kapatılır. Öte yandan, ölçülen değer istenen değerden yüksekse, istenen sıcaklığa ulaşılana kadar alanı soğutmak için fan devreye girer. Sıcaklık 40°C veya daha yüksek bir kritik değere ulaşırsa, sesli uyarı sürekli olarak çalacak ve sıcaklık 40°C'nin altına düşene kadar bir LED yanıp sönecektir. LCD ekran sürekli olarak ölçülen sıcaklığı gösterecektir.

Cihaz çalışmaya başladığında, PIC dahili EEPROM'dan referans sıcaklığını okuyacak ve kayıtlı bir değer yoksa kullanıcıdan yeni bir referans sıcaklığı girmesini isteyecektir. PIC bu değeri dahili EEPROM'a kaydettiği için sistem tekrar başladığında önceki girilen referans sıcaklığı aynı kalacaktır. Yeni bir referans sıcaklığı ayarlamak istendiğinde, kurulum menüsüne tekrar erişmek için '*' tuşuna 3 saniye basılı tutulması gerekmektedir. Tamam için ise '#' tuşuna basılması gerekir.

<img src="/assets/attachment/autotempcontrol3.jpg" alt="devre şeması" width="">

Proteus simülasyon kaynak dosyasını [buradan](/assets/attachment/new_project.zip) edinebilirsiniz.

## Simülasyon

<iframe width="560" height="315" src="https://www.youtube.com/embed/I3VD4Dmi2Yc?si=_MiCg_gm0ptYgfYr" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Gerekli Kodlar
Kodlarda fazlasıyla yorum göreceksiniz. Anlaşılır olacaktır.
<br>

```c
// keypad bağlantı portu tanımı
char keypadport at portc;

// lcd pinleri için bit tanımlamaları
sbit lcd_rs at rb4_bit;
sbit lcd_en at rb5_bit;
sbit lcd_d7 at rb3_bit;
sbit lcd_d6 at rb2_bit;
sbit lcd_d5 at rb1_bit;
sbit lcd_d4 at rb0_bit;

// lcd pinlerinin yönlendirilmesi
sbit lcd_rs_direction at trisb4_bit;
sbit lcd_en_direction at trisb5_bit;
sbit lcd_d7_direction at trisb3_bit;
sbit lcd_d6_direction at trisb2_bit;
sbit lcd_d5_direction at trisb1_bit;
sbit lcd_d4_direction at trisb0_bit;

// tanımlamalar
#define heater portd.rd0
#define fan portd.rd1
#define led portd.rd3
#define enter 15
#define clear 13
#define on 1
#define off 0

void main() {
        unsigned short kp,txt[14];   // keypad'den okunan değeri saklayacak değişken
        unsigned int temp_ref;       // kullanıcının ayarladığı referans sıcaklık değeri
        unsigned char intemp;        // lcd ekranında gösterilecek sıcaklık değeri
        unsigned int temp;           // adc'den okunan ham sıcaklık değeri
        float mv, actualtemp;        // mv cinsinden gerçek sıcaklık değeri

        osccon=0x76;                     // osilatör frekansını 8mhz olarak ayarlar
        anselb=0;                        // portb pinlerini dijital giriş/çıkış olarak ayarlar
        anselc=0;                        // portc pinlerini dijital giriş/çıkış olarak ayarlar
        anseld=0;                        // portd pinlerini dijital giriş/çıkış olarak ayarlar
        trisa=0x01;                      // porta'nın ra0 pinini analog giriş olarak ayarlar
        trisb=0;                         // portb pinlerini çıkış olarak ayarlar (lcd için)
        trisd0_bit=0;                    // portd'nin rd0 pinini çıkış olarak ayarlar (heater için)
        trisd1_bit=0;                    // portd'nin rd1 pinini çıkış olarak ayarlar (fan için)
        trisd3_bit=0;                    // portd'nin rd3 pinini çıkış olarak ayarlar (led için)
        trisd3_bit=0;                    // portd'nin rd3 pinini çıkış olarak ayarlar (kullanılmıyor)
        latc.b3=0;                       // rc3 pinini düşük seviyeye çeker
        keypad_init();                   // keypad modülünü başlatır
        lcd_init();                      // lcd modülünü başlatır
        sound_init(&portd,2);            // ses modülünü rd2 pininde başlatır
        lcd_cmd(_lcd_clear);             // lcd ekranını temizler
        lcd_cmd(_lcd_cursor_off);        // lcd imlecini gizler
        lcd_out(1,4,"automatic");        // lcd'nin 1. satırına "automatic" yazar
        lcd_out(2,2,"temp control");     // lcd'nin 2. satırına "temp control" yazar
        lcd_out(3,1,"mesleki");          // lcd'nin 3. satırına "mesleki" yazar
        lcd_out(4,1,"uygulama1");        // lcd'nin 4. satırına "uygulama1" yazar
        delay_ms(2000);                  // 2 saniye bekler

        heater=off;                      // isıtıcıyı kapalı duruma getirir
        fan=off;                         // fanı kapalı duruma getirir

        temp_ref=eeprom_read(0x2);       // eeprom'un 2. adresinden referans sıcaklığını okur
        if((temp_ref>0)&(temp_ref<100)){ // referans sıcaklık 0'dan büyük ve 100'den küçükse
            goto start_program;          // start_program etiketine atlar
        }
        else{
            start:
            lcd_cmd(_lcd_clear);           // lcd ekranını temizler
            lcd_out(1,1,"enter temp ref"); // lcd'ye kullanıcıdan referans sıcaklık girmesini ister
            temp_ref=0;                    // referans sıcaklık değerini sıfırlar
            lcd_out(2,1,"temp ref: ");     // lcd'nin 2. satırına "temp ref: " yazar

            while(1){                      // kullanıcıdan giriş alınana kadar döngüye devam eder
                // yeni referans sıcaklığı değeri
                do
                kp=keypad_key_click();     // keypad'den tuş değeri okur
                while(!kp);                // bir tuşa basılana kadar döngü devam eder
                if (kp==enter)break;       // enter tuşuna basıldıysa döngüyü kırar
                if (kp>3 && kp<8) kp=kp-1;
                if (kp>8 && kp<12) kp=kp-2;
                if (kp==14) kp=0;
                if (kp==clear) goto start;  // clear tuşuna basıldıysa start etiketine gider
                lcd_chr_cp(kp+'0');         // girilen rakamı lcd ekranında gösterir
                temp_ref=(10*temp_ref)+kp;  // girilen yeni rakamı referans sıcaklık değerine ekler
            }
        }

        lcd_cmd(_lcd_clear);             // lcd ekranını temizler
        lcd_out(1,1,"temp ref: ");       // lcd'nin 1. satırına "temp ref: " yazar
        inttostr(temp_ref,txt);          // temp_ref değerini string'e çevirir
        intemp=ltrim(txt);               // sol boşlukları temizler
        lcd_out_cp(intemp);              // temizlenmiş string'i lcd'de gösterir
        eeprom_write(0x02,temp_ref);     // girilen referans sıcaklığı eeprom'un 2. adresine yazar
        lcd_out(2,1,"press # to cont."); // kullanıcıya devam etmek için # tuşuna basmasını söyler

        // # tuşuna basılana kadar bekle
        kp =0;
        while(kp!=enter){
            do
            kp=keypad_key_click();       // keypad'den tuş değeri okur
            while(!kp);                  // bir tuşa basılana kadar döngü devam eder
        }

        start_program:
        lcd_cmd(_lcd_clear);             // lcd ekranını temizler
        lcd_out(1,1,"temp ref: ");       // lcd'nin 1. satırına "temp ref: " yazar
        lcd_chr(1,15,223);               // lcd'ye derece simgesi yazar
        lcd_chr(1,16,'c');               // lcd'ye 'c' (celsius) harfini yazar

        // program döngüsü
        while(1) {

    // referans sıcaklığı ve gerçek sıcaklığı görüntüleme
    temp=adc_read(0);               // an0'dan sıcaklığı oku
    mv=temp*5000.0/1023.0;          // mv'a dönüştür
    actualtemp=mv/10.0;             // dereceyi celsius'a dönüştür
    inttostr(temp_ref,txt);         // referans sıcaklık değerini stringe çevir
    intemp=ltrim(txt);              // stringin solundaki boşlukları temizle

    lcd_out(1,1,"temp ref: ");      // lcd'nin 1. satırına 'temp ref: ' yaz
    lcd_out(1,11,intemp);           // lcd'nin 1. satırına referans sıcaklık değerini yaz
    floattostr(actualtemp,txt);     // gerçek sıcaklık değerini stringe çevir
    txt[4]=0;                       // stringin 4. karakterini null yap (belki bir temizlik amaçlı)
    lcd_out(2,7,txt);               // lcd'nin 2. satırına gerçek sıcaklık değerini yaz
    lcd_out(2,12,"   ");            // lcd'nin 2. satırına boşluk bırak

    // referans sıcaklık ile gerçek sıcaklığın karşılaştırılması
    if(temp_ref>actualtemp){
        heater=on;                 // referans sıcaklık gerçek sıcaklıktan yüksekse ısıtıcıyı aç
        fan=off;                   // fanı kapat
    }

    if(temp_ref<actualtemp){
        heater=off;                // referans sıcaklık gerçek sıcaklıktan düşükse ısıtıcıyı kapat
        fan=on;                    // fanı aç
    }

    if(temp_ref==actualtemp){
        heater = off;              // referans sıcaklık gerçek sıcaklıkla aynıysa ısıtıcıyı kapat
        fan = off;                 // fanı kapat
    }

    // * tuşuna basılıp basılmadığına kontrol et
    kp=keypad_key_press();        // keypad'den tuş değeri oku
    if(kp==clear){
        delay_ms(3000);           // 3 saniye bekle
        kp=keypad_key_press();    // keypad'den tuş değeri tekrar oku
        if(kp==clear){
            goto start;           // clear tuşuna basıldıysa start'a git
        }}

    // buzzer kontrolü
    if (actualtemp>=40){
        sound_play(880,300);       // sıcaklık 40°c veya üzerindeyse ses çal
        led=~led;                  // led'i yanıp söndür
        delay_ms(200);             // 200 ms bekle
    }
    else{
        led = off;                 // değilse led'i kapat
        }
    }
}
```
