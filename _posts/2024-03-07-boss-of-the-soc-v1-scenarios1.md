---
title: Boss of the SOC v1 - Web Site Defacement
categories: [CTF]
tags: [splunk]
pin: true
image:  # Gönderi veya sayfa ile ilişkili bir resmi tanımlar.
  path: /assets/attachment/Scenarios1-00.png  # resmin yolu.
  lqip:   # düşük kaliteli resim yer tutucusu (low quality image placeholder).
  alt: Boss of the SOC  # resmin alternatif metni, görüntüleyici resmi göremediğinde gösterilir.
---
Bu laboratuvar, bir APT (Gelişmiş Kalıcı Tehdit) senaryosu ve bir fidye yazılımı senaryosuna odaklanmaktadır. Alice Bluebird adında yeni işe alınmış bir SOC analisti olarak, Wayne Enterprises'ı çeşitli Siber saldırılara karşı koruma ve savunma görevini üstleniyoruz.

## APT senaryosu:

![Web site defacement](/assets/attachment/Scenarios1-01.jpg)

Wayne Enterprises web sitesini ziyaret eden kullanıcılar, web sitesinin değiştirildiğini bildiren raporlar gönderiyor ve bu raporlardan bazıları "p01s0n1vy" adlı APT grubuna atıfta bulunuyor. Görevimiz, web sitesinin değiştirilmesini araştırmak ve Lockheed Martin Kill Chain üzerinden saldırıyı yeniden yapılandırmaya çalışmak.

### #101 What is the likely IPv4 address of someone from the Po1s0n1vy group scanning imreallynotbatman.com for web application vulnerabilities?

```
index=botsv1 imreallynotbatman.com
```

imreallynotbatman.com'u tarayan olası IP adresi için, ``index=botsv1 imreallynotbatman.com`` sorgusu ile kaynak IP adreslerine bakıyoruz. 

![Web site defacement](/assets/attachment/Scenarios1-02.png)

192.168.x.x'in özel IP olduğunu bildiğimiz için, iki şüpheli IP adresi kalıyor. İmreallynotbatman.com'a yapılan çok sayıda istek nedeniyle 40.80.148.42 IP adresi muhtemel şüpheli olarak değerlendirilebilir.

> 40.80.148.42
{: .prompt-tip }

### #102 What company created the web vulnerability scanner used by Po1s0n1vy? Type the company name.

```
index=botsv1 imreallynotbatman.com src_ip="40.80.148.42" scan
| table alert.signature
```

Po1s0n1vy tarafından kullanılan web güvenlik açığı tarayıcısının hangi şirket tarafından oluşturulduğunu bulmak için öncelikle ilk soruda bulduğumuz şüpheli IP adresinden gelen olayları (``src_ip="40.80.148.42"``) inceleyelim. Bu IP adresi, po1s0n1vy grubunun imreallynotbatman.com web sitesini taradığı IP adresiydi.

Anahtar kelime olarak ``scan`` kullanacağız. Firma adı ``alert.signature`` alanında bulunur.

![Web site defacement](/assets/attachment/Scenarios1-03.png)

> Acunetix
{: .prompt-tip }

### #103 What content management system is imreallynotbatman.com likely using?

cms: content management system (içerik yönetim sistemi), teknik bilgiye ihtiyaç duymadan bir web sitesinde içerik oluşturmaya ve yönetmeye yardımcı olan yazılımdır. wordpress, joomla, drupal, magento, squarespace, wix, ghost...

Bu sorunun cevabını bulmak için "imreallynotbatman.com" adresine yönelik tarama yapan IP adresinden başarılı (HTTP durum kodu 200) GET isteklerine bakılmalıdır. İlgili URL/URI alanları incelendiğinde, kullanılan içerik yönetim sistemi (CMS) Joomla olarak belirlenmiştir. 

> URL, URI ve URN, internet üzerinde kaynakları tanımlamak için kullanılan terimlerdir:
> - **URL (Uniform Resource Locator):** Bir web sayfası, görsel veya dosya gibi bir kaynağın tam > > internet adresidir. Örneğin, `https://www.example.com/index.html` bir URL'dir ve bir web sayfasını gösterir.
> - **URI (Uniform Resource Identifier):** Kaynakları tanımlayan daha genel bir terimdir. Tüm URL'ler birer URI'dır, fakat her URI bir URL değildir. Örneğin, `https://www.example.com` bir URI'dır.
> - **URN (Uniform Resource Name):** Kaynağın konumundan bağımsız olarak onu tanımlayan bir isimdir. Örneğin, ISBN ile tanımlanan bir kitap (`urn:isbn:0451450523`) bir URN örneğidir.
> 
> Bu terimler, kaynaklara erişimde ve internet protokollerinde çeşitli şekillerde kullanılır.
{: .prompt-info }


```
index=botsv1 imreallynotbatman.com src_ip="40.80.148.42"
| table url, uri, uri_path
```

![Web site defacement](/assets/attachment/Scenarios1-04.png)

> joomla
{: .prompt-tip }

### #104 What is the name of the file that defaced the imreallynotbatman.com website? Please submit only the name of the file with extension?

Web sunucusunun IP adresini belirlemek için `src_IP="40.80.148.42"` filtresini kullanalım:

```
index=botsv1 imreallynotbatman.com src_ip="40.80.148.42"
```

![Web site defacement](/assets/attachment/Scenarios1-05.png)

Hedef IP adresini kontrol ettiğimizde imreallynotbatman.com web sunucusunun IP adresinin 192.168.250.70 olduğunu anlıyoruz.

Şimdi, bu IP adresini kullanarak web sunucusunun maruz kaldığı zararlı içeriği (defacement image) hangi URL'den çektiğini bulmak için bir sonraki adıma geçelim. Bu işlemi yapmak için, bu IP adresini bir istemci olarak kullanarak hangi URL'lerden istek yapıldığını sorgulayacağız. 

```
index="botsv1" c_ip="192.168.250.70"
| stats count by url
```

Bu sorgu, 192.168.250.70 IP adresinden yapılan tüm istekleri sayacak ve hangi URL'lerin kullanıldığını gösterecektir.

![Web site defacement](/assets/attachment/Scenarios1-06.png)


> poisonivy-is-coming-for-you-batman.jpeg
{: .prompt-tip }

### #105 This attack used dynamic DNS to resolve to the malicious IP. What fully qualified domain name (FQDN) is associated with this attack?

Bu saldırı, kötü amaçlı IP'ye çözümlemek için dinamik DNS kullanmıştır. Bu saldırı hangi tam nitelikli alan adı (FQDN) ile ilişkilidir?

öncelikle zararlı içeriği indiren web sunucusunun (ki bu durumda `192.168.250.70` IP adresidir) hangi tam etki alanı adını (FQDN) kullandığını belirlememiz gerekiyor. Bu, saldırının kaynağını daha iyi anlamamızı sağlayacak.

Öncelikle, web sunucusunun zararlı içeriği hangi FQDN üzerinden aldığını öğrenmeliyiz.

```
index="botsv1" c_ip="192.168.250.70"
| stats count by url
```

Bu sorgu, `192.168.250.70` IP adresinden yapılan tüm istekleri sayar ve kullanılan URL'leri listeler.

![Web site defacement](/assets/attachment/Scenarios1-07.png)

> prankglassinebracket.jumpingcrab.com
{: .prompt-tip }

### #106 What IPv4 address has Po1s0n1vy tied to domains that are pre-staged to attack Wayne Enterprises?

Po1s0n1vy tarafından Wayne Enterprises'a saldırı için önceden hazırlanmış alan adlarına bağlanmış IPv4 adresini bulmamız gerekecek.

Po1s0n1vy ile ilişkilendirilmiş diğer IP adreslerini ortaya çıkarmak için bu sorguyla başlayalım:

```
index="botsv1" imreallynotbatman.com
```

Sorgumuzu gruplama ve sıralama yaparak sonuçları daraltalım:

```
index="botsv1" imreallynotbatman.com
| stats count by src_ip
| sort -count
```

Bu sorgu, `src_ip` alanına göre olayları gruplar, her bir IP adresinden yapılan istek sayısını hesaplar ve bu istek sayısına göre IP adreslerini en fazla istek yapan adresten en az istek yapan adrese doğru sıralar.

![Web site defacement](/assets/attachment/Scenarios1-08.png)

> 23.22.63.114
{: .prompt-tip }

### #108 What IPv4 address is likely attempting a brute force password attack against imreallynotbatman.com?

Brute force saldırılarında genellikle "POST" metodu kullanılır çünkü saldırgan, kullanıcı adı ve şifre kombinasyonlarını sunucuya gönderir. "status" kodları ise, özellikle başarısız giriş denemelerini belirten 401 veya 403 gibi HTTP yanıt kodlarını içerir. Bu da sık tekrarlanan başarısız giriş denemelerini tespit etmekte yardımcı olur.

```
index="botsv1" dest_ip=192.168.250.70 http_method=POST
| stats count by src_ip, form_data, status
```

Bu sorgu, `imreallynotbatman.com` hedefine POST metodu ile yapılan istekleri sayar ve bu istekleri gerçekleştiren kaynak IP adreslerine (`src_ip`), gönderilen form verilerine (`form_data`) ve HTTP durum kodlarına (`status`) göre gruplar.

> Splunk'ta `source` ve `sourcetype`, log verilerini sınıflandırmak ve düzenlemek için kullanılan iki farklı terimdir:
> - **Source:** Verilerin nereden geldiğini belirtir. Bu, genellikle log dosyasının tam yolu, bir cihazdan gelen veri akışının adı veya verilerin toplandığı başka bir kaynak olabilir.
> - **Sourcetype:** Verilerin formatını ve türünü tanımlar. Splunk, `sourcetype` kullanarak verilerin nasıl işleneceğini, hangi ayıklama kurallarının uygulanacağını ve verinin nasıl formatlandığını belirler.
> 
> Kısacası, `source` verinin kaynağını, `sourcetype` ise verinin işlenme şeklini belirtir.
{: .prompt-info }

![Web site defacement](/assets/attachment/Scenarios1-23.png)

> 23.22.63.114
{: .prompt-tip }

### #109 What is the name of the executable uploaded by Po1s0n1vy? (For example, "notepad.exe" or "favicon.ico")

```
index=botsv1 dest_ip=192.168.250.70 sourcetype="stream:http" http_method=POST *.exe
```

``part_filename`` bir dosya yükleme işlemi sırasında kullanılan bir alan adıdır. Bu alan, yüklenen dosyanın adını veya bir dosya yükleme işlemi sırasında kullanılan geçici dosya adını içerebilir.

Örneğin, bir web formu aracılığıyla bir dosya yüklendiğinde, `part_filename` alanı yüklenen dosyanın adını (3791.exe) veya işlem sırasında oluşturulan bir geçici dosya adını (agent.php) tutabilir. Bu alan, yükleme işlemlerini analiz ederken hangi dosyaların yüklendiğini anlamak için kullanılır.

![Web site defacement](/assets/attachment/Scenarios1-09.png)

> 3791.exe
{: .prompt-tip }

### #110 What is the MD5 hash of the executable uploaded?

```
3791.exe md5
```

``3791.exe md5`` sorgusu, dosyanın md5 hash değerlerini içeren tüm olayları getirir. Ancak bu olaylar dosyanın yalnızca varlığını gösterebilir ve dosyanın gerçekten çalıştırılıp çalıştırılmadığına dair bilgi vermez.

Burada ``eventdescrIPtion="process create" `` sorgusu, yalnızca 3791.exe dosyasının sisteme yüklenip çalıştırıldığı olayları filtrelemek içindir. `eventdescrIPtion="process create"` eklemek, dosyanın çalıştırılma anını yakalayarak, yüklenen dosyanın gerçekten sisteme etki ettiği ve bir işlem olarak başlatıldığı olayları daraltır. bu, özellikle zararlı yazılım analizinde, dosyanın yalnızca yüklenmesinden ziyade, aktif olarak çalıştırıldığını doğrulamak için önemlidir. bu şekilde, dosyanın hash değerinin daha doğru ve ilgili bir kontekstte elde edilmesi sağlanır.

> 9709473ab351387aab9e816eff3910b9f28a7a70202e250ed46dba8f820f34a8

"3791.exe" adlı yürütülebilir dosyanın MD5 hash değerini bulmak için önce bu dosyanın kaydedildiği sourcetype'ı belirlemek gerekiyor. Çünkü MD5 hash, dosyanın içeriği hakkında özet bilgi sağlayan bir kriptografik imza olup, genellikle güvenlik ve izleme amaçlı log kayıtlarında kullanılır. Sourcetype, hangi veri kaydında MD5 hash bilgisinin bulunduğunu ve nasıl işleneceğini gösterir.

```
index=botsv1 3791.exe md5
| stats count by sourcetype
```

Bu sorgu, `index="botsv1"` içinde yer alan ve `3791.exe` ve `md5` terimlerini içeren veri kayıtlarını arar. Ardından, bu verileri `sourcetype` değerlerine göre gruplar ve her `sourcetype` için kaç tane kayıt olduğunu sayar.

![Web site defacement](/assets/attachment/Scenarios1-10.png)

Bulduğumuz `sourcetype`'ı sorgumuzda kullanalım:

```
index="botsv1" sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" CommandLine="*3791.exe"
```

Bu sorgu, belirtilen sourcetype içinde `CommandLine` alanında "3791.exe" geçen tüm olayları getirir.

> Splunk'ta `CommandLine` alanı, genellikle bir işlemle ilişkili komut satırı bilgisini içerir. Bu bilgi, bir işlemin nasıl başlatıldığını, hangi parametrelerle çalıştırıldığını ve işlemi başlatan tam komut satırı metnini gösterir. Özellikle güvenlik izleme ve analizinde, `CommandLine` alanı, zararlı yazılımların, scriptlerin veya komut dosyalarının çalıştırılma şekillerini detaylı bir şekilde gözlemlemek için kullanılır. Örneğin, bir yürütülebilir dosyanın (exe) çalıştırılma komutu veya scriptlerin çalıştırılması gibi işlemler bu alan aracılığıyla kaydedilir. Bu sayede, sistem üzerinde gerçekleştirilen işlemlerin kökenlerini ve niyetlerini anlamak mümkün olur. `CommandLine` alanı sayesinde, potansiyel olarak şüpheli veya zararlı faaliyetler detaylı olarak incelenebilir, analiz edilebilir ve güvenlik tehditlerine karşı önlemler alınabilir.
{: .prompt-info }

![Web site defacement](/assets/attachment/Scenarios1-11.png)

> AAE3F5A29935E6ABCC2C2754D12A9AF0
{: .prompt-tip }

### #111 GCPD reported that common TTPs (Tactics, Techniques, Procedures) for the Po1s0n1vy APT group, if initial compromise fails, is to send a spear phishing email with custom malware attached to their intended target. This malware is usually connected to Po1s0n1vys initial attack infrastructure. Using research techniques, provide the SHA256 hash of this malware.

Po1s0n1vy tarafından kullanılan ve önceden belirlenmiş 23.22.63.114 IPv4 adresini kullanarak bu adresle ilişkili kötü amaçlı yazılımları ve bu yazılımların SHA256 hash değerlerini bulmaya çalışacağız.

[VirusTotal - IP address - 23.22.63.114](https://www.virustotal.com/gui/ip-address/23.22.63.114/relations)

![Web site defacement](/assets/attachment/Scenarios1-12.png)

Po1s0n1vy ile ilişkilendirilmiş `MirandaTateScreensaver.scr.exe` dosyasını seçebiliriz. Miranda Tate, Batman ile birlikte görülen kurgusal bir karakterdir.

![Web site defacement](/assets/attachment/Scenarios1-13.png)

> 9709473ab351387aab9e816eff3910b9f28a7a70202e250ed46dba8f820f34a8
{: .prompt-tip }

### #112 What special hex code is associated with the customized malware discussed in  111?

Zararlı yazılımın SHA256 hash değerini kullanarak arama yapalım ve Virustotal'daki "Community" sekmesine giderek bu yazılım hakkında kullanıcıların yaptığı yorumları inceleyelim. Zararlı yazılımla ilişkilendirilen özel hex kodları, genellikle bu bölümde diğer analistler tarafından detaylı şekilde paylaşılır.

![Web site defacement](/assets/attachment/Scenarios1-14.png)

> 53 74 65 76 65 20 42 72 61 6e 74 27 73 20 42 65 61 72 64 20 69 73 20 61 20 70 6f 77 65 72 66 75 6c 20 74 68 69 6e 67 2e 20 46 69 6e 64 20 74 68 69 73 20 6d 65 73 73 61 67 65 20 61 6e 64 20 61 73 6b 20 68 69 6d 20 74 6f 20 62 75 79 20 79 6f 75 20 61 20 62 65 65 72 21 21 21
{: .prompt-tip }

### #114 What was the first brute force password used?

Brute force saldırılarında saldırganlar genellikle "POST" metodunu tercih ederler, çünkü bu metod aracılığıyla kullanıcı adı ve şifre kombinasyonlarını sunucuya göndermek mümkündür. Başarısız giriş denemeleri ise sıklıkla "status" kodlarıyla belirlenir; özellikle 401 ve 403 gibi HTTP yanıt kodları, yetkisiz girişleri ve erişim izni olmayan girişleri ifade eder. Bu kodlar, tekrarlanan başarısız giriş denemelerini tespit etme sürecinde önemli rol oynar.

> [401: Yetkisiz](https://http.dev/401) – Sunucu tarafından yetkisiz erişim teşebbüslerinde kullanılır.  
> [403: Yasak](https://http.dev/403) – Kullanıcının talep ettiği kaynağa erişim izni olmadığını belirten bir yanıt kodudur.
{: .prompt-info }

```
index=botsv1 imreallynotbatman.com sourcetype="stream:http" http_method=POST passwd
| stats count by src, form_data, status, _time | sort by _time
```

Bu sorgu, `imreallynotbatman.com` adresine yönelik HTTP POST isteklerini arar, `passwd` anahtar kelimesini içerenleri `botsv1` indeksinden seçer. İstekleri kaynak IP (`src`), form verileri (`form_data`), HTTP durumu (`status`), ve zaman damgası (`_time`) ile gruplayıp sayar ve zaman damgasına göre sıralar. Bu, oturum açma denemelerini ve zaman içindeki dağılımlarını analiz etmek için kullanılır.

![Web site defacement](/assets/attachment/Scenarios1-15.png)

> 12345678
{: .prompt-tip }

### #115 One of the passwords in the brute force attack is James Brodsky's favorite Coldplay song. We are looking for a six character word on this one. Which is it?

![Web site defacement](/assets/attachment/Scenarios1-16.png)

```
index=botsv1 imreallynotbatman.com sourcetype="stream:http" http_method=POST passwd yellow
| stats count by src, form_data, status, _time 
| sort by _time
```

Bu sorgu, `imreallynotbatman.com` adresine yönelik HTTP POST yöntemiyle yapılan, “passwd” ve “yellow” anahtar kelimelerini içeren istekleri arar. İstekler kaynak IP (`src`), form verileri (`form_data`), durum kodları (`status`), ve zaman (`_time`) bilgileriyle gruplanır ve bu bilgilere göre sayılır. Sonuçlar, olayların zaman sırasına göre sıralanır. Bu, belirli bir şifrenin kullanıldığı oturum açma denemelerini incelemek için kullanılır.

![Web site defacement](/assets/attachment/Scenarios1-17.png)

> yellow
{: .prompt-tip }

### #116 What was the correct password for admin access to the content management system running "imreallynotbatman.com"?

`imreallynotbatman.com` web sitesinin içerik yönetim sistemi için doğru yönetici parolasını bulmamız gerekiyor. Brute force saldırıları sırasında kullanılan parolaları inceleyerek doğru parolanın hangisi olduğunu tespit edebiliriz.

```
index=botsv1 sourcetype="stream:http" form_data=*username*passwd*
| rex field=form_data "passwd=(?<userpasswd>\w+)"
| stats count by src_ip
```

Bu sorgu, `botsv1` indeksinde, `stream:http` sourcetype'ı ile kaydedilen verileri inceleyerek, form verilerinde `username` ve `passwd` ifadelerini içeren HTTP isteklerini arar. `rex` komutu ile `form_data` alanından `passwd=` ifadesinden sonra gelen parolayı çıkarır ve `userpasswd` adında bir alan oluşturur. Bu işlem, parolaları belirlemek için kullanılan düzenli ifade, bir veya daha fazla harf, rakam veya alt çizgi içeren karakterleri yakalar. Son olarak, `stats count by src_ip` komutu, her bir kaynak IP adresinden kaç tane istek yapıldığını sayar. Bu, hangi IP adreslerinin ne kadar sık oturum açma denemesinde bulunduğunu analiz etmek için kullanılabilir, bu da potansiyel tehditleri tespit etmeye yardımcı olur.

> Splunk'ta `rex` komutu, belirli bir alandan düzenli ifade (regex) kullanarak veri çıkarmak için kullanılır. `rex` komutunun kullanımı, `form_data` alanındaki parola bilgisini ayrıştırmak ve yeni bir alan oluşturmak amacıyla gerçekleştirilmiştir.
{: .prompt-info }

```
| rex field=form_data "passwd=(?<userpasswd>\w+)"
```

- **`field=form_data`**: `rex` komutu, işlem yapılacak olan alanı belirlemek için `field` parametresini kullanır. Bu örnekte, `form_data` alanı içindeki veriler üzerinde çalışılacak.
    
- **`"passwd=(?<userpasswd>\w+)"`**: Bu kısım, düzenli ifadeyi (regex) temsil eder. `passwd=` ifadesi, form verileri içinde parola bilgisinin başladığı noktayı belirler.
    
    - **`(?<userpasswd>\w+)`**: Bu ifade, parolaları yakalamak için kullanılır ve bir veya daha fazla harf, rakam veya alt çizgi içerir.
        
    - **`userpasswd`**: Yakalanan parola bilgisinin atanacağı alan adıdır. Böylece, `form_data` içinde bulunan ve `passwd=` ifadesi ile başlayan parola değeri, `userpasswd` adı altında yeni bir alan olarak kaydedilir.

Bu düzenli ifade kullanımı, HTTP form verilerinden kullanıcı adı ve şifre gibi önemli bilgileri etkili bir şekilde ayrıştırmak için kullanılır.

![Web site defacement](/assets/attachment/Scenarios1-18.png)

Sorgu sonucunda dikkat çeken bir IP adresi belirledik: `40.80.148.42`. Bu IP adresinden yapılan isteklerin detaylarını inceleyerek, kullanılan parolayı görebiliyoruz.

```
index=botsv1 sourcetype="stream:http" form_data=*username*passwd* src_ip="40.80.148.42"
| rex field=form_data “passwd=(?<userpasswd>\w+)”
| stats count by form_data
```

![Web site defacement](/assets/attachment/Scenarios1-19.png)

> batman
{: .prompt-tip }

### #117 What was the average password length used in the password brute forcing attempt?

```
index="botsv1" sourcetype="stream:http" imreallynotbatman.com http_method="POST" form_data=*username*passwd*
| rex field=form_data "passwd=(?<password>\w+)"
| eval password_length = len(password)
| stats avg(password_length) as avg_password_length
| eval avg_password_length = round(avg_password_length, 2)
| table avg_password_length
```

Bu sorgu, `imreallynotbatman.com` adresine yönelik HTTP POST isteklerini analiz ederek kullanılan parolaların ortalama uzunluğunu hesaplar. Sorgu, özellikle bu isteklerde bulunan `username` ve `passwd` ifadelerini içeren form verilerine odaklanır.

- **Regex ile Parola Çıkarma:** `rex` komutu, form verilerinden `passwd=` ifadesini takip eden parolaları yakalar ve `password` adlı yeni bir alana kaydeder.
- **Parola Uzunluğunu Hesaplama:** `eval` komutu, yakalanan parolaların uzunluğunu hesaplar ve bu değeri `password_length` olarak saklar.
- **Ortalama Uzunluğu Hesaplama:** `stats` komutu ile tüm parola uzunluklarının ortalaması alınır ve `avg_password_length` adında bir değişkene atanır.
- **Sonuçları Yuvarlama ve Tablo Halinde Sunma:** Ortalama uzunluk değeri iki ondalık basamağa yuvarlanır ve `table` komutu ile sonuçlar tablo formatında gösterilir.

![Web site defacement](/assets/attachment/Scenarios1-20.png)

> 6
{: .prompt-tip }

### #118 How many seconds elapsed between the time the brute force password scan identified the correct password and the compromised login?

Brute force saldırısı sırasında doğru parolanın (`batman`) tespit edilmesi ve bu parolanın başarılı bir şekilde kullanılması arasında geçen süreyi hesaplamak için öncelikle, `batman` parolasının brute force saldırısı sırasında ne zaman tespit edildiğini ve ardından ne zaman başarılı bir şekilde kullanıldığını belirlememiz gerekiyor.

```
index=botsv1 sourcetype=stream:http dest_ip="192.168.250.70" http_method=POST uri_path="/joomla/administrator/index.php"
| rex field=form_data "passwd=(?<password>\w+)"
| search password="batman"
| transaction password
| table _time, password
| sort _time
```

Bu sorgu, hedef IP adresine (`192.168.250.70`) ve belirli bir URI yolu (`/joomla/administrator/index.php`) üzerinden yapılan POST isteklerini inceler. `rex` komutu ile `form_data` alanından `passwd=` ifadesinden sonra gelen parolayı (`batman`) çıkarır ve bu parola ile yapılan tüm istekleri bir işlem (`transaction`) olarak gruplar. Bu gruplama, parolanın ilk kez denendiği ve sonrasında başarılı bir şekilde kullanıldığı zamanları belirlememizi sağlar.

Gruplanan istekler arasında geçen süreyi hesaplamak için, `transaction` komutu kullanılır. Bu komut, belirli bir kriter (bu örnekte `password`) ile gruplanmış olaylar arasındaki zaman farkını (`duration`) hesaplar.

```
| eval duration_seconds = round(duration, 2)
```

Bu sorgu parçası, `transaction` ile hesaplanan süreyi saniye cinsinden yuvarlar ve `duration_seconds` alanında saklar.

Son olarak, hesaplanan süreyi ve ilgili bilgileri bir tablo halinde sunarız. Bu tablo, parolanın tespit edildiği ilk zaman, başarılı kullanım zamanı ve bu iki olay arasında geçen süreyi gösterir.

```
| table _time, password, duration_seconds
```

Sorgumuzun güncel hâli:

```
index=botsv1 sourcetype=stream:http dest_ip="192.168.250.70" http_method=POST uri_path="/joomla/administrator/index.php"
| rex field=form_data "passwd=(?<password>\w+)"
| search password="batman"
| transaction password
| eval duration_seconds = round(duration, 2)
| table _time, password, duration_seconds
```

![Web site defacement](/assets/attachment/Scenarios1-21.png)

Bu sorguların sonucunda, `batman` parolasının tespit edilmesi ve başarılı bir şekilde kullanılması arasında geçen süre **92.17 saniye** olarak hesaplanmıştır. 

> 92.17
{: .prompt-tip }

### #119 How many unique passwords were attempted in the brute force attempt?

Brute force saldırısı sırasında kaç farklı parola denenmiş olduğunu belirlemek için oluşturacağımız sorgu, denenen tüm parolaları toplayacak, yinelenenleri çıkaracak ve benzersiz parola sayısını sayacaktır.

Öncelikle, tüm parola denemelerini toplayacağız ve her bir denemenin benzersiz olup olmadığını kontrol edeceğiz:

```
index=botsv1 sourcetype=stream:http dest_ip="192.168.250.70" http_method=POST uri_path="/joomla/administrator/index.php"
| rex field=form_data "passwd=(?<password>\w+)"
| dedup password
| stats count(password) as unique_passwords
```

- **`index` ve `sourcetype`**: Veri setini ve veri tipini tanımlar. Bu örnekte, HTTP üzerinden yapılan istekler `botsv1` indeksinden ve `stream:http` sourcetype'dan seçilir.
- **`rex`**: `form_data` alanından parola bilgisini çıkarmak için düzenli ifade kullanır. `passwd=` ifadesinden sonra gelen parola bilgisini `password` adlı yeni bir alan olarak kaydeder.
- **`dedup`**: `password` alanındaki tekrar eden değerleri çıkarır, böylece her parola yalnızca bir kez sayılır.
- **`stats`**: Benzersiz parolaların sayısını hesaplar.

![Web site defacement](/assets/attachment/Scenarios1-22.png)

Sonuçlar, deduplikasyon işleminden sonra elde edilen benzersiz parola sayısını gösterir. Bu sayı, brute force saldırısında denenen farklı parola sayısını temsil eder.

> 412
{: .prompt-tip }
