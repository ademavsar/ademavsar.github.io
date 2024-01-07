---
title: Automatic Temperature Control Kopya
categories: [project]
tags: [pic18f46k22]     ## TAG names should always be lowercase
---

## Proje Hakkında
Sistem, insan müdahalesi olmadan belirli bir alanın sıcaklığını izleme ve kontrol etme özelliğine sahiptir. Birincil amaç; sistemin bir kullanıcı tarafından yapılan ayarlara dayalı olarak belirli bir alanın sıcaklığını yönetmektir.

<img src="/assets/images/projectblockdiagram.png" alt="automatic temperature control block diagram" width="">

Proje, bir alanın sıcaklığını otomatik olarak kontrol etmek için bir mikrodenetleyici kullanıyor. Bu alan, kontrollü bir sıcaklık gerektiren küçük bir bitki, bir ev veya herhangi bir cihaz olabilir. Şekil 1, tasarlanacak sistemin blok diyagramını göstermektedir.

İstenilen sıcaklık ayarı bir keypad kullanılarak girilir. Alanın sıcaklığı analog bir sıcaklık sensörü (LM35) kullanılarak ölçülür. Mikrodenetleyici sıcaklığı sürekli olarak okur ve istenen değerle karşılaştırır. İstenen değer ölçülen değerden yüksek ise ısıtıcı alanı ısıtmak için açılır. İstenilen sıcaklığa ulaşıldığında ısıtıcı kapatılır. Öte yandan ölçülen değer istenen değerden yüksek ise, istenen sıcaklığa ulaşılana kadar alanı soğutmak için fan devreye girer. Sıcaklık 40 derece veya daha yüksek bir kritik değere ulaşırsa sesli uyarı sürekli olarak çalacak ve sıcaklık 40 derece nin altına düşene kadar bir led yanıp sönecek. LCD ekran sürekli olarak ölçülen sıcaklığı gösterecektir.

Cihaz çalışmaya başladığında PIC dahili EEPROM'dan referans sıcaklığını okuyacak ve kayıtlı bir değer yoksa kullanıcıdan yeni bir referans sıcaklığı girmesini isteyecektir. PIC bu değeri dahili EEPROM'a kaydettiği için sistem tekrar başladığında önceki girilen referans sıcaklığı aynı kalacaktır. Yeni bir referans sıcaklığı ayarlamak istendiğinde, kurulum menüsüne tekrar erişmek için * tuşuna 3 saniye basılı tutulması, tamam için ise # tuşuna basılması gerekir.

Projeyle ilgili tüm kaynak dosyaları -yazının sonunda- paylaşıyorum. Kodlarda fazlasıyla yorum göreceksiniz. Anlaşılır olacaktır.

## Projeye Kodları
<br>
<br>

```C
---
char keypadPort at PORTC;				// Keypad bağlantı portu tanımı

---
```
<br>
<br>

## Simülasyon Görüntüleri
## Kaynak Dosyalar