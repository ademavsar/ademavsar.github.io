---
title: Chirpy - Favicon Rehberi
author: 
date: 2019-08-11 00:34:00 +0800
categories: [Guides]
tags: [blog]
---
[favicons](https://www.favicon-generator.org/about/) [**Chirpy**](https://github.com/cotes2020/jekyll-theme-chirpy/) için `assets/img/favicons/`{: .filepath} dizinine yerleştirilmiştir. Kendi faviconlarınızı eklemek isteyebilirsiniz. Aşağıdaki bölümler, varsayılan faviconları oluşturmanıza ve değiştirmenize yardımcı olacaktır.

## Favicon Oluşturma

512x512 veya daha büyük boyutta kare bir resim (PNG, JPG veya SVG) hazırlayın. Ardından [**Real Favicon Generator**](https://realfavicongenerator.net/) sitesine gidin ve <kbd>Select your Favicon image</kbd> butonuna tıklayarak resim dosyanızı yükleyin.

Sonraki adımda, web sayfası tüm kullanım senaryolarını gösterecektir. Varsayılan seçenekleri koruyabilir, sayfanın altına kadar kaydırıp <kbd>Generate your Favicons and HTML code</kbd> butonuna tıklayarak faviconları oluşturabilirsiniz.

## İndir & Değiştir

Oluşturulan paketi indirin, zip dosyasını açın ve çıkarılan dosyalardan aşağıdaki iki dosyayı silin:

- `browserconfig.xml`{: .filepath}
- `site.webmanifest`{: .filepath}

Ardından, kalan resim dosyalarını (`.PNG`{: .filepath} ve `.ICO`{: .filepath}) Jekyll sitenizin `assets/img/favicons/`{: .filepath} dizinine kopyalayın. Eğer Jekyll sitenizde bu dizin yoksa, bir tane oluşturun.

Aşağıdaki tablo, favicon dosyalarındaki değişiklikleri anlamanıza yardımcı olacaktır:

| Dosya(lar)          | Çevrimiçi Araçtan                | Chirpy'den  |
|---------------------|:---------------------------------:|:-----------:|
| `*.PNG`             | ✓                                 | ✗           |
| `*.ICO`             | ✓                                 | ✗           |

> ✓ işareti dosyanın tutulacağı, ✗ işareti ise dosyanın silineceği anlamına gelir.
{: .prompt-info }

Siteyi bir sonraki oluşturduğunuzda, favicon özelleştirilmiş sürümle değiştirilecektir.