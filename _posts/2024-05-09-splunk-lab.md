---
title: Splunk Universal Forwarder
description: Sanal Windows 10 agent makinemiz üzerinden log toplayacağız.
categories: [LAB]
tags: [splunk]
pin: false
---
[Splunk Enterprise 9.2.1](https://www.splunk.com/en_us/download/splunk-enterprise.html)
[Splunk Universal Forwarder 9.2.1](https://www.splunk.com/en_us/download/universal-forwarder.html)

## Başlamadan Önce

- **Windows Defender** devre dışı bırakalım
- **Windows Update** devre dışı bırakalım
- **Windows Defender Güvenlik Duvarı** devre dışı bırakalım
- **Wecsvs** (Windows Event Collector) hizmetini *görev yöneticisi üzerinden* başlatalım

Splunk Enterprise kurulumu tamamlandıktan sonra Microsoft Windows için özel bir eklenti olan Splunk Add-on for Microsoft Windows yükleyeceğiz. Bu eklenti (splunk-add-on-for-microsoft-windows_880.tgz), her iki makinede de kullanılacak.

## Splunk Enterprise

{% drawer Splunk Enterprise screenshots %}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-1.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-2.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-3.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-4.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-5.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-enterprise-6.png){: .normal}
{% enddrawer %}

{% drawer Splunk Add-on for Microsoft Windows screenshots %}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-1.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-2.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-3.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-4.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-5.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-6.png){: .normal}
![Splunk Add-on for Microsoft Windows](/assets/attachment/splunk-add-on-7.png){: .normal}
{% enddrawer %}

Splunk'a giriş yapıp varsayılan 9997 portunu dinlemeye başlayalım ve Splunk Universal Forwarder kurulumuna geçmeden önce makinemizin IP adresini not alalım: `10.0.2.8`

{% drawer Screenshots %}
![Splunk Enterprise](/assets/attachment/splunk-port-1.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-port-2.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-port-3.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-port-4.png){: .normal}
![Splunk Enterprise](/assets/attachment/splunk-port-5.png){: .normal}
{% enddrawer %}

## Splunk Universal Forwarder

{% drawer Splunk Universal Forwarder screenshots %}
![Splunk Universal Forwarder](/assets/attachment/forwarder-1.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/forwarder-2.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/forwarder-3.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/forwarder-4.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/forwarder-5.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/forwarder-6.png){: .normal}
{% enddrawer %}

Eklenti dosyasını klasöre çıkardıktan sonra elde edilen **Splunk_TA_windows** klasörünü `C:\Program Files\SplunkUniversalForwarder\etc\apps` dizinine taşıyalım. 

`inputs.conf` dosyasını, yeni oluşturulan "local" adlı klasöre taşıyacağız. Dosyanın mevcut ve güncellenmiş dosya yolları aşağıdaki gibi olmalıdır:

{% drawer mevcut dosya yolu %}
``"C:\Program Files\SplunkUniversalForwarder\etc\apps\Splunk_TA_windows\default\inputs.conf"``
{% enddrawer %}

{% drawer güncel dosya yolu %}
``"C:\Program Files\SplunkUniversalForwarder\etc\apps\Splunk_TA_windows\local\inputs.conf"``
{% enddrawer %}

Application, Security ve System loglarını aktif hale getirmek için `disableb = 1` değerini `disableb = 0` olarak değiştirelim. Bu işlem sonrasında SplunkForwarder hizmetini yeniden başlatalım ve hizmetin başladığından emin olalım.

## Sonuç

Logların başarıyla alındığı doğrulanmıştır.

{% drawer Screenshots %}
![Splunk Universal Forwarder](/assets/attachment/splunk-lab-1.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/splunk-lab-2.png){: .normal}
![Splunk Universal Forwarder](/assets/attachment/splunk-lab-3.png){: .normal}
{% enddrawer %}
