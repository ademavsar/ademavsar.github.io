---
title: Boss of the SOC v1 - Ransomware
categories: [CTF]
tags: [splunk]
pin: true
image:  # Gönderi veya sayfa ile ilişkili bir resmi tanımlar.
  path: /assets/attachment/Scenarios2-00.png  # resmin yolu.
  lqip:   # düşük kaliteli resim yer tutucusu (low quality image placeholder).
  alt: Boss of the SOC  # resmin alternatif metni, görüntüleyici resmi göremediğinde gösterilir.
---

Bu laboratuvar, bir APT (Gelişmiş Kalıcı Tehdit) senaryosu ve bir fidye yazılımı senaryosuna odaklanmaktadır. Alice Bluebird adında yeni işe alınmış bir SOC analisti olarak, Wayne Enterprises'ı çeşitli Siber saldırılara karşı koruma ve savunma görevini üstleniyoruz.

## Ransomware senaryosu:

![Ransomware](/assets/attachment/Scenarios2-01.jpg)

Wayne Enterprises web sitesini ziyaret eden kullanıcılar, web sitesinin değiştirildiğini bildiren raporlar gönderiyor ve bu raporlardan bazıları "p01s0n1vy" adlı APT grubuna atıfta bulunuyor. Görevimiz, web sitesinin değiştirilmesini araştırmak ve Lockheed Martin Kill Chain üzerinden saldırıyı yeniden yapılandırmaya çalışmak.

### #200 What was the most likely IPv4 address of we8105desk on 24AUG2016?

``we8105desk`` çalışma istasyonuna ait olayları incelemek için ilk olarak bu istasyonun adını içeren kayıtları sorgulayacağız. Bu sayede, bu istasyondan yapılan ağ isteklerinin kaynak IP adreslerini belirleyebiliriz.

```
index=botsv1 host=we8105desk
| stats count by src_ip
| sort -count
```

Bu sorgu, `we8105desk` isimli hosttan gelen trafiği inceleyerek, hangi kaynak IP adreslerinin bu host tarafından kullanıldığını ve her bir IP adresinden kaç olay kaydedildiğini gösterir. En sık kullanılan IP adresi, bu hostun o tarihteki en muhtemel IP adresi olarak kabul edilebilir.

![Ransomware](/assets/attachment/Scenarios2-02.png)

> 192.168.250.100
{: .prompt-tip }

### #201 Amongst the Suricata signatures that detected the Cerber malware, which one alerted the fewest number of times? Submit ONLY the signature ID value as the answer.

Cerber zararlı yazılımını tespit eden Suricata imzalarını aramak için, bu zararlı yazılımı içeren olayları barındıran Suricata kayıtlarını incelememiz gerekecek.

```
index=botsv1 sourcetype=suricata cerber
| stats count by alert.signature_id
```

Bu sorgu, `cerber` anahtar kelimesi içeren olayları `alert.signature_id` alanına göre gruplar ve her bir imzanın kaç kez uyarı verdiğini sayar.

![Ransomware](/assets/attachment/Scenarios2-03.png)

> 2816763
{: .prompt-tip }

### #202 What fully qualified domain name (FQDN) does the Cerber ransomware attempt to direct the user to at the end of its encryption phase?

Cerber ransomware'in şifreleme fazının sonunda kullanıcıyı yönlendirmeye çalıştığı tam etki alanı adını (FQDN) belirlemek için, zararlı yazılımın enfekte ettiği makinenin DNS sorgularını inceleyeceğiz.

Öncelikle, Cerber ransomware tarafından enfekte edilen makinenin IP adresinden yapılan DNS sorgularını inceleyeceğiz. Bu sorgular, ransomware'in şifreleme işlemi tamamlandıktan sonra kullanıcıyı yönlendirmeye çalıştığı domain adlarını içerebilir.

```
index="botsv1" src_ip="192.168.250.100" sourcetype="stream:dns"
| table _time, query
| sort -_time
```

Cerber'in kullanabileceği domain adlarını daha da daraltmak için, bilinen yasal domainleri dışlayacağız.

```
index="botsv1" src_ip="192.168.250.100" sourcetype="stream:dns"
| search NOT query=*.local AND NOT query=*.arpa AND NOT query=*.microsoft.com AND query=*.*
| table _time, query
| sort -_time
```

Bu sorgu, `192.168.250.100` IP adresinden gelen DNS sorgularını filtreler. ``.local``, ``.arpa`` ve ``.microsoft.com`` gibi belirli yerel ve özel alan adlarını içeren DNS sorgularını hariç tutar. Bu filtreden sonra kalan DNS sorgularını zaman damgasına göre, en yeniden en eskiye doğru sıralar.

![Ransomware](/assets/attachment/Scenarios2-04.png)

> cerberhhyed5frqa.xmfir0.win
{: .prompt-tip }

### #203 What was the first suspicious domain visited by we8105desk on 24AUG2016?

#202'deki sorguyu bu soru için de kullanacağız.

```
index="botsv1" src_ip="192.168.250.100" sourcetype="stream:dns"
| search NOT query=*.local AND NOT query=*.arpa AND NOT query=*.microsoft.com AND query=*.*
| table _time, query
| sort -_time
```

![Ransomware](/assets/attachment/Scenarios2-05.png)

> solidaritedeproximite.org
{: .prompt-tip }

### #204 During the initial Cerber infection a VB script is run. The entire script from this execution, pre-pended by the name of the launching .exe, can be found in a field in Splunk. What is the length of the value of this field?

Windows Sysmon kaynak türünde .vbs dosyaları için genel arama yaparak CommandLine alanını içeren sonuçları inceleyebiliriz. Dikkat çeken, ``cmd.exe`` ile başlayan ve karmaşıklaştırılmış gibi görünen çok sayıda karakter içeren bir sonuç üzerine yoğunlaşalım.

```
index=botsv1 sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" host=we8105desk *.vbs
| table _time, CommandLine
```

![Ransomware](/assets/attachment/Scenarios2-06.png)

Karakter uzunluğunu hesaplamak için, eval komutunu kullanarak CommandLine alanının uzunluğunu belirleyecek şekilde sorgumuzu güncelleyelim.

```
index=botsv1 sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" host=we8105desk *.vbs
| eval cmdlength=len(CommandLine)
| table _time, cmdlength, CommandLine
```

![Ransomware](/assets/attachment/Scenarios2-07.png)

> 4490
{: .prompt-tip }

### #205 What is the name of the USB key inserted by Bob Smith?

Bob Smith tarafından takılan USB anahtarının adını belirlemek için Windows kayıt defteri olaylarına odaklanacağız. USB anahtarlarının bilgileri genellikle `WinRegistry` sourcetype altında loglanır ve `FriendlyName` adıyla kaydedilir.

```
index=botsv1 sourcetype="winregistry" host=we8105desk USBSTOR friendlyname
| table registry_value_data
```

Bu sorgu, `botsv1` indeksindeki, `winregistry` sourcetype'a ve `we8105desk` host'una ait, `USBSTOR` ve `friendlyname` ile ilişkilendirilmiş kayıt defteri girişlerini arar. Ardından, bu kayıtlardan `registry_value_data` alanını içeren verileri tablo halinde listeler. Bu tablo, bağlanan USB cihazlarının tanımlayıcı bilgilerini veya adlarını gösterir.

![Ransomware](/assets/attachment/Scenarios2-08.png)

> MIRANDA_PRI
{: .prompt-tip }

### #206 Bob Smith's workstation (we8105desk) was connected to a file server during the ransomware outbreak. What is the IPv4 address of the file server?

Bob Smith'in iş istasyonunun ransomware saldırısı sırasında hangi dosya sunucusuna bağlı olduğunu belirlemek için, öncelikle iş istasyonunun IP adresi olan `192.168.250.100` üzerinden dosya sunucusuyla olan iletişimi filtrelememiz gerekiyor. Bu süreçte, ``stream:smb`` kaynak türüne odaklanıyoruz çünkü bu, SMB protokolünün kullanıldığı dosya transferlerini gösterir.

> SMB (Server Message Block) protokolü; dosya, yazıcı ve diğer kaynakların ağ üzerinden paylaşımını sağlayan bir iletişim protokolüdür. Windows tabanlı sistemlerde çok yaygın olarak kullanılır ve Microsoft'un ağ dosya sistemlerinin birincil protokolüdür.
{: .prompt-info }

```
index="botsv1" src_ip=192.168.250.100 sourcetype="stream:smb"
```

Bu sorgu, belirtilen IP adresinden SMB protokolü kullanılarak yapılan tüm ağ trafiğini listeler. 
Ardından, bu trafiğin hangi hedef IP'ye gittiğini analiz ediyoruz. Dosya sunucusuna en çok veri gönderilmiş olan IP adresi, dosya sunucusunun IP adresi olarak kabul edilir.

```
| stats sum(bytes_out) by dest_ip
| sort - sum(bytes_out)
```

Bu komutlar, `bytes_out` alanındaki değerleri toplayarak hangi hedef IP'nin en çok veri aldığını belirler ve bu bilgileri ters sıralı olarak listeler. En üstte yer alan IP adresi, en çok veri alan ve dolayısıyla dosya sunucusu olarak kabul edilen IP adresidir. Güncel sorgumuz:

```
index="botsv1" src_ip=192.168.250.100 sourcetype="stream:smb"
| stats sum(bytes_out) by dest_ip
| sort - sum(bytes_out)
```

![Ransomware](/assets/attachment/Scenarios2-09.png)

> 192.168.250.20
{: .prompt-tip }

### #207 How many distinct PDFs did the ransomware encrypt on the remote file server?

Öncelikle, PDF dosyalarını barındıran ilgili SMB dosya sunucusunun adını belirlememiz gerekiyor. Bu soruya yaklaşmanın bir yolu, tüm PDF dosyalarını döndürecek geniş bir SPL sorgusu çalıştırmak ve host alanında ilginç bir şeyler bulup bulamayacağımızı görmektir.

![Ransomware](/assets/attachment/Scenarios2-10.png)

Yalnızca 3 host olduğunu görüyoruz. ``splunk-02`` veya ``we8105desk`` (Bob'un makinesi) olmadığına göre ``we9041srv`` olmalıdır. Bob'un makinesi masaüstü için "desk" ile biterken ``we9041srv`` ise muhtemelen sunucu için "srv" ile bitiyor.

Host adını öğrendiğimize göre, Splunk sorgumuzu SMB uzak sunucusuna odaklanacak şekilde güncelleyebiliriz.

```
index=botsv1 host=we9041srv *.pdf
```

Sonuçlara göre, ``Relative Target Name`` alanı her PDF dosyasının adını içeriyor.

![Ransomware](/assets/attachment/Scenarios2-11.png)

```
index=botsv1 sourcetype="WinEventLog:Security" host=we9041srv *.pdf Source_Address="192.168.250.100"
| stats dc(Relative_Target_Name) as totalcount
```

Bu sorgu, ``we9041srv`` adlı sunucuda, ``192.168.250.100`` kaynak adresinden gelen isteklerle ilişkili PDF dosyalarının olaylarını filtreler ve bu olaylarda belirtilen PDF dosyalarının adlarının (Relative Target Name alanındaki) farklı değerlerini sayar. Sonuç olarak, bu sorgu belirtilen koşullar altında kaç farklı PDF dosyasının erişildiğini veya işlendiğini gösterir. ``dc`` (distinct count) fonksiyonu, belirtilen alan için benzersiz değer sayısını hesaplar ve bu değeri ``totalcount`` olarak adlandırılan bir sütunda döndürür. 

![Ransomware](/assets/attachment/Scenarios2-12.png)

> 257
{: .prompt-tip }

### #208 The VBscript found in question 204 launches 121214.tmp. What is the ParentProcessId of this initial launch?

"121214.tmp" dosyasını aradığımızı bildiğimize göre, #204'teki Splunk sorgumuzu güncelleyebiliriz. 

```
index=botsv1 sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" host=we8105desk CommandLine="\"C:\\Windows\\System32\\cmd.exe\" /C START \"\" \"C:\\Users\\bob.smith.WAYNECORPINC\\AppData\\Roaming\\121214.tmp\""
| table ParentProcessId
```

Bu sorgu, `we8105desk` adlı host üzerindeki "XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" kaynak türünden verileri araştırır. Belirli bir komut satırı komutunu (`CommandLine`) içeren olayları filtreler. Bu komut, "cmd.exe" kullanarak "121214.tmp" dosyasını başlatmak için bir komuttur. Sorgu, bu belirli komutla ilişkilendirilmiş olan ve dosyanın başlatıldığı üst işlemi (parent process) belirten `ParentProcessId` değerini çıkartır ve bir tablo olarak sunar.

![Ransomware](/assets/attachment/Scenarios2-13.png)

> 3968
{: .prompt-tip }

### #209 The Cerber ransomware encrypts files located in Bob Smith's Windows profile. How many .txt files does it encrypt?

Bob Smith’in Windows profilindeki şifrelenen .txt dosyalarının sayısını öğrenmek için, öncelikle host adını saptayalım:

```
index=botsv1 bob.smith sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
```

![Ransomware](/assets/attachment/Scenarios2-14.png)

Bob Smith’in dizinindeki tüm metin dosyalarını sorgulamak için ``TargetFilename`` filtresini kullanalım:

```
index=botsv1 bob.smith sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" TargetFilename="C:\\Users\\bob.smith.WAYNECORPINC\\*.txt" 
| stats dc(TargetFilename)
```

Bu Splunk sorgusu, Bob Smith'in kullanıcı profilindeki tüm .txt dosyalarını arar ve bu dosyaların benzersiz sayısını hesaplar. ``TargetFilename`` filtresi, belirli bir yoldaki (Bob Smith'in kullanıcı dizini) dosya adlarını filtreler ve ``stats dc(TargetFilename)`` komutu ise bu dosyalar arasında benzersiz olanların sayısını bulur. Bu sayede, belirtilen dizinde kaç farklı .txt dosyası olduğunu öğreniriz.

![Ransomware](/assets/attachment/Scenarios2-15.png)

> 406
{: .prompt-tip }

### #210 The malware downloads a file that contains the Cerber ransomware cryptor code. What is the name of that file?

Bu soruyu yanıtlamak için ``Suricata`` kaynak türüne geri döneceğiz. Fidye yazılımı salgını sırasında ilk erişilen şüpheli alan adı ``solidaritedeproximite.org`` idi. Aşağıdaki Splunk sorgusunu kullanarak ``http:url`` alanında dikkat çeken verileri arayacağız.

```
index=botsv1 sourcetype=suricata src_ip="192.168.250.100" "solidaritedeproximite.org"
```

![Ransomware](/assets/attachment/Scenarios2-16.png)

Sonuçlara göre, ``mhtr.jpg`` adında bir dosya bulunuyor. Bu dosya, alışılmadık bir alan adıyla ilişkilendirilmiş olduğundan, büyük olasılıkla fidye yazılımının şifreleyici kodunu içeriyor.

> mhtr.jpg
{: .prompt-tip }

### #211 Now that you know the name of the ransomware's encryptor file, what obfuscation technique does it likely use?

Dosyanın ".jpg" uzantısına sahip olması dikkat çekici. Bu durumda, tehdit aktörlerinin sıkça kullandığı gizleme tekniği steganografi olabilir. Steganografi, bir dosya içinde ek bilgileri veya kodları gizleme yöntemidir. Bu teknikle, zararlı yazılımlar genellikle jpg, mp3, mp4, veya pdf gibi taşıyıcı dosyalar içine yerleştirilir.

![Ransomware](/assets/attachment/Scenarios2-17.png)

> Steganography
{: .prompt-tip }
