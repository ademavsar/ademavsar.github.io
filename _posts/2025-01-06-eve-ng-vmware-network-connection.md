---
title: "EVE-NG Lab Ortamını VMware Ağına Bağlama"
categories: [Lab]
tags: [eve-ng, vmware, networking]
---

## VMware'daki bir istemci/sunucu ile EVE-NG iç ağ bağlantısını sağlamak

VMNet5 ile EVE-NG Cloud7'yi bağlamak için örnek bir çalışma.

![EVE-NG VMware Görsel 1](/assets/202501/20250106-eve-ng-vmware-01.png)

### VMNet5'i VMware Üzerinde Ekleme

VMware Workstation üzerinde Virtual Network Editor kullanarak yeni bir ağ olan VMNet5'i oluşturuyoruz ve Host-only modunda yapılandırıyoruz. Bu işlemde 192.168.73.0/24 alt ağı kullanılıyor ve DHCP hizmeti etkinleştiriliyor.

![EVE-NG VMware Görsel 2](/assets/202501/20250106-eve-ng-vmware-02.png)

![EVE-NG VMware Görsel 3](/assets/202501/20250106-eve-ng-vmware-03.png)

![EVE-NG VMware Görsel 4](/assets/202501/20250106-eve-ng-vmware-04.png)

![EVE-NG VMware Görsel 5](/assets/202501/20250106-eve-ng-vmware-05.png)

![EVE-NG VMware Görsel 6](/assets/202501/20250106-eve-ng-vmware-06.png)

### VMware'daki istemci için VMNet5'in Tanımlanması

VMware'de sanal makineye ek bir ağ adaptörü ekliyoruz. Add butonuna tıklayarak Network Adapter seçiyoruz ve işlemi tamamlıyoruz. Yeni adaptörü VMNet5'e bağlamak için Custom: Specific virtual network seçeneğini işaretliyor ve VMNet5'i seçiyoruz.

![EVE-NG VMware Görsel 7](/assets/202501/20250106-eve-ng-vmware-07.png)

![EVE-NG VMware Görsel 8](/assets/202501/20250106-eve-ng-vmware-08.png)

Sonraki adımda, Kali'den ``ifconfig`` komutuyla VMnet5'ten 192.168.73.128 ip adresini aldığımızı görüyoruz. 

![EVE-NG VMware Görsel 9](/assets/202501/20250106-eve-ng-vmware-09.png)

### EVE-NG'de VMNet5'in Tanımlanması

Kali için yaptığımız işlemleri EVE-NG için de yapıyoruz.

![EVE-NG VMware Görsel 10](/assets/202501/20250106-eve-ng-vmware-10.png)

VMnet5'i ekledikten sonra MAC adresini not alalım. Buna sonraki adımda ihtiyacımız olacak.

![EVE-NG VMware Görsel 11](/assets/202501/20250106-eve-ng-vmware-11.png)

MAC adresi:

```
00:0C:29:A0:37:98
```

### EVE-NG Ağ Yapılandırmasının Düzenlenmesi

EVE-NG içerisinde`` ip link show`` komutu ile VMnet5'i bulalım. Bunu yaparken not aldığımız MAC adresinden faydalanıyoruz.

![EVE-NG VMware Görsel 12](/assets/202501/20250106-eve-ng-vmware-12.png)

``ip link show`` çıktısı çoksa alternatif olarak ``grep`` komutu ile de sonuca ulaşabiliriz.

```
ip link show | grep -B 1 -i 00:0C:29:A0:37:98
```

- ``-i`` büyük/küçük harf duyarlılığını devre dışı bırakmak için.
- `-B 1` Eşleşen satırın bir önceki satırını da gösterir.

![EVE-NG VMware Görsel 13](/assets/202501/20250106-eve-ng-vmware-13.png)

VMware üzerinde eklenen VMNet5 adaptörüne karşılık gelen eth1 arayüzü, doğru şekilde MAC adresi 00:0c:29:a0:37:98 ile eşleştirilmiştir.

Sonraki adımda **/etc/network/interfaces** dosyasını düzenleyeceğiz.

```
nano /etc/network/interfaces
```

Açılan dosyada yeni adaptörü (bende eth1) Cloud7 ile eşleştirmek için şu satırları ekleyelim. Bu satırlar mevcutsa da güncelleyelim.

```
iface eth1 inet manual
auto pnet7
iface pnet7 inet manual
    bridge_ports eth1
    bridge_stp off
```

![EVE-NG VMware Görsel 14](/assets/202501/20250106-eve-ng-vmware-14.png)

Dosyayı kaydedip çıkıyoruz (CTRL+O, ardından CTRL+X).

Ve son olarak yaptığımız değişikliklerin geçerli olması için ağ hizmetlerini yeniden başlatalım.

```
service networking restart
```

Bu işlemler sonucunda aşağıdaki yapıyı sorunsuz bir şekilde sağlamış oluyoruz..

```
eth1 (VMware adaptörü) <--> pnet7 (EVE-NG köprüsü) <--> Cloud7 (EVE-NG ağı)
```

---

### Test

EVE-NG'ye dönüp bir test yaparak sonucu görelim.

- VMware'daki istemcimizin (Kali Linux) ip adresi 192.168.73.128 idi. 
- EVE-NG'deki VPC ip adresine ise 192.168.73.101 atadık.

![EVE-NG VMware Görsel 15](/assets/202501/20250106-eve-ng-vmware-15.png)

![EVE-NG VMware Görsel 16](/assets/202501/20250106-eve-ng-vmware-16.png)

Fortigate’in port2’si, VMware üzerindeki Kali Linux ile eşleştirilerek iki sistem arasında iletişim kuruldu. Bu yapılandırma, Kali’nin EVE-NG ağı üzerinden Fortigate’e bağlanmasını sağlayarak test ve demo çalışmaları için uygun bir ortam sağlıyor.

İyi çalışmalar...
