import 'package:flutter/material.dart';

// GENEL TASARIM: Ana bir Column var. Bu Column, iki ana parçadan oluşuyor. Yani iki çocuğu var.
// A: Sekme butonlarını tutan Row. Row -> [Button1, Button2, Button3]
// B: Sekmenin kendi içeriği. _bodyWidgets[Tab1, Tab2, Tab3] gibi düşünülebilir.

class MultiTabLayout extends StatefulWidget {
  const MultiTabLayout({Key key,}) : super(key: key);
  // Değişken atamak istiyorsan buraya eklemelisin.
  @override
  State<StatefulWidget> createState() => MultiTabLayoutState();
}

class MultiTabLayoutState extends State<MultiTabLayout>
    with SingleTickerProviderStateMixin<MultiTabLayout> {
  
  // Hangi sekmenin seçili olduğunu belirleyen bir değişken. Silinmemeli.
  int selectedTab = 0;

  // Private _bodyWidget değişkenini tanımladık.  
  List<Widget> _bodyWidgets;

  @override
  void initState() {
    super.initState();

// Stateful widget ilk başladığında initState kısmında tab içeriklerimizi belirliyoruz. 
// Ben örnek olsun diye üç basit container yaptım.
    _bodyWidgets = [
      // 1. İçerik
      Container(
        height: 150,
        color: Colors.blueAccent,
        child: Center(
          child: Text("First Tab"),
        ),
      ),
      // 2. İçerik
      Container(
        height: 50,
        color: Colors.orangeAccent,
        child: Center(
          child: Text("Second Tab"),
        ),
      ),
      
      // 3. İçerik
      Container(
        height: 300,
        color: Colors.redAccent,
        child: Center(
          child: Text("Third Tab"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Burda MultiTabState artık bir widget'a dönüşüyor build metodu sayesinde.
    // En başta bahsettiğim Column. A ve B yi içinde tutuyor alt alta olacak şekilde.
    return Column(
      children: <Widget>[

        // ***** A KISMI ***** 
        // Yani sorun yaşadığınız ilk kısım. Eşit genişlikteki 3 sekme butonundan oluşuyor.
        Row(
          // Yataydaki hizalamayı ayarlıyoruz. Diğer seçenekleri görmek için "spaceBetween" kısmını silip,
          // ".start", ".spaceAround" vs. yazabilirsiniz. Ama uygun olanı ".spaceBetween"
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // 1. BUTTON ALANI

            // 1. Buton için alan. Expanded ile genişlettik. Ne kadar? Ne kadar alan tutabiliyorsa o kadar
            // tutmaya çalışacak.
            Expanded(
              // Flex, orantısal olarak kaç birim yer tutacağını belirliyor. Mesela flex:2 dersek 2 birim tutmaya çalışır.
              //flex: 2

              // child olarak GestureDetector tanımladık. Bu sayede dokunmaları algılayabilecek.
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                  });
                },
                // Burda ise butonu özelleştirmeye başlıyoruz. TabButton, refactor edilip en altta tanımlanan
                // bir widget. Değişiklikleri ordan yapacaksınız.
                // Ben text: özelliği atadım. Bunu en alttaki TabButton classında gerekli değişiklikleri 
                //yapmak kaydıyla ikon ile de değiştirebilirsiniz.

                // "BUTTON 1" yazısını nasıl isterseniz değiştirin.
                // selectedTab == 0 diyerek seçili olup olmadığını denetletiyoruz.
                // DİKKAT! isSelected bir bool değişkeni. Yani ya true ya da false. 
                // selectedTab == 0 ise -> "isSelected: true" oluyor. Yani ben seçiliyim diyor.
                child: new TabButton(text: "BUTON 1", isSelected: (selectedTab == 0)),
              ),
            ),
            
            // 2. BUTTON ALANI
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
                child: new TabButton(
                  // Bu 2. sekme olduğu için selectedTab == 1 dedik. Not: Yazılım dillerinin hemen hepsinde diziler, listeler, array ler 0dan başlar. 2. eleman [1] olur.
                    text: "BUTON 2", isSelected: (selectedTab == 1)),
              ),
            ),
            
            // 3. BUTTON ALANI
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 2;
                  });
                },
                child: new TabButton(
                    text: "BUTON 3", isSelected: (selectedTab == 2)),
              ),
            ),
          ],
        ),

        // ***** B KISMI *****
        
        // Tab Body. Sekmelerin kendileri.
        // NEDEN STACK?
        // Stack ile 3 sekme de hep oluşturulmuş oluyor. Üst üste duruyorlar.
        // Visibility widget ve yaptığım ayarlar ile, 3 sekmeyi de widget ağacında tutuyoruz.
        // Ancak sadece seçili olan sekmeyi görünür ve etkileşilebilir yapıyoruz.

        Stack(
          children: <Widget>[

            // 1. Sekme için kontrolcü
            Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: false,

                // Eğer seçiliyse "selectedTab == 0" kısmı "true" olacak. Sonuç olarak visible: true olacak.
                // Diğerleri için ise visible: false olmuş oluyor o anda.
                visible: (selectedTab == 0),

                // Başta tanımladığımız sekme içerikleri. Bunları buraya da doğrudan child: olarak yazabilirdik.
                // Ancak okunabilirlik, düzenlenebilirlik açısından aşırı kötü olurdu.
                // Örneğin _bodyWidgets listesini siz yukarda, 3 adet ListView dan oluşan widget ile değiştirebilirsiiniz.
                // Hatta bu ListView lar farklı .dart dosyalarından import edilmiş olabilir.
                child: _bodyWidgets[0]),
            
            // 2. Sekme için kontrolcü
            Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: false,
                visible: (selectedTab == 1),
                child: _bodyWidgets[1]),
            
            // 3. Sekme için kontrolcü
            Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: false,
                visible: (selectedTab == 2),
                child: _bodyWidgets[2]),
          ],
        )
      ],
    );
  }
}

// Sekme butonlarını özelleştirdiğimiz sınıf.
// TabButton, bir container içindeki column dan oluşuyor.
// Bu Column un da iki çocuğu var. Birisi buton yazısı, diğeri ise nokta şeklindeki bir indikatör.

class TabButton extends StatelessWidget {
  TabButton({
    Key key,
    @required this.isSelected,
    @required this.text,
  }) : super(key: key);

  final String text;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100], width: 1)),
      ),
      
      // Expanded widget için yükseklik sınırlaması buradan geliyor. Buradaki height: 48,
      // aynı zamanda Row un da yüksekliğini belirliyor. Parent widgetlar, child widgetları kapsayacak şekilde
      // oluşuyor.
      height: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          
          // Butonun yazısı. bu text widget ı dediğim gibi bir icon ile değiştirmek mümkün.
          Text(
            text,
            style: TextStyle(
                fontSize: 15,
                fontWeight: (isSelected) ? FontWeight.w700 : FontWeight.w600,
                
                // Sekme seçiliyse, kullanıcının anlaması için 
                // sekme yazısının rengini siyah yapıyorum.
                // ? işareti kendinden önceki şart "true" ise ":" dan önceki kısmı uyguluyor. Yani siyah renk.
                // eğer isSelected "false" ise ":" dan sonraki kısmı uyguluyor. Yani çok açık gri bir renk.
                color: (isSelected) ? Colors.black87 : Colors.black26),
          ),
          
          
          // Bu aslında basit bir nokta. İndikator olarak kullandım.
          Container(
            margin: EdgeInsets.only(top: 4, bottom: 4),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // Sekme seçiliyse, kullanıcının anlaması için 
                // sekmenin altındaki noktanın (indikatörün) rengini siyah yapıyorum.
                // ? işareti kendinden önceki şart "true" ise ":" dan önceki kısmı uyguluyor. Yani siyah renk.
                // eğer isSelected "false" ise ":" dan sonraki kısmı uyguluyor. Yani transparent. Renksiz, saydam.
                color: (isSelected) ?  Colors.black87 : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
