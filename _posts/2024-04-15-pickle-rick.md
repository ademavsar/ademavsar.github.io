---
title: Pickle Rick
categories: [CTF]
tags: [tryhackme]    #tags always lowercase
image:  # Gönderi veya sayfa ile ilişkili bir resmi tanımlar.
  path: https://media.githubusercontent.com/media/ademavsar/ademavsar.github.io/main/assets/attachment/picklerick.gif  # resmin yolu.
  lqip:   # düşük kaliteli resim yer tutucusu (low quality image placeholder).
  alt: Pickle Rick  # resmin alternatif metni, görüntüleyici resmi göremediğinde gösterilir.

---
*A Rick and Morty CTF. Help turn Rick back into a human!*

TryHackMe'deki ilk CTF maceram; kendini yine turşuya çeviren Rick'i normale döndürmek için Rick'in bilgisayarına sızıp, iksiri tamamlamak için gereken üç gizli malzemeyi bulmayı içeriyordu.

[![pickle rick](/assets/attachment/pickle-rick-01.png)](https://tryhackme.com/r/room/picklerick)

## What is the first ingredient that Rick needs?

Makineyi çalıştırdıktan sonra verilen adrese (10.10.224.138) gidelim:

![pickle rick](/assets/attachment/pickle-rick-02.png)

Açılan web sayfasında sayfa kaynağını incelediğimizde bir kullanıcı adı (R1ckRul3s) ile karşılaşıyoruz.

![pickle rick](/assets/attachment/pickle-rick-03.png)

**rustscan** ile hızlı bir port tarama gerçekleştirdikten sonra açık portlar üzerinde nmap ile version taraması yapalım:

```
rustscan -a 10.10.153.191
```

![pickle rick](/assets/attachment/pickle-rick-04.png)

```
nmap -Pn -n -p 22,80 -oN VersionScan -sV 10.10.153.191
```
![pickle rick](/assets/attachment/pickle-rick-05.png)

``searchsploit OpenSSH 8.2`` ve ``searchsploit Apache 2.4.41`` komutları ile, ilgili yazılım sürümleri için exploit database'deki bilinen güvenlik açıklarını kontrol etmekte fayda var.

![pickle rick](/assets/attachment/pickle-rick-06.png)

> Bu sonuçlar, Apache HTTP Server 2.4.41 sürümü için bilinen bazı güvenlik açıklıklarını ve bu açıklıkları istismar etmek için kullanılabilecek exploit'leri gösteriyor. Listelenen exploit'ler, uzaktan kod çalıştırma, hizmet dışı bırakma (DoS) ve dizin gezintisi gibi çeşitli güvenlik açıklıklarını içeriyor. Her bir exploit başlığı, potansiyel güvenlik açığına dair bilgileri ve exploit'in nasıl kullanılacağını içeren bir dosya yoluna sahip. Bu yollar, exploit dosyalarının bulunduğu dizinleri gösterir ve bu dosyaları inceleyerek veya kullanarak sistemdeki güvenlik açıklarını test edebilirsiniz.
{: .prompt-info }

dirsearch ile dizin taraması sonucu:
```
dirsearch -u 10.10.153.191
```

![pickle rick](/assets/attachment/pickle-rick-07.jpg)

- ``/assets/`` genellikle statik dosyaları (css, js, görseller) içerir ve site yapısını daha iyi anlamak için kullanışlı olabilir.
- ``/login.php`` kullanıcı giriş sayfası.
- ``/robots.txt``  web sitesinin hangi kısımlarının arama motorları tarafından taranmaması gerektiğini belirtir. hassas sayfalar hakkında bilgi içerebilir.

İlgili adresleri kontrol ettiğimizde ``/robots.txt`` sayfasında **Wubbalubbadubdub** ifadesiyle karşılaşıyoruz:

![pickle rick](/assets/attachment/pickle-rick-08.png)

Bu ifadenin dizi ile bir bağlantısı var mı diye teyit amaçlı küçük bir arama yapalım:
![pickle rick](/assets/attachment/pickle-rick-09.png)


Kullanıcı adı ve **robots.txt** dosyasındaki ifadeyi ``/login.php`` kullanıcı giriş sayfasında deneyelim:
![pickle rick](/assets/attachment/pickle-rick-10.png)

Başarıyla giriş yaptıktan sonra, açılan komut panelinde birkaç komut (pwd, ls -la...) çalıştıralım:
![pickle rick](/assets/attachment/pickle-rick-11.png)

.txt dosyalarını ``cat`` komutu ile okumaya çalıştığımızda ilgili ekranla karşılaşıyoruz:

![pickle rick](https://media.githubusercontent.com/media/ademavsar/ademavsar.github.io/main/assets/attachment/pickle-rick-12.gif)

``cat`` komutu devre dışı bırakılmış. heyecan aramadan önce alternatif komutları (``more``, ``less``, ``tac``, ``tail``) denerken ``less`` ile açabildiğimizi fark ediyoruz :')

![pickle rick](https://media.githubusercontent.com/media/ademavsar/ademavsar.github.io/main/assets/attachment/pickle-rick-13.gif)

Böylece ilk malzeme tamam.

> **mr. meeseek hair**
{: .prompt-tip }

## What is the second ingredient in Rick’s potion?

``less clue.txt`` çıktısı, dosya sistemini diğer malzemeler için incelememiz gerektiğine işaret ediyor. 

Bir süre sonra **portal.php** dosyasını ``tac`` ile okuyabildik:

![pickle rick](/assets/attachment/pickle-rick-14.png)

``sudo`` komutunun engellenmediğini görüyoruz. Kullanabileceğimiz komutları görmek için ``sudo -l`` çalıştıralım.

![pickle rick](/assets/attachment/pickle-rick-15.png)

`sudo -l` çıktısına göre, `www-data` kullanıcısının `ip-10-10-105-21` sunucusunda herhangi bir komutu parola girmeden yönetici (root) ayrıcalıkları ile çalıştırma yetkisi vardır.

**clue.txt** dosyası, diğer içerikler için dosya sistemine bakmamızı söylüyordu.

![pickle rick](/assets/attachment/pickle-rick-16.png)

**rick** dizinini kontrol edelim:

![pickle rick](/assets/attachment/pickle-rick-17.png)

İkinci malzemeyi bulmak için okuyalım:

![pickle rick](/assets/attachment/pickle-rick-18.png)

> **1 jerry tear**
{: .prompt-tip }

## What is the last and final ingredient?

Son ve nihai malzeme için **root** kullanıcının ana dizinine göz atalım:

![pickle rick](/assets/attachment/pickle-rick-19.png)

**3rd.txt** dosyasını okuyalım:

![pickle rick](/assets/attachment/pickle-rick-20.png)

> **fleeb juice**
{: .prompt-tip }

<!-- Hepsi bu kadar. Şimdi gidip Pickle Rick bölümünü yeniden izleyebiliriz )

![pickle rick](/assets/attachment/pickle-rick-21.png) -->