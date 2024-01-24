---
title: obsidian lowercase eklentisi
categories: [proje]
tags: [eklenti, obsidian]
---

## giriş

uppercase özürlüsü olduğum için obsidian'da hızlanmak adına lowercase eklentisi oluşturdum.

obsidian için bir eklenti yapmak, javascript ve obsidian api'sinin temel bilgisini gerektirir. aşağıda, seçili metni lowercase yapacak bir eklenti oluşturma adımlarını bulabilirsin.

> işletim sistemim windows

## adım 1: geliştirme ortamını hazırlama

1. **node.js ve npm yükleme**:

   - [node.js resmi web sitesine](https://nodejs.org/) gidin ve windows için uygun sürümü (genellikle lts sürümü) indirin
   - i̇ndirilen `.msi` dosyasını çalıştırarak kurulum sihirbazını takip edin

2. **yeni bir proje oluşturma**:

   - bir klasör oluşturun (konumu önemli değil) ve bu klasörde terminal veya komut istemcisini açın
   - `npm init` komutunu çalıştırarak yeni bir npm projesi başlatın


<details>
<summary><strong><mark>npm init</mark> süreci:</strong></summary>

<mark>npm init</mark> komutunu çalıştırdığımızda npm'nin bir <mark>package.json</mark> dosyası oluşturma sürecini başlattığını görüyoruz. <mark>package.json</mark> dosyası, projenin yapılandırma detaylarını içerir ve npm paketlerini yönetmek için kullanılır. i̇şte bu sürecin adımları:


1. **package name**: i̇lk olarak paket adını belirlemen gerekiyor. önerilen adı kabul etmek için enter tuşuna basabilir veya farklı bir ad yazabilirsin.

2. **version**: daha sonra paketin başlangıç versiyonunu belirlemen istenecek. genellikle <mark>1.0.0</mark> varsayılan olarak önerilir.

3. **description**: paketin ne yaptığına dair kısa bir açıklama girebilirsin.

4. **entry point**: bu, projenin ana dosyasını belirtir. eğer <mark>main.ts</mark> veya <mark>main.js</mark> kullanıyorsan, buraya bu dosyanın adını yazabilirsin.

5. **test command**: projen için bir test komutu varsa buraya yazabilirsin. henüz yoksa bu adımı boş bırakabilirsin.

6. **git repository**: eğer projeni bir git deposunda tutuyorsan, buraya deponun url'sini girebilirsin.

7. **keywords**: projeyi tanımlayan anahtar kelimeleri buraya ekleyebilirsin.

8. **author**: projeyi oluşturan kişinin adını buraya yazabilirsin.

9. **license**: projene hangi lisansın uygulanacağını burada belirtebilirsin. örneğin, açık kaynak bir proje için genellikle "mit" gibi bir lisans kullanılır.

10. **is this ok?**: son olarak, npm sana oluşturduğu <mark>package.json</mark> dosyasının bir önizlemesini gösterecek ve onaylamanı isteyecek. her şey doğruysa, onaylamak için enter tuşuna basabilirsin.

bu adımları tamamladıktan sonra, <mark>package.json</mark> dosyan hazır olacak ve npm paketlerini yüklemeye başlayabilirsin.

#### bunları bilmelisin

- **package.json önemi**: <mark>package.json</mark> dosyası, projenin bağımlılıklarını, scriptlerini ve yapılandırma bilgilerini içerir. npm ve diğer geliştiriciler için projenin "kimliği" gibidir.

- **bağımlılıklar**: projene yeni bir npm paketi eklemek istediğinde, <mark>npm install</mark> komutunu kullanarak bu paketi <mark>package.json</mark> dosyasına bağımlılık olarak ekleyebilirsin. bu, projenin başka bir yerde kullanılması durumunda gerekli paketlerin kolayca yüklenmesini sağlar.
</details>



## adım 2: obsidian api'ye bağlanma

1. **obsidian api bağımlılığını yükleme**:

   - `npm install obsidian` komutunu kullanarak projene obsidian api ekleyin

2. **typescript kurulumu** (opsiyonel ama önerilir):

   - `npm install typescript --save-dev` komutuyla typescript yükleyin

<details>
<summary><mark>'tsc' is not recognized as an internal or external command, operable program or batch file</mark> hatası</summary>

typescript compiler'ın (tsc) sisteminde tanımlı olmadığını gösteriyor. bu sorunu çözmek için typescript'i global olarak yüklemen gerekecek. i̇şte adımlar:

typescript compiler (tsc) yükleme

1. **typescript'i global olarak yükleme**:

   - komut istemcisine `npm install -g typescript` yazarak typescript'i global olarak yükleyin. `-g` seçeneği, typescript'in tüm sistemde kullanılabilir olmasını sağlar.

2. **yükleme sonrası kontrol**:

   - yükleme tamamlandıktan sonra, `tsc --version` komutunu çalıştırarak typescript compiler'ın başarıyla yüklendiğini ve versiyonunu kontrol edin.

3. **typescript compiler'ı kullanma**:

   - typescript compiler yüklendikten sonra, `tsc main.ts` komutunu tekrar çalıştırarak `main.ts` dosyanızı javascript'e çevirebilirsin.

alternatif çözüm: proje bazında typescript yükleme

eğer typescript'i sadece belirli bir projede kullanmak istiyorsanız, projenin kök dizininde typescript'i yerel olarak yükleyebilirsin:

1. **proje dizinine gitme**:

   - komut istemcisinde, typescript'i yüklemek istediğin projenin kök dizinine gidin.

2. **yerel typescript yükleme**:

   - `npm install typescript --save-dev` komutunu kullanarak typescript'i projene yerel olarak yükleyin.

3. **npm scriptleri kullanarak derleme**:

   - `package.json` dosyanızda bir npm scripti oluşturarak typescript dosyalarınızı derleyebilirsin. örneğin:
     ```json
     "scripts": {
       "build": "tsc"
     }
     ```
   - daha sonra `npm run build` komutu ile typescript dosyalarınızı derleyebilirsin.

bunları bilmelisin

- **global vs. yerel yükleme**: typescript'i global olarak yüklemek, her projede ayrı ayrı yüklemekten daha pratik olabilir. ancak, farklı projelerde farklı typescript versiyonları kullanmanız gerekiyorsa, yerel yükleme daha uygun olabilir.

- **yol (path) sorunları**: eğer `tsc` komutu hala tanınmıyorsa, sistem yolunuzda (path) bir sorun olabilir. bu durumda, typescript'in yüklendiği yolu sistemindeki yol değişkenlerine eklemen gerekebilir.

</details>

## adım 3: eklenti kodunu yazma

1. **main.ts dosyası oluşturma**:

   - projenin kök dizininde `main.ts` adında bir dosya oluşturun

2. **eklenti kodunu yazma**:

   - aşağıdaki kodu `main.ts` dosyasına yapıştırın:

    ```javascript
    import { plugin } from 'obsidian';

    export default class lowercaseplugin extends plugin {
        async onload() {
            this.addcommand({
                id: 'lowercase-text',
                name: 'convert selected text to lowercase',
                editorcallback: (editor, view) => {
                    const selectedtext = editor.getselection();
                    const lowercased = selectedtext.tolowercase();
                    editor.replaceselection(lowercased);
                }
            });
        }
    }
    ```

> kodu chatgpt yazdığı için uppercase görüyorsunuz :)

## adım 4: eklentiyi derleme ve yükleme

1. **typescript'i javascript'e derleme**:

   - `tsc main.ts` komutunu çalıştırarak typescript dosyasını javascript'e çevirin

2. **eklenti dosyalarını obsidian'a yükleme**:

   - derlenmiş `main.js` dosyasını ve bir `manifest.json` dosyasını (bu dizinde oluşturun) içeren bir klasör oluşturun
   - `manifest.json` dosyasına eklentinin detaylarını (aşağıda bir örneği var) yazın
   - bu klasörü obsidian'ın eklenti klasörüne kopyalayın. bu klasör genellikle `obsidiankasayolu/.obsidian/plugins/` altında bulunur

## adım 5: eklentiyi test etme

1. **obsidian'ı aç ve eklentiyi etkinleştir**:

   - obsidian'ı açın, ayarlar menüsünden eklentiler bölümüne gidin ve yeni eklediğin eklentiyi etkinleştirin

2. **eklentiyi kullan**:

   - bir not açın, metin seçin ve eklentiyi test edin

> ayarlar/kısayollar ya da komut paletinden (ctrl + p) kısayol atayabilirsin

### adım 6: hata ayıklama ve i̇yileştirme

- eğer eklenti beklediğin gibi çalışmıyorsa, konsol hatalarını kontrol edin ve kodunuzda gerekli düzeltmeleri yapın

## manifest.json örneği

```json
{
  "id": "lowercase-plugin",
  "name": "lowercase converter",
  "version": "1.0.0",
  "minappversion": "0.12.0",
  "description": "a simple obsidian plugin to convert selected text to lowercase.",
  "author": "düz_ibrahim",
  "authorurl": "https://ademavsar.github.io",
  "isdesktoponly": false,
  "js": "main.js",
  "css": "styles.css"
}
```