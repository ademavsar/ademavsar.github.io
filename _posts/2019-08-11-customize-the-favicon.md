---
title: Customize the Favicon
author: 
date: 2019-08-11 00:34:00 +0800
categories: [Blogging, Tutorial]
tags: [favicon]
---

[favicons](https://www.favicon-generator.org/about/) [**Chirpy**](https://github.com/cotes2020/jekyll-theme-chirpy/) için `assets/img/favicons/`{: .filepath} dizinine yerleştirilmiştir. Kendi faviconlarınızla değiştirmek isteyebilirsiniz. Aşağıdaki bölümler, varsayılan faviconları oluşturmanıza ve değiştirmenize rehberlik edecektir.

## Favicon Oluşturma

512x512 veya daha büyük boyutta kare bir resim (PNG, JPG veya SVG) hazırlayın, ardından çevrimiçi araç [**Real Favicon Generator**](https://realfavicongenerator.net/) sayfasına gidin ve <kbd>Select your Favicon image</kbd> butonuna tıklayarak resim dosyanızı yükleyin.

Sonraki adımda, web sayfası tüm kullanım senaryolarını gösterecektir. Varsayılan seçenekleri koruyabilir, sayfanın altına kadar kaydırabilir ve <kbd>Generate your Favicons and HTML code</kbd> butonuna tıklayarak faviconu oluşturabilirsiniz.

## İndir & Değiştir

Oluşturulan paketi indirin, zip dosyasını açın ve çıkarılan dosyalardan aşağıdaki iki dosyayı silin:

- `browserconfig.xml`{: .filepath}
- `site.webmanifest`{: .filepath}

Ardından kalan resim dosyalarını (`.PNG`{: .filepath} ve `.ICO`{: .filepath}) Jekyll sitenizin `assets/img/favicons/`{: .filepath} dizinindeki orijinal dosyaların üzerine kopyalayın. Eğer Jekyll sitenizde bu dizin henüz yoksa, bir tane oluşturun.

Aşağıdaki tablo, favicon dosyalarındaki değişiklikleri anlamanıza yardımcı olacaktır:

| Dosya(lar)          | Çevrimiçi Araçtan                | Chirpy'den  |
|---------------------|:---------------------------------:|:-----------:|
| `*.PNG`             | ✓                                 | ✗           |
| `*.ICO`             | ✓                                 | ✗           |

<!-- markdownlint-disable-next-line -->
>  ✓ işareti tutulacak anlamına gelir, ✗ işareti silinecek anlamına gelir.
{: .prompt-info }

Siteyi bir sonraki kez oluşturduğunuzda, favicon özelleştirilmiş sürümle değiştirilecektir.
