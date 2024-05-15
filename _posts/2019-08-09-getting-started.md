---
title: Getting Started
description: >-
  Bu kapsamlı genel bakışta Chirpy temelleriyle nasıl başlayacağınızı öğrenin.
  İlk Chirpy tabanlı web sitenizi nasıl kuracağınızı, yapılandıracağınızı, kullanacağınızı ve bir web sunucusuna nasıl dağıtacağınızı öğreneceksiniz.
author: 
date: 2019-08-09 20:55:00 +0800
categories: [Blogging, Tutorial]
tags: [getting started]
pin: false
#media_subpath: '/posts/20180809'
---

## Ön Koşullar

Temel ortamın kurulumunu tamamlamak için [Jekyll Dokümanları](https://jekyllrb.com/docs/installation/)ndaki talimatları izleyin. [Git](https://git-scm.com/) de kurulmuş olmalıdır.

## Kurulum

### Yeni Bir Site Oluşturma

Bu tema için yeni bir depo oluşturmanın iki yolu vardır:

- [**Using the Chirpy Starter**](#option-1-using-the-chirpy-starter) - Güncellemesi kolaydır, ilgisiz proje dosyalarını izole eder, böylece yazmaya odaklanabilirsiniz.
- [**GitHub Fork**](#option-2-github-fork) - Özel geliştirme için uygundur, ancak güncellemesi zordur. Jekyll ile aşina değilseniz ve bu projeye katkıda bulunmayı veya düzenlemeyi düşünmüyorsanız, bu yöntem önerilmez.

<h2 id="option-1-using-the-chirpy-starter">Option 1: Using the Chirpy Starter</h2>
<h2 id="option-2-github-fork">Option 2: GitHub Fork</h2>

#### Seçenek 1. Using the Chirpy Starter

GitHub'a giriş yapın ve [**Chirpy Başlangıç**][starter] sayfasına gidin, <kbd>Use this template</kbd> > <kbd>Create a new repository</kbd> butonuna tıklayın ve yeni depoyu `USERNAME.github.io` olarak adlandırın, burada `USERNAME` GitHub kullanıcı adınızı temsil eder.

#### Seçenek 2. GitHub Fork

GitHub'a giriş yapın ve [**Chirpy**'i forklayın](https://github.com/cotes2020/jekyll-theme-chirpy/fork), ardından bunu `USERNAME.github.io` olarak yeniden adlandırın (`USERNAME` kullanıcı adınızı ifade eder).

Daha sonra, sitenizi yerel makinenize klonlayın. Daha sonra JavaScript dosyalarını oluşturabilmek için [Node.js][nodejs] kurulumunu yapmanız gerekir ve ardından şu aracı çalıştırın:

```console
$ bash tools/init
```

> GitHub Pages üzerinde sitenizi yayınlamak istemiyorsanız, yukarıdaki komutun sonuna `--no-gh` seçeneğini ekleyin.
{: .prompt-info }

Yukarıdaki komut şunları yapacaktır:

1. Kodları [en son etikete][latest-tag] çeker (sitenizin istikrarını sağlamak için: varsayılan dal geliştirme altında olduğu için).
2. Gereksiz örnek dosyaları kaldırır ve GitHub ile ilgili dosyaları düzenler.
3. JavaScript dosyalarını oluşturur ve `assets/js/dist/`{: .filepath } dizinine aktarır, ardından bunları Git tarafından izlenir hale getirir.
4. Yukarıdaki değişiklikleri kaydetmek için otomatik olarak yeni bir commit oluşturur.

### Bağımlılıkları Yüklemek

İlk kez yerel sunucuyu çalıştırmadan önce, sitenizin kök dizinine gidin ve şu komutu çalıştırın:

```console
$ bundle
```

## Kullanım

### Yapılandırma

`_config.yml`{: .filepath} dosyasındaki değişkenleri gerektiği gibi güncelleyin. Bazı tipik seçenekler şunlardır:

- `url`
- `avatar`
- `timezone`
- `lang`

### Sosyal İletişim Seçenekleri

Sosyal iletişim seçenekleri, yan çubuğun altında gösterilir. `_data/contact.yml`{: .filepath } dosyasında belirtilen iletişimleri açık/kapalı olarak ayarlayabilirsiniz.

### Stil Sayfasını Özelleştirme

Stil sayfasını özelleştirmeniz gerekiyorsa, tema'nın `assets/css/jekyll-theme-chirpy.scss`{: .filepath} dosyasını Jekyll sitenizin aynı yoluna kopyalayın ve ardından en sonuna özel stilinizi ekleyin.

`6.2.0` sürümünden itibaren, `_sass/addon/variables.scss`{: .filepath} içinde tanımlanan SASS değişkenlerini geçersiz kılmak istiyorsanız, ana sass dosyası `_sass/main.scss`{: .filepath} 'ı sitenizin kaynaklarındaki `_sass`{: .filepath} dizinine kopyalayın, ardından `_sass/variables-hook.scss`{: .filepath} adında yeni bir dosya oluşturun ve yeni değer atayın.

### Statik Varlıkları Özelleştirme

Statik varlıkların yapılandırması `5.1.0` sürümünde tanıtıldı. Statik varlıkların CDN'i `_data/origin/cors.yml`{: .filepath } dosyası tarafından tanımlanır ve web sitenizin yayınlandığı bölgenin ağ koşullarına göre bazılarını değiştirebilirsiniz.

Ayrıca, statik varlıkları kendiniz barındırmak istiyorsanız, lütfen [_chirpy-static-assets_](https://github.com/cotes2020/chirpy-static-assets#readme) adresine başvurun.

### Yerel Sunucuyu Çalıştırma

Site içeriğini yayınlamadan önce ön izleme yapmak isteyebilirsiniz, bu yüzden sadece çalıştırın:

```console
$ bundle exec jekyll s
```

Birkaç saniye sonra, yerel hizmet <http://127.0.0.1:4000> adresinde yayınlanacaktır.

## Dağıtım

Dağıtıma başlamadan önce, `_config.yml`{: .filepath} dosyasını kontrol edin ve `url`'nin doğru yapılandırıldığından emin olun. Ayrıca, [**proje sitesi**](https://help.github.com/en/github/working-with-github-pages/about-github-pages#types-of-github-pages-sites) tercih ediyorsanız ve özel bir alan kullanmıyorsanız, veya web sunucunuz **GitHub Pages** dışında başka bir base URL ile sitenizi ziyaret etmek istiyorsanız, `baseurl`'i eğik çizgi ile başlayan proje adınız olarak değiştirin, örn, `/proje-adı`.

Şimdi Jekyll sitenizi dağıtmak için aşağıdaki yöntemlerden _BİRİNİ_ seçebilirsiniz.

### GitHub Actions Kullanarak Dağıtım

Hazırlanacak birkaç şey var.

- GitHub Free planında iseniz, sitenizin deposunu herkese açık tutun.
- Yerel makineniz Linux çalıştırmıyorsa ve `Gemfile.lock`{: .filepath} dosyasını depoya işlediyseniz, sitenizin köküne gidin ve kilit dosyasının platform listesini güncelleyin:

  ```console
  $ bundle lock --add-platform x86_64-linux
  ```

Sonra, _Pages_ hizmetini yapılandırın.

1. GitHub'da depo **Settings** (Ayarlar) sekmesine gidin, sonra sol taraftaki menüden **Pages**'i tıklayın. Sonra, **Source** (Kaynak) bölümünde (altında _Build and deployment_), açılır menüden [**GitHub Actions**][pages-workflow-src] seçin.

![Build source](/assets/attachment/pages-source-light.png){: .light .border .normal w='375' h='140' }
![Build source](/assets/attachment/pages-source-dark.png){: .dark .normal w='375' h='140' }

2. GitHub'a herhangi bir commit'i iterek _Actions_ iş akışını tetikleyin. Reposunuzun _Actions_ sekmesinde, _Build and Deploy_ iş akışının çalıştığını görmelisiniz. İnşaat başarıyla tamamlandığında, site otomatik olarak dağıtılacaktır.

Bu noktada, GitHub tarafından belirtilen URL'ye giderek sitenize erişebilirsiniz.

### Manuel Olarak İnşa Et ve Dağıt

Kendi barındırılan sunucularda, **GitHub Actions**

'ın sağladığı kolaylıktan yararlanamazsınız. Bu nedenle, sitenizi yerel makinenizde inşa etmeli ve ardından site dosyalarını sunucuya yüklemelisiniz.

Projenin köküne gidin ve sitenizi şu şekilde inşa edin:

```console
$ JEKYLL_ENV=production bundle exec jekyll b
```

Belirli bir çıkış yolu belirtmediyseniz, oluşturulan site dosyaları proje'nin kök dizinindeki `_site`{: .filepath} klasörüne yerleştirilecektir. Şimdi bu dosyaları hedef sunucuya yüklemeniz gerekmektedir.

[nodejs]: https://nodejs.org/
[starter]: https://github.com/cotes2020/chirpy-starter
[pages-workflow-src]: https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow
[latest-tag]: https://github.com/cotes2020/jekyll-theme-chirpy/tags
