---
title: Fundamentals of Splunk
categories: [SIEM]
tags: [splunk]     ## tag names should always be lowercase
---

Splunk, ağ ve makine günlüklerini gerçek zamanlı olarak toplamak, analiz etmek ve ilişkilendirmek için kullanılan önde gelen SIEM (Security Information and Event Management) çözümlerinden biridir. Bu güçlü araç, karmaşık verileri anlamlı bilgilere dönüştürerek, güvenlik tehditlerini ve sistem performansını daha iyi anlamamıza yardımcı olur. Şimdi, Splunk'un temel bileşenlerini ve bu bileşenlerin nasıl çalıştığını, logların nasıl alındığını ve normalleştirildiğini inceleyelim.

<img src="/assets/attachment/splunk.png" alt="splunk" width="">

## Splunk Bileşenleri
Splunk'ın üç ana bileşeni vardır: **Forwarder**, **Indexer** ve **Search Head**.

- **Splunk Forwarder**: İzlenen uç noktalara yüklenen hafif bir ajandır. Temel görevi, toplanan verileri Splunk örneğine yönlendirmektir. Çok az kaynak kullanarak çalışır ve çeşitli kaynaklardan veri toplar: web sunucuları, Windows olay günlükleri, Linux host logları ve veritabanı işlemleri gibi.

- **Splunk Indexer**: Yönlendiricilerden gelen verileri işler. Verileri alır, normalleştirir, veri türünü belirler ve bunları olaylar olarak depolar. Bu işlenmiş veriler, daha sonra aranabilir ve analiz edilebilir.

- **Search Head**: Kullanıcıların indekslenmiş logları arayıp raporladığı yerdir. Kullanıcılar, Splunk Search Processing Language kullanarak terimler aratabilir ve ilgili olayları alabilir. Search Head ayrıca arama sonuçlarını çeşitli görselleştirmeler şeklinde sunma yeteneğine de sahiptir.

<img src="/assets/attachment/splunk-bar.png" alt="splunk bar" width="">

Search head, ayrıca arama sonuçlarını çeşitli görselleştirmeler şeklinde sunma yeteneğine de sahiptir.

<img src="/assets/attachment/splunk-visualization.jpg" alt="splunk visualization" width="">

### Logları Almanın Farklı Yolları
Splunk, logları toplamak için çeşitli yöntemler sunar. Bunlar arasında ağ üzerinden doğrudan veri toplama, log dosyalarını yüklemek ve Splunk Forwarder kullanarak veri toplama bulunmaktadır. Her yöntem, farklı senaryo ve gereksinimlere göre uyarlanmıştır.

## Splunk'ta Gezinme
Splunk'ta gezinmek, veri analiz sürecinin temel bir parçasıdır. Kullanıcı dostu arayüzü, güçlü arama özellikleri ve esnek görselleştirme seçenekleri ile Splunk, her seviyedeki kullanıcı için veri keşfini basit ve etkili hale getirir. İşte Splunk'ta gezinirken bilmeniz gereken temel bileşenler ve ipuçları:

### Splunk Bar
Splunk Bar, Splunk ana ekranınızdaki üst panelde yer alır ve en çok kullanılan özelliklere hızlı erişim sağlar. Mesajlar, ayarlar, aktivite ve yardım gibi bölümler bu panelde bulunur.

### Apps Panel

**Apps Panel,** yüklenen Splunk uygulamalarınızı görüntüler. Her Splunk kurulumunun varsayılan uygulaması **Search & Reporting**'dir, ancak ek uygulamalar yükleyerek işlevselliği genişletebilirsiniz:

- **Search & Reporting:** Temel arama, raporlama ve görselleştirme işlevlerini sunar.
- **Additional Apps:** Splunk Base'den edinebileceğiniz çeşitli uygulamalar ve eklentiler, özel veri kaynakları ve analizler için özel araçlar sunar.

### Home Dashboard
Home Dashboard, varsayılan olarak Splunk'un açılış ekranıdır ve çeşitli gösterge tablolarını içerir. Default dashboards ve custom dashboards ile işlemlerinizi özelleştirebilirsiniz.

### Arama ve Sorgulama

Splunk'un en güçlü özelliklerinden biri, veri üzerinde karmaşık sorgular yapma ve anında sonuçlar alma yeteneğidir:

- **Search Bar (Arama Çubuğu):** Veri üzerinde sorgular yapabileceğiniz alan. Splunk Search Processing Language (SPL), veri üzerinde filtreleme, sıralama, gruplama ve daha fazlasını yapmanıza olanak tanır.
- **Time Picker (Zaman Seçici):** Aramanızı belirli bir zaman dilimi içinde sınırlamanıza olanak tanır.
- **Search Results (Arama Sonuçları):** Sorgunuzun sonuçlarını gösterir. Sonuçları tablolar, grafikler ve diğer görselleştirmeler şeklinde görüntüleyebilirsiniz.

### Görselleştirme ve Raporlama

Analiz sonuçlarınızı anlamak ve paylaşmak için güçlü görselleştirme ve raporlama araçları:

- **Visualization Tabs (Görselleştirme Sekmeleri):** Arama sonuçlarınızı grafikler, haritalar, tablolar ve daha fazlası gibi çeşitli formatlarda görselleştirebilirsiniz.
- **Reports (Raporlar):** Sık kullanılan sorguları ve görselleştirmeleri kaydedebilir ve zamanlanmış raporlar oluşturabilirsiniz.

Splunk'ta gezinmek, veri analizi sürecinizin temel bir parçasıdır ve bu özellikler, karmaşık verileri hızla anlamlı bilgilere dönüştürmenize yardımcı olur. Her özellik, güvenlik, performans izleme veya iş zekası gibi farklı ihtiyaclara hizmet edebilir, bu nedenle kullanım durumunuza en uygun araçları ve teknikleri seçmek önemlidir. Splunk'ta uzmanlaşmak, veri odaklı kararlar almanızı sağlayarak organizasyonunuzun güvenlik ve verimliliğini artıracaktır.

## Adding Data (Veri Ekleme)

Veri ekleme, Splunk'un gücünden tam olarak yararlanmanın ilk adımıdır. Splunk, çeşitli kaynaklardan veri toplayabilir ve bu verileri anlamlı içgörülere dönüştürmek için işler. İşte Splunk'ta veri ekleme sürecinin aşamaları ve her adımda dikkate alınması gereken önemli noktalar:

### Veri Kaynaklarını Anlama

Splunk, çok çeşitli veri kaynaklarından veri alabilir. Bunlar arasında sistem günlükleri, ağ izleme araçları, web sunucuları, uygulama logları, veritabanı logları ve hatta özel API'ler üzerinden gelen veriler bulunur. Veri kaynaklarınızı anlamak, doğru veri türlerini ve formatlarını seçmenize yardımcı olacaktır.

### Veri Ekleme Yöntemleri

Splunk'ta veri eklemenin birkaç yolu vardır:

- **Upload (Yükleme):** Dosyaları doğrudan Splunk arayüzünden yükleyebilirsiniz. Bu, özellikle küçük ölçekli ve tek seferlik veri ekleme işlemleri için uygundur.
- **Monitor (İzleme):** Splunk, belirli bir dizindeki dosyaları veya tüm bir ağ segmentini izleyebilir. Bu yöntem, sürekli veri akışı olan durumlar için idealdir.
- **Forward (Yönlendirme):** Splunk Forwarder'lar, uzak sistemlerden veri toplar ve merkezi bir Splunk sunucusuna yönlendirir. Büyük ölçekli ve dağıtılmış ortamlar için tercih edilen yöntemdir.### veri ekleme süreci

![Splunk add data](https://media.githubusercontent.com/media/ademavsar/ademavsar.github.io/main/assets/attachment/splunkadddata.gif)

Veri Ekleme Süreci şu adımları içerir:

1. **Select Source (Kaynak Seçimi):** Verilerin nereden alınacağını belirtin. Bu, bir dosya yolu, bir ağ adresi veya bir forwarder olabilir.
2. **Select Source Type (Kaynak Türü Seçimi):** Splunk, veri formatınızı ve semantiğini anlamak için kaynak türünü bilmelidir. Doğru kaynak türünü seçmek, verilerin doğru şekilde işlenmesini ve indekslenmesini sağlar.
3. **Input Settings (Girdi Ayarları):** Verilerin hangi indekse kaydedileceğini, hangi hostname ile ilişkilendirileceğini ve diğer ilgili ayarları belirtin. Bu ayarlar, daha sonra verileri sorgularken ve analiz ederken önemli olacaktır.
4. **Review (Gözden Geçirme):** Seçimlerinizi gözden geçirin ve her şeyin doğru olduğundan emin olun.
5. **Done (Tamamla):** Verilerinizi Splunk'a yükleyin. Yükleme işlemi tamamlandığında, veriler analiz için hazır hale gelir.

### İpuçları ve En İyi Uygulamalar

- **Veri Temizliği:** Verilerinizi Splunk'a yüklemek için, gereksiz bilgileri kaldırmak ve verileri düzenlemek üzere temizleyin. Bu, daha hızlı işleme ve daha doğru sonuçlar sağlar.
- **Zaman Damgaları ve Alan Ayırma:** Splunk, verileri düzgün bir şekilde indeksleyebilmesi için zaman damgalarını ve diğer önemli alanları doğru bir şekilde tanımalıdır. Veri kaynaklarınızın bu bilgileri doğru bir şekilde içerdiğinden emin olun.
- **Test ve Doğrulama:** Küçük bir veri seti ile başlayarak, veri eklemenin beklendiği gibi çalıştığını doğrulayın. Doğru sonuçlar alıyorsanız, daha büyük veri setlerine geçin.

Veri ekleme, Splunk ile çalışmanın en temel adımıdır ve doğru yapılması, tüm analiz ve raporlama işlemlerinin başarısını belirler. Süreci dikkatlice planlayarak ve en iyi uygulamaları takip ederek, Splunk'un sunduğu güçlü veri analizi yeteneklerinden en iyi şekilde yararlanabilirsiniz.

## Sonuç

Splunk, olayların araştırılmasında ve güvenlik tehditlerinin yönetiminde kritik bir rol oynar. Bileşenlerinin derinlemesine anlaşılması ve veri toplama ile normalleştirme süreçlerinin etkin kullanılması, bu güçlü aracın sunduğu avantajlardan tam olarak yararlanmanızı sağlar. Splunk'un daha ileri seviye kullanımı ve özellikleri hakkında daha fazla bilgi almak için resmi Splunk belgelerini ve ilgili eğitim materyallerini inceleyebilirsiniz.
