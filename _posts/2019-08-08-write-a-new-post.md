---
title: Chirpy'de Yazı Yazma Rehberi
description: Bu rehber, Chirpy şablonunda yazı yazmayı adım adım gösterecek.
author: 
date: 2019-08-08 14:10:00 +0800
categories: [Blogging, Tutorial]
tags: [writing]
render_with_liquid: false
---

## İsimlendirme ve Yol

Yeni bir dosya oluşturun, adını `YYYY-MM-DD-TITLE.EXTENSION`{: .filepath} koyun ve kök dizindeki `_posts`{: .filepath} içine yerleştirin. Lütfen `EXTENSION`{: .filepath} uzantısının `md`{: .filepath} veya `markdown`{: .filepath} olması gerektiğini unutmayın. Dosya oluşturma sürecinden zaman kazanmak istiyorsanız, [`Jekyll-Compose`](https://github.com/jekyll/jekyll-compose) eklentisini kullanmayı düşünün.

## Front Matter

Temelde, yazının başında aşağıdaki gibi [Front Matter](https://jekyllrb.com/docs/front-matter/) doldurmanız gerekir:

```yaml
---
title: BAŞLIK
date: YYYY-MM-DD HH:MM:SS +/-TTTT
categories: [ANA_KATEGORİ, ALT_KATEGORİ]
tags: [ETİKET]     # ETİKET isimleri her zaman küçük harf olmalıdır
---
```

> Yazıların _layout_'u varsayılan olarak `post` olarak ayarlanmıştır, bu yüzden Front Matter bloğunda _layout_ değişkenini eklemenize gerek yoktur.
{: .prompt-tip }

### Tarih Saat Dilimi

Bir yazının yayınlanma tarihini doğru bir şekilde kaydetmek için, sadece `_config.yml`{: .filepath} dosyasındaki `timezone` ayarını yapmakla kalmayıp, ayrıca Front Matter bloğunda `date` değişkeninde yazının saat dilimini belirtmelisiniz. Format: `+/-TTTT`, örneğin `+0800`.

### Kategoriler ve Etiketler

Her yazının `categories`i en fazla iki eleman içerebilir ve `tags` elemanlarının sayısı sıfırdan sonsuza kadar olabilir. Örneğin:

```yaml
---
categories: [Hayvan, Böcek]
tags: [arı]
---
```

### Yazar Bilgileri

Yazının yazar bilgileri genellikle Front Matter'da doldurulmaz, bunlar varsayılan olarak yapılandırma dosyasındaki `social.name` ve `social.links`in ilk girişinden alınır. Ancak aşağıdaki gibi geçersiz kılabilirsiniz:

`_data/authors.yml` dosyasına yazar bilgilerini ekleyin (Eğer sitenizde bu dosya yoksa, çekinmeden bir tane oluşturun).

```yaml
<author_id>:
  name: <tam isim>
  twitter: <yazarın_twitter>
  url: <yazarın_anasayfası>
```
{: file="_data/authors.yml" }

Ardından, `author` kullanarak tek bir giriş veya `authors` kullanarak birden fazla giriş belirleyin:

```yaml
---
author: <author_id>                     # tek giriş için
# veya
authors: [<author1_id>, <author2_id>]   # birden fazla giriş için
---
```

Bununla birlikte, `author` anahtarı birden fazla girişi tanımlayabilir.

> `_data/authors.yml`{: .filepath} dosyasından yazar bilgilerini okumanın faydası, sayfada `twitter:creator` meta etiketinin olmasıdır, bu da [Twitter Kartları](https://developer.twitter.com/en/docs/twitter-for-websites/cards/guides/getting-started#card-and-content-attribution) için iyidir ve SEO açısından faydalıdır.
{: .prompt-info }

### Yazı Tanımı

Varsayılan olarak, yazının ilk kelimeleri ana sayfada yazı listesinde, _Further Reading_ bölümünde ve RSS beslemesinin XML'inde kullanılır. Yazı için otomatik olarak oluşturulan tanımı göstermek istemiyorsanız, _Front Matter_'da `description` alanını kullanarak özelleştirebilirsiniz:

```yaml
---
description: Yazının kısa özeti.
---
```

Ayrıca, `description` metni, yazının sayfasındaki başlık altında da gösterilir.

## İçindekiler Tablosu

Varsayılan olarak, yazının sağ panelinde **İçindekiler Tablosu** (TOC) gösterilir. Bunu genel olarak kapatmak istiyorsanız, `_config.yml`{: .filepath} dosyasına gidin ve `toc` değişkeninin değerini `false` olarak ayarlayın. Belirli bir yazı için TOC'yi kapatmak istiyorsanız, yazının [Front Matter](https://jekyllrb.com/docs/front-matter/)ına aşağıdakileri ekleyin:

```yaml
---
toc: false
---
```

## Yorumlar

Yorumların global anahtarı `_config.yml`{: .filepath} dosyasındaki `comments.active` değişkeni tarafından tanımlanmıştır. Bu değişken için bir yorum sistemi seçtikten sonra, tüm yazılar için yorumlar açık olacaktır.

Belirli bir yazı için yorumu kapatmak istiyorsanız, yazının **Front Matter**ına aşağıdakileri ekleyin:

```yaml
---
comments: false
---
```

## Matematik

Matematik üretimi için [**MathJax**][mathjax] kullanıyoruz. Web sitesi performansı nedenleriyle, matematik özelliği varsayılan olarak yüklenmez. Ancak şu şekilde etkinleştirilebilir:

[mathjax]: https://www.mathjax.org/

```yaml
---
math: true
---
```

Matematik özelliği etkinleştirildikten sonra, aşağıdaki sözdizimi ile matematik denklemleri ekleyebilirsiniz:

- **Blok matematik** `$$ math $$` ile eklenmelidir ve `$$` öncesi ve sonrası **zorunlu** boş satırlar olmalıdır
  - **Denklem numarası eklemek** `$$\begin{equation} math \end{equation}$$` ile eklenmelidir
  - **Denklem numarasına başvurma** denklem bloğunda `\label{eq:label_name}` ile ve metin içinde `\eqref{eq:label_name}` ile yapılmalıdır (aşağıdaki örneğe bakınız)
- **Satır içi matematik** (satırlarda) `$$ math $$` ile eklenmelidir ve `$$` öncesi ve sonrasında boş satır olmamalıdır
- **Satır içi matematik** (listelerde) `\$$ math $$` ile eklenmelidir

```markdown
<!-- Blok matematik, tüm boş satırları koruyun -->

$$
LaTeX_math_expression
$$

<!-- Denklem numarası, tüm boş satırları koruyun  -->

$$
\begin{equation}
  LaTeX_math_expression
  \label{eq:label_name}
\end{equation}
$$

\eqref{eq:label_name} olarak başvurulabilir.

<!-- Satır içi matematik satırlarda, BOŞ SATIR YOK -->

"Lorem ipsum dolor sit amet, $$ LaTeX_math_expression $$ consectetur adipiscing elit."

<!-- Satır içi matematik listelerde, ilk `$` kaçın -->

1. \$$ LaTeX_math_expression $$
2. \$$ LaTeX_math_expression $$
3. \$$ LaTeX_math_expression $$
```

> `v7.0.0` itibarıyla, **MathJax** yapılandırma seçenekleri `assets/js/data/mathjax.js`{: .filepath} dosyasına taşındı ve ihtiyaca göre değiştirilebilir, örneğin [eklentiler][mathjax-exts] ekleyebilirsiniz. Eğer siteyi `chirpy-starter` üzerinden inşa ediyorsanız, bu dosyayı gem kurulum dizininden (komutla `bundle info --path jekyll-theme-chirpy` kontrol edin) aynı dizine kopyalayın.
{: .prompt-tip }

[mathjax-exts]: https://docs.mathjax.org/en/latest/input/tex/extensions/index.html

## Mermaid

[**Mermaid**](https://github.com/mermaid-js/mermaid) harika bir diyagram oluşturma aracıdır. Yazınızda bunu etkinleştirmek için YAML bloğuna aşağıdakileri ekleyin:

```yaml
---
mermaid: true
---
```

Sonra diğer markdown dilleri gibi kullanabilirsiniz: grafik kodunu ```` ```mermaid ```` ve ```` ``` ```` ile çevreleyin.

## Resimler

### Başlık

Bir resmin altındaki bir sonraki satıra italik ekleyin, o zaman bu başlık olur ve resmin altında görünür:

```markdown
![img-description](/path/to/image)
_Resim Başlığı_
```
{: .nolineno}

### Boyut

Sayfa içeriği düzeninin resim yüklendiğinde kaymasını önlemek için, her resim için genişlik ve yükseklik belirlemeliyiz.

```markdown
![Masaüstü Görünümü](/assets/img/sample/mockup.png){: width="700" height="400" }
```
{: .nolineno}

> Bir SVG için, en azından _genişliğini_ belirtmelisiniz, aksi takdirde görüntülenmez.
{: .prompt-info }

_Ch

irpy v5.0.0_'dan itibaren, `height` ve `width` kısaltmaları (`height` → `h`, `width` → `w`) destekler. Yukarıdaki örnekle aynı etkiye sahip aşağıdaki örneğe bakın:

```markdown
![Masaüstü Görünümü](/assets/img/sample/mockup.png){: w="700" h="400" }
```
{: .nolineno}

### Konum

Varsayılan olarak resim ortalanmıştır, ancak `normal`, `left` ve `right` sınıflarından birini kullanarak konumu belirleyebilirsiniz.

> Konum belirlendikten sonra, resim başlığı eklenmemelidir.
{: .prompt-warning }

- **Normal konum**

  Aşağıdaki örnekte resim sola hizalanacaktır:

  ```markdown
  ![Masaüstü Görünümü](/assets/img/sample/mockup.png){: .normal }
  ```
  {: .nolineno}

- **Sola yasla**

  ```markdown
  ![Masaüstü Görünümü](/assets/img/sample/mockup.png){: .left }
  ```
  {: .nolineno}

- **Sağa yasla**

  ```markdown
  ![Masaüstü Görünümü](/assets/img/sample/mockup.png){: .right }
  ```
  {: .nolineno}

### Karanlık/Aydınlık Mod

Resimlerin karanlık/aydınlık mod tercihlerine göre takip edilmesini sağlayabilirsiniz. Bunun için karanlık mod ve aydınlık mod için iki resim hazırlamanız gerekir, ardından belirli bir sınıf (`dark` veya `light`) atamanız gerekir:

```markdown
![Aydınlık mod sadece](/path/to/light-mode.png){: .light }
![Karanlık mod sadece](/path/to/dark-mode.png){: .dark }
```

### Gölge

Program penceresinin ekran görüntülerinin gölge efekti göstermesi düşünülebilir:

```markdown
![Masaüstü Görünümü](/assets/img/sample/mockup.png){: .shadow }
```
{: .nolineno}

### CDN URL

Medya kaynaklarını CDN üzerinde barındırıyorsanız, CDN URL'ini tekrar tekrar yazma zamanından tasarruf edebilirsiniz, `_config.yml`{: .filepath} dosyasındaki `cdn` değişkenini atayarak:

```yaml
cdn: https://cdn.com
```
{: file='_config.yml' .nolineno}

`cdn` atanmışsa, CDN URL'si tüm medya kaynaklarının (site avatarı, yazıların resimleri, ses ve video dosyaları) yoluna `/` ile başlayarak eklenir.

Örneğin, resim kullanırken:

```markdown
![Çiçek](/path/to/flower.png)
```
{: .nolineno}

Ayrıştırma sonucu, resim yolunun önüne otomatik olarak CDN öneki `https://cdn.com` eklenir:

```html
<img src="https://cdn.com/path/to/flower.png" alt="Çiçek" />
```
{: .nolineno }

### Medya Alt Yolu

Bir yazı birçok resim içerdiğinde, medya kaynaklarının yolunu tekrar tekrar tanımlamak zaman alıcı bir iş olacaktır. Bunu çözmek için, bu yolu yazının YAML bloğunda tanımlayabiliriz:

```yaml
---
media_subpath: /img/yol/
---
```

Ardından, Markdown resim kaynağını doğrudan dosya adıyla yazabilirsiniz:

```md
![Çiçek](flower.png)
```
{: .nolineno }

Çıktı şu şekilde olacaktır:

```html
<img src="/img/yol/flower.png" alt="Çiçek" />
```
{: .nolineno}

### Önizleme Resmi

Yazının üst kısmına bir resim eklemek istiyorsanız, `1200 x 630` çözünürlüğünde bir resim sağlayın. Lütfen, resim en boy oranı `1.91 : 1`i karşılamıyorsa, resmin ölçeklendirileceğini ve kırpılacağını unutmayın.

Bu ön koşulları bildiğinizde, resmin özniteliklerini ayarlamaya başlayabilirsiniz:

```yaml
---
image:
  path: /path/to/image
  alt: image alternatif metin
---
```

Not, [`media_subpath`](#media-subpath) önizleme resmine de geçirilebilir, yani ayarlandığında, `path` özniteliği yalnızca resim dosya adını içermelidir.

<h2 id="media-subpath">media_subpath</h2>

Basit kullanım için, yolu tanımlamak için sadece `image` kullanabilirsiniz.

```yml
---
image: /path/to/image
---
```

### LQIP

Önizleme resimleri için:

```yaml
---
image:
  lqip: /path/to/lqip-file # veya base64 URI
---
```

> LQIP'yi [_Text and Typography_](/posts/text-and-typography/) yazısının önizleme resminde gözlemleyebilirsiniz.

Normal resimler için:

```markdown
![Resim açıklaması](/path/to/image){: lqip="/path/to/lqip-file" }
```
{: .nolineno }

## Sabitlenmiş Yazılar

Ana sayfanın üst kısmına bir veya daha fazla yazıyı sabitleyebilirsiniz ve sabitlenmiş yazılar yayınlanma tarihlerine göre tersten sıralanır. Etkinleştirmek için:

```yaml
---
pin: true
---
```

## İpuçları

Birkaç tür ipucu vardır: `tip`, `info`, `warning` ve `danger`. Bunlar, alıntıya `prompt-{type}` sınıfını ekleyerek oluşturulabilir. Örneğin, `info` türünde bir ipucu şu şekilde tanımlanır:

```md
> İpucu örneği satırı.
{: .prompt-info }
```
{: .nolineno }

## Sözdizimi

### Satır İçi Kod

```md
`satır içi kod parçası`
```
{: .nolineno }

### Dosya Yolu Vurgulama

```md
`/path/to/a/file.extend`{: .filepath}
```
{: .nolineno }

### Kod Bloğu

Markdown sembolleri ```` ``` ```` ile kolayca bir kod bloğu oluşturabilirsiniz:

````md
```
Bu, düz metin kod parçacığıdır.
```
````

#### Dil Belirtme

```` ```{dil} ```` kullanarak sözdizimi vurgusu olan bir kod bloğu elde edersiniz:

````markdown
```yaml
anahtar: değer
```
````

> Bu tema ile Jekyll etiketi `{% highlight %}` uyumlu değildir.
{: .prompt-danger }

#### Satır Numarası

Varsayılan olarak, `plaintext`, `console` ve `terminal` dışındaki tüm diller satır numaralarını gösterir. Bir kod bloğunun satır numarasını gizlemek istediğinizde, ona `nolineno` sınıfını ekleyin:

````markdown
```shell
echo 'Artık satır numaraları yok!'
```
{: .nolineno }
````

#### Dosya Adını Belirtme

Kod bloğunun üst kısmında kod dilinin gösterildiğini fark etmiş olabilirsiniz. Bunu dosya adıyla değiştirmek istiyorsanız, bunu başarmak için `file` özniteliğini ekleyebilirsiniz:

````markdown
```shell
# içerik
```
{: file="path/to/file" }
````

#### Liquid Kodları

**Liquid** kod parçacığını göstermek istiyorsanız, liquid kodunu `{% raw %}` ve `{% endraw %}` ile çevreleyin:

````markdown
{% raw %}
```liquid
{% if product.title contains 'Pack' %}
  Bu ürünün başlığı 'Pack' kelimesini içerir.
{% endif %}
```
{% endraw %}
````

Veya yazının YAML bloğuna `render_with_liquid: false` ekleyin (Jekyll 4.0 veya daha yüksek sürümü gerektirir).

## Videolar

### Video Paylaşım Platformu

Aşağıdaki sözdizimi ile bir video gömebilirsiniz:

```liquid
{% include embed/{Platform}.html id='{ID}' %}
```

Burada `Platform`, platform adının küçük harflidir ve `ID`, video ID'sidir.

Aşağıdaki tablo, verilen bir video URL'sinde ihtiyacımız olan iki parametreyi nasıl alacağımızı gösterir ve ayrıca şu anda desteklenen video platformlarını da bilebilirsiniz.

| Video URL                                                                                          | Platform  | ID            |
| -------------------------------------------------------------------------------------------------- | --------- | :------------ |
| [https://www.**youtube**.com/watch?v=**H-B46URT4mg**](https://www.youtube.com/watch?v=H-B46URT4mg) | `youtube` | `H-B46URT4mg` |
| [https://www.**twitch**.tv/videos/**1634779211**](https://www.twitch.tv/videos/1634779211)         | `twitch`  | `1634779211`  |
| [https://www.**bilibili**.com/video/**BV1Q44y1B7Wf**                                               |

](https://www.bilibili.com/video/BV1Q44y1B7Wf) | `bilibili` | `BV1Q44y1B7Wf` |

### Video Dosyası

Bir video dosyasını doğrudan gömmek istiyorsanız, aşağıdaki sözdizimini kullanın:

```liquid
{% include embed/video.html src='{URL}' %}
```

Burada `URL`, bir video dosyasına yönlendiren bir URL'dir, örneğin `/assets/img/sample/video.mp4`.

Gömülü video dosyası için ek öznitelikler belirleyebilirsiniz. İzin verilen özniteliklerin tam listesi aşağıdadır.

- `poster='/path/to/poster.png'` - video indirilirken gösterilen afiş resmi
- `title='Metin'` - videonun altında görünen ve resimler için olanla aynı görünen video başlığı
- `autoplay=true` - video mümkün olduğu kadar hızlı otomatik olarak oynatılmaya başlar
- `loop=true` - video sona erdiğinde otomatik olarak başa sarar
- `muted=true` - ses başlangıçta sessiz olur
- `types` - ek video formatlarının uzantılarını `|` ile ayırarak belirtin. Bu dosyaların ana video dosyanızla aynı dizinde olduğundan emin olun.

Tüm yukarıdakileri kullanan bir örneği düşünün:

```liquid
{%
  include embed/video.html
  src='/path/to/video/video.mp4'
  types='ogg|mov'
  poster='poster.png'
  title='Demo video'
  autoplay=true
  loop=true
  muted=true
%}
```

> Video dosyalarını `assets` klasöründe barındırmak önerilmez çünkü PWA tarafından önbelleğe alınamazlar ve sorunlara neden olabilirler. Bunun yerine, video dosyalarını barındırmak için CDN kullanın. Alternatif olarak, PWA'dan ( `_config.yml` dosyasındaki `pwa.deny_paths` ayarına bakın) hariç tutulan ayrı bir klasör kullanın.
{: .prompt-warning }

## Sesler

### Ses Dosyası

Bir ses dosyasını doğrudan gömmek istiyorsanız, aşağıdaki sözdizimini kullanın:

```liquid
{% include embed/audio.html src='{URL}' %}
```

Burada `URL`, bir ses dosyasına yönlendiren bir URL'dir, örneğin `/assets/img/sample/audio.mp3`.

Gömülü ses dosyası için ek öznitelikler belirleyebilirsiniz. İzin verilen özniteliklerin tam listesi aşağıdadır.

- `title='Metin'` - sesin altında görünen ve resimler için olanla aynı görünen ses başlığı
- `types` - ek ses formatlarının uzantılarını `|` ile ayırarak belirtin. Bu dosyaların ana ses dosyanızla aynı dizinde olduğundan emin olun.

Tüm yukarıdakileri kullanan bir örneği düşünün:

```liquid
{%
  include embed/audio.html
  src='/path/to/audio/audio.mp3'
  types='ogg|wav|aac'
  title='Demo audio'
%}
```

> Ses dosyalarını `assets` klasöründe barındırmak önerilmez çünkü PWA tarafından önbelleğe alınamazlar ve sorunlara neden olabilirler. Bunun yerine, ses dosyalarını barındırmak için CDN kullanın. Alternatif olarak, PWA'dan hariç tutulan ayrı bir klasör kullanın ( `_config.yml` dosyasındaki `pwa.deny_paths` ayarına bakın).
{: .prompt-warning }

## Daha Fazla Bilgi

Jekyll yazıları hakkında daha fazla bilgi için [Jekyll Docs: Posts](https://jekyllrb.com/docs/posts/) sayfasını ziyaret edin.