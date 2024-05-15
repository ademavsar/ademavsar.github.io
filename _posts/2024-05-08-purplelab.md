---
title: PurpleLab Kurulum ve Kullanımı
categories: [LAB]
tags: [purple lab]
pin: false
image:  # Gönderi veya sayfa ile ilişkili bir resmi tanımlar.
  path: /assets/attachment/purplelab.png  # resmin yolu.
  lqip:   # düşük kaliteli resim yer tutucusu (low quality image placeholder).
  alt: PurpleLab  # resmin alternatif metni, görüntüleyici resmi göremediğinde gösterilir.
---

PurpleLab, siber güvenlik profesyonellerine hızlı bir şekilde algılama kurallarını test etme, günlük simülasyonu yapma ve çeşitli güvenlik işlemlerini gerçekleştirme imkanı sunar. Bu çözüm, kullanıcı dostu bir web arayüzü aracılığıyla kolayca kurulup kullanıma hazırdır.

[PurpleLab GitHub Sayfası](https://github.com/Krook9d/PurpleLab)

## Table of Content

- [Table of Content](#table-of-content)
- [PurpleLab Nedir?](#purplelab-nedir)
- [Kurulum Prosedürü](#kurulum-prosedürü)
	- [Sistem Gereksinimleri](#sistem-gereksinimleri)
	- [Kurulum](#kurulum)
        - [Hesaplar](#hesaplar)
        - [ELK Konfigürasyonu](#elk-konfigürasyonu)
        - [VM Log Konfigürasyonu](#vm-log-konfigürasyonu)
- [Kullanım](#kullanım)
	- [Home Page](#home-page)
	- [Hunting Page](#hunting-page)
	- [Mitre Attack Page](#mitre-attack-page)
	- [Malware Page](#malware-page)
	- [Log simulation Page](#log-simulation-page)
	- [Usage Case Page](#usage-case-page)
	- [Sharing Page](#sharing-page)
	- [Sigma Page](#sigma-page)
	- [Health Page](#health-page)
	- [Admin Page](#admin-page)
- [Splunk App](#splunk-app)
- [API](#api)


## PurpleLab Nedir?

Bu çözüm, tüm bir laboratuvarı kolayca kurmanıza, algılama kurallarınızı oluşturup test etmenize, günlükleri simüle etmenize, testleri gerçekleştirmenize, kötü amaçlı yazılımları indirip çalıştırmanıza, mitre saldırı tekniklerini uygulamanıza, sanal alanı geri yüklemenize ve daha birçok özelliği kullanmanıza olanak tanır.

Laboratuvar şunları içerir:

- Özellikleri kontrol etmek için eksiksiz bir ön uca sahip bir web arayüzü
- Kullanıma hazır bir Windows 10 VM ve forensic tools içeren VirtualBox aracı
- Bir Flask backend
- Bir MySQL veritabanı
- Bir Elasticsearch sunucusu

## Kurulum Prosedürü

> ⚠️ Tamamen temiz bir kurulum için, kurulum prosedürünün gereksinimlerden hesap oluşturmaya kadar olan tüm bölümlerini takip etmeniz gerekmektedir.

> ⚠️ NOT: Bu laboratuvar hiçbir şekilde güçlendirilmemiş olup, temel kimlik bilgileriyle çalışmaktadır. Lütfen, önemsediğiniz herhangi bir ağa bağlamayın veya köprü kurmayın, ya da kendiniz bir PKI, daha iyi kimlik doğrulama sistemleri vb. ile güvence altına alın.

{% drawer PKI (Public Key Infrastructure) %}
PKI (Public Key Infrastructure), yani Kamu Anahtar Altyapısı, dijital kimlik doğrulama ve güvenli veri iletişimi sağlamak için kullanılan bir teknoloji setidir. PKI, şifreleme anahtarlarını, dijital sertifikaları ve sertifika otoritelerini içerir. Bu sistem, kullanıcıların, sunucuların ve uygulamaların dijital olarak imzalanmış sertifikalar aracılığıyla kimliklerini güvenli bir şekilde doğrulamalarını sağlar.

PKI'nın temel kullanım alanları şunlardır:

1. **Veri Şifreleme**: Verileri yetkisiz erişimden korumak için şifreleme sağlar.
2. **Dijital İmzalar**: Dosyaların veya iletilerin değiştirilmediğini ve belirli bir kaynaktan geldiğini doğrulamak için kullanılır.
3. **SSL/TLS Sertifikaları**: Web sitelerinin güvenliğini sağlamak ve kullanıcıların sitenin gerçekliğini doğrulamasına yardımcı olmak için kullanılır.

PKI, özellikle finans, sağlık hizmetleri ve devlet gibi güvenlik gereksinimleri yüksek sektörlerde kritik bir rol oynar.
{% enddrawer %}

### Sistem Gereksinimleri

Minimum Donanım Kaynakları:
- 200 GB
- 8 çekirdek
- 13 GB RAM

Ubuntu Server 22.04 kurulum dosyasını [buradan](https://ubuntu.com/download/server?ref=linuxhandbook.com) indirebilirsiniz.

> ⚠️ Ubuntu Server 23.10 kullanıyorsanız, Python kütüphanesini kurarken sorun yaşarsınız.

> ⚠️ Donanım sanallaştırmayı etkinleştirin ⚠️

#### VirtualBox için

![virtualbox](/assets/attachment/virtualbox.png)

#### VM Ware Workstation için

VM ayarlarına gidin -> İşlemciler -> Sanallaştırma Motoru -> "Intel VT-x/EPT veya AMD-V/RVI'yi sanallaştır" seçeneğini etkinleştirin.

Ana klasörünüzde depoyu indirin :

```bash
git clone https://github.com/Krook9d/PurpleLab.git
```
Dosyaları hazırlayın:

```bash
mv PurpleLab/install.sh
```

### Kurulum

```bash
sudo bash install.sh
```

Kurulumun başlangıcında, bir diyalog kutusu varsayılan ELK SIEM'i kurup kurmayacağınızı veya kendi SIEM'inizi daha sonra kurup kurmayacağınızı soracaktır. Evet cevabını verirseniz, ELK kurulumu atlanacaktır.

> ⚠️ Uyarı: ELK'yı kurmazsanız, ön sayfada PHP hataları görünecektir. Hataların sayfada görünmesini önlemek için kodu düzenleyin.

#### Hesaplar

##### Yönetici Hesabı

Bir yönetici hesabı varsayılan olarak oluşturulur ve ev dizininizdeki ``admin.txt`` dosyasında saklanır.

##### Kullanıcı Hesabı

<img src="/assets/attachment/connexion.png" width="800" alt="Health Page">

Kurulum sonrası yapılması gerekenler:

1. Sunucunuzun IP adresini girin

2. **Register** düğmesine tıklayın

3. Aşağıdaki tüm alanları doldurun:

- **First Name**: Adınız.
- **Last name**: Soyadınız.
- **Analyst level**: Analizci seviyeniz (N1/N2/N3)
- **Avatar**: Bir avatar seçin.
- **Password**: Şifre en az bir büyük harf, bir küçük harf, bir rakam ve bir özel karakter olmak üzere en az 8 karakterden oluşmalıdır.

> ⚠️ Avatar boyutu 1 MB'dan az olmalıdır.

> Bağlantı sonrası karşılama sayfasında bir PHP hatası görünecektir; bu normaldir, sonraki adımda sanal makine log toplama işlemini yapılandıracağız.

#### ELK Konfigürasyonu

1. Ev dizininizdeki ``admin.txt`` dosyasında, kayıt token'ını kopyalayın
Token, "he generated password for the elastic built-in superuser is" satırının altında yer alır. 

Daha sonra "Hunting" sayfasını açmak için ELK'yi açın ve istendiğinde yapıştırın.

2. Token'ı yapıştırdıktan sonra, bir doğrulama kodu istenecektir. İşte bunu nasıl alabileceğiniz:

```bash
sudo /usr/share/kibana/bin/kibana-verification-code
```

> Not: Token'ı yeniden oluşturmak için bu komutu kullanabilirsiniz: `sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana`

Kayıt token'ını gönderirken sorun yaşıyorsanız, elasticsearch servisini yeniden başlatın

```bash
service elasticsearch restart
```

#### VM Log Konfigürasyonu

Sanal makineye bağlanmanız, ``winlogbeats.yml`` dosyasını düzenlemeniz ve bazı komutları çalıştırmanız gerekir.

1. VM'ye bağlanın (IP adresini health.php sayfasında veya `sudo VBoxManage guestproperty get sandbox "/VirtualBox/GuestInfo/Net/0/V4/IP"
` komutu ile alabilirsiniz)

2. Yönetici Powershell İstemcisini açın ve bu klasöre gidin:

```bash
cd 'C:\Program Files\winlogbeat'
```

3. `C:\Program Files\winlogbeat` dosyasını Notepad ya da başka bir metin düzenleyici ile açın. Değişiklikler:
   - ``password:`` yazan yerdeki şifreyi, ``admin.txt`` dosyasında bulunan şifre ile değiştirin.
   
   - 192.168.142.130 IP adresini kendi ELK sunucunuzun adresi ile değiştirin.

   - Güvenilir ``ca_trusted_fingerprint`` değerini almak için, PurpleLab sunucusunda aşağıdaki komutu çalıştırın:

```bash
sudo openssl x509 -fingerprint -sha256 -in /etc/elasticsearch/certs/http_ca.crt | awk -F '=' '/Fingerprint/{print $2}' | tr -d ':'
```

4. Konfigürasyonu test etmek için:

```bash
  & "C:\Program Files\Winlogbeat\winlogbeat.exe" test config -c "C:\Program Files\Winlogbeat\winlogbeat.yml" -e
```

5. Konfigürasyon tamamsa varlıkları aşağıdaki komutla ayarlayın:

```bash
.\winlogbeat.exe setup -e
```

6. Çıktının sonunda ``Loaded Ingest pipelines`` mesajını alırsanız, kurulum başarıyla tamamlanmıştır. VM'yi yeniden başlatabilirsiniz

7. ⚠️ Purplelab sunucusunda, VM yeniden başlatıldıktan sonra, VM'nin bir anlık görüntüsünü alın: "Snapshot1"

```bash
sudo VBoxManage snapshot "sandbox" take "Snapshot1" --description "snapshot before the mess"
```

> ⚠️ Bundan sonra ve elastik arama sunucusunu yapılandırmayı tamamladıktan sonra, hizmetin çalışıp çalışmadığını kontrol edin. Kibana'ya gidin (Purplelab'da Hunting Page), Keşfet sekmesine tıklayın, normalde VM'den Windows olayını göreceksiniz.

Ana sayfadaki göstergeler beslenmelidir.

## Kullanım

PurpleLab sunucusunda yeni bir komut istemi açın ve flask sunucusunu şu adresten başlatın:

```bash
sudo python3 /home/$(logname)/app.py
```

Sanal makinenin çalıştığından emin olun:

```bash
sudo VBoxManage showvminfo sandbox --machinereadable | grep "VMState=" | awk -F'"' '{print $2}'
```

Çalışmıyorsa bu komutu deneyin:

```bash
sudo VBoxManage startvm sandbox --type headless
```

Bu işlemi flask arka ucunu başlattıktan sonra sağlık sayfasından da yapabilirsiniz.

Uygulama tamamen yapılandırıldıktan sonra, tüm sayfaları ve özellikleri irdeleyeceğiz.

### Windows 10 Sandbox VM

<img src="/assets/attachment/forensictools_full.png" alt="Forensictools">

Windows 10 Sandbox sanal makinesi üzerine çeşitli araçlar kurulmuştur. Bu araçlar arasında bir tarayıcı, Atomik Kırmızı Takım modülleri, LibreOffice ve "Forensictools" adlı klasörde toplanmış adli araçlar bulunmaktadır. Daha fazla bilgi için: [Forensictools GitHub Sayfası](https://github.com/cristianzsh/forensictools)

### Home Page

<img src="/assets/attachment/home_page.png" width="800" alt="Health Page">

Bu, Elasticsearch sunucusundan alınan çeşitli KPI'lardan oluşan ana sayfadır. Bu sayfadan, Windows makinesinden gelen olay sayısını, loglardan tespit edilen benzersiz IP sayısını, kullanılan Mitre Saldırı teknik/alt teknik sayısını ve sanal makinadan toplanan logların dağılımını görebilirsiniz.

{% drawer KPI (Key Performance Indicator) %}
Bir işletme veya organizasyonun başarısını ölçmek için kullanılan önemli değerlerdir. Örneğin, bir web sitesinin ne kadar ziyaretçi aldığı veya bir satış ekibinin ne kadar satış yaptığı gibi sayılar, bu göstergeler arasında yer alabilir. Bu sayılar, bir şirketin hedeflerine ne kadar yaklaştığını görmesine yardımcı olur.
{% enddrawer %}

### Hunting Page

<img src="/assets/attachment/mitre.png" width="800" alt="Health Page">

Bu sayfa sizi Kibana sunucusuna yönlendirir, 'Discover' bölümüne giderek VM'nin günlüklerini veya simülasyon sayfasından gelen günlükleri kontrol edin.

### Mitre Attack Page

Bu sayfa, MITRE ATT&CK çerçevesinden teknikleri listelemek ve her teknikle ilgili saldırıları simüle eden payloadları çalıştırmak için kullanılır. Bu, her teknik için algılama kuralları oluşturmak amacıyla yapılır.

Bir teknik aramak için, örneğin T1070 gibi bir teknik için ilk 5 karakteri girmeniz gerekmektedir. Bu teknikle ve alt teknikleriyle ilgili liste yüklenecektir. Daha sonra belirli bir teknik üzerine tıklayabilir ve o teknikle ilgili tüm bilgilerin yer aldığı bir tablo görünecektir. Tablonun en sonunda "run test" butonu bulunur. Bu butona tıklamak, o teknikle ilişkili payloadları VM üzerinde çalıştıracaktır.

Payloadlar, VM üzerine kurulu olan Invoke-Atomic aracı ile çalışır. Bu araç için testlerin listesine buradan ulaşabilirsiniz: https://atomicredteam.io/discovery/

"Mitre ATT&CK update database" butonu, MITRE ATT&CK çerçevesi veritabanını en güncel verilerle güncellemenizi sağlar.

> ⚠️ Bir tekniği görüntülemek için yükleme süresi anlık değildir (2-3 saniye).


### Malware Page

<img src="/assets/attachment/malware.png" width="800" alt="Health Page">

Bu sayfa iki bölüme ayrılmıştır:

"Malware Downloader" bölümü, malware indirmenizi sağlar. Alana, örneğin "Trojan" gibi bir malware türü girin. Bu, "Trojan" etiketi ile https://bazaar.abuse.ch web sitesinde rapor edilen son 10 malware örneğini indirecektir.

İndirme tamamlandığında, malware otomatik olarak Windows VM'ye yüklenir. "Display the content of the CSV" butonu tıklanabilir hale gelir. Buna tıklayarak indirilen malware'lerin özetini görüntüleyebilir ve ardından her birinin "Run" butonlarına tıklayarak onları çalıştırabilirsiniz.

"Malware Uploader" bölümü, kendi yürütülebilir dosyalarınızı, betiklerinizi, DLL'lerinizi vb. yüklemenize olanak tanır.

> ⚠️ Lütfen kabul edilen dosya uzantılarının ``.exe``, ``.dll``, ``.bin``, ``.py``, ``.ps1`` olduğunu unutmayın.

Gönderilen yürütülebilir dosya VM'ye yüklenir ve ardından "List of hosted malware" butonuna tıklayarak mevcut yüklenmiş yürütülebilir dosyaları görüntüleyebilirsiniz.

> Not: Malware, /var/www/html/Downloaded/malware_upload/ dizininden VM'ye indirilir.

### Log simulation Page

<img src="/assets/attachment/log_simulation.png" width="800" alt="Sağlık Sayfası">

Bu sayfa, günlük analizi için daha gerçekçi trafik oluşturmak amacıyla günlükleri simüle etmenizi sağlar. Ayrıca, meşru trafik içinde gizlenmiş şüpheli davranışları tespit etme pratiği yapma fırsatı da sunar.

Şu anda mevcut sürümde iki tür günlük sunulmaktadır:

- Ubuntu Günlüğü (yapım aşamasında)
- Firewall Günlüğü (işlevsel)

Günlüklerin miktarını ve zaman damgaları için zaman aralığını seçebilirsiniz.

Günlükler rastgele değerler içerir; örneğin, firewall günlükleri farklı IP adreslerine, rastgele atanmış "Deny" ve "Accept" değerlerine sahip olacak, ayrıca diğer alanlar da mevcuttur.

Alanlar doldurulduktan ve butona tıklandıktan sonra günlükler üretilir ve SIEM'de bulunabilir.

> Not: Günlükler, firewall.json veya ubuntu.json gibi isimlerle JSON formatında üretilir ve `/var/www/html/Downloaded/Log_simulation` yolu altında bulunur.

### Usage Case Page

<img src="/assets/attachment/usecase.png" width="800" alt="Health Page">

Bu sayfa, özelleştirilmiş kullanım senaryolarını baştan sona oynatmanıza olanak tanır, bir ihlal senaryosunu taklit eder. Şu anda iki kullanım durumu mevcuttur.

Bir kullanım durumu seçildiğinde, iki buton bulunur: biri kullanım durumunu VM üzerinde çalıştırmak için, diğeri ise kullanım durumu detaylarını göstermek için.

Detaylar, kullanım durumunun adım adım senaryosunu, yapılan eylemleri ve herhangi bir IOCs (Tehdit Göstergeleri) sağlar. Ek bir meydan okuma için, detayları göstermeden önce günlükleri analiz ederek tüm ihlal yolunu izlemeyi deneyin.

### Sharing Page

Bu sayfa, basit bir paylaşım platformudur. İyi bir sorgu veya algılama kuralı bulduğunuzda, bu paylaşılan sayfada yayınlayarak diğer analistlere fayda sağlayabilir ve tersi de geçerlidir.

<img src="/assets/attachment/sharing.png" width="800" alt="Health Page">

### Sigma Page

<img src="/assets/attachment/sigma.png" width="800" alt="Sigma Page">

Bu sayfa, "powershell" gibi anahtar kelimeler veya teknik ID'leri kullanarak sigma kurallarını aramanızı sağlar ve ilgili kuralların listesini gösterir. Bir kural seçildiğinde, kuralın sağ üst tarafında oklar olan bir simge bulunur. Bu simgeye tıklandığında "Splunk" ve "Lucene" olmak üzere iki buton görüntülenir; bir butona tıklandığında ise sigma kuralı seçilen dile göre dönüştürülür.

### Health Page

<img src="/assets/attachment/health_page.png" width="800" alt="Health Page">

Bu sayfa, PurpleLab aracının tüm bileşenlerini ve kaynaklarını izlemenizi sağlar.

İlk olarak, aşağıdaki bileşenlerin durumunu göreceksiniz:

- Kibana
- Logstash
- Elastic
- VirtualBox
- Flask Backend

Daha sonra RAM ve disk kullanımını kontrol edebilirsiniz.

Sonraki bölümde, VM hakkında durum, IP adresi ve anlık görüntü dahil bilgiler bulacaksınız.

VM'yi yönetmek için çeşitli butonlar bulunmaktadır.

> ⚠️ Bazen, VM anlık görüntüsünün geri yüklenmesi başarılı olmasına rağmen hata olarak bildirilir. Bunu, VM'ye bağlanarak doğrulayın.

### Admin Page

Bu sayfa, yöneticilerin PurpleLab ortamının yapılandırmasını yönetmeleri için tasarlanmıştır. Yöneticiler burada laboratuvarın yapılandırmasıyla ilgili çeşitli görevleri gerçekleştirebilirler.

#### Anahtar Özellikler

- **LDAP Yapılandırması**: Yöneticilere, merkezi kimlik doğrulama için LDAP ayarlarını yapılandırma ve kaydetme olanağı tanır. Form gönderildikten sonra, yapılandırmanın başarıyla kaydedildiğini teyit eden altta yeşil bir mesaj görüntülenir.

- **API Anahtarı Üretimi**: Yöneticiler, laboratuvarın API uç noktalarıyla etkileşim kurmak ve kimlik doğrulama yapmak için gerekli olan yeni API anahtarları üretebilir. Bu, laboratuvarın bileşenleri ile dış hizmetler veya uygulamalar arasında güvenli iletişimi kolaylaştırır.

#### Yönetici Sayfasına Nasıl Erişilir?

Yönetici sayfasına erişmek için, yönetici hesabıyla (`admin@local.com`) oturum açtığınızdan emin olun.

<img src="/assets/attachment/admin.png" width="800" alt="Health Page">

## Splunk App

[PurpleLab Integration App for Splunk GitHub Sayfası](https://github.com/Krook9d/TA-Purplelab-Splunk)

**Atomic Red Team Test İcraatı**: PurpleLab platformu üzerinden doğrudan Splunk kullanarak Atomic Red Team testlerini başlatın.

**Tehdit Avı Gösterge Tablosu**: PurpleLab'den gelen verilerle desteklenen etkili tehdit avı için Splunk içinde özel bir gösterge tablosu kullanın.

**Sorunsuz Entegrasyon**: PurpleLab ile Splunk arasındaki bağlantıyı kolaylaştırmak için kolay kurulum ve yapılandırma.

## API

PurpleLab API'sini kullanma hakkında daha fazla bilgi için, [API Dokümantasyonu sayfasına](https://github.com/Krook9d/PurpleLab/blob/main/Documentation/flask_app_documentation.md) bakınız.
