goog.provide 'app.Storage'

goog.require 'common.Storage'
goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.Storage extends common.Storage

  ###*
    PATTERN(steida): This should be one place to change/sync app state.
    The goal is http://en.wikipedia.org/wiki/Persistent_data_structure
    with all its benefits.
    @param {app.Store} appStore
    @param {app.songs.Store} songsStore
    @constructor
    @extends {common.Storage}
  ###
  constructor: (appStore, @songsStore) ->
    super appStore

    ###*
      @type {Array.<app.Store>}
    ###
    @stores = [
      @songsStore
    ]

    if @tryCreateLocalStorage()
      @updateStoreOnLocalStorageChange()
    @fetchStoresFromLocalStorage()
    @listenStores()

  ###*
    @const
    @type {string}
  ###
  @LOCALSTORAGE_KEY: 'songary'

  ###*
    @type {goog.storage.Storage}
    @protected
  ###
  localStorage: null

  ###*
    @override
  ###
  promiseOf: (route, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        song = @songsStore.songByRoute route
        return @notFound() if !song
        @songsStore.song = song
        @ok()
      else
        @ok()

  ###*
    NOTE(steida): Plain browser localStorage is used to store and retrieve
    app state snapshot for now. In future, consider:
    - http://git.yathit.com/ydn-db/wiki/Home
    - https://github.com/swannodette/mori
    - https://github.com/benjamine/jsondiffpatch
    @return {boolean}
    @protected
  ###
  tryCreateLocalStorage: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage Storage.LOCALSTORAGE_KEY
    # For instance, Safari in private mode does not allow localStorage.
    return false if !mechanism
    @localStorage = new goog.storage.Storage mechanism
    @preloadDefaultSongs()
    true

  preloadDefaultSongs: ->
    return if @localStorage.get 'songs'

    store = new app.songs.Store
    for jsonSong in Storage.DefaultSongs
      store.updateSong store.newSong, 'name', jsonSong['name']
      store.updateSong store.newSong, 'artist', jsonSong['author']
      store.updateSong store.newSong, 'lyrics', jsonSong['lyrics']
      store.addNewSong()
    @localStorage.set store.name, store.toJson()

  ###*
    NOTE(steida): This sync app state across tabs/windows.
    @protected
  ###
  updateStoreOnLocalStorageChange: ->
    # NOTE(steida): IE 9/10/11 implementation of window storage event is
    # broken. http://stackoverflow.com/a/4679754
    # Naive fix via document.hasFocus() does not work. Investigate it later.
    return if goog.labs.userAgent.browser.isIE()
    goog.events.listen window, 'storage', (e) =>
      browserEvent = e.getBrowserEvent()
      storeName = browserEvent.key.split('::')[1]
      store = goog.array.find @stores, (store) -> store.name == storeName
      return if !store
      # TODO(steida): Try/Catch in case of error. Report error to server.
      json = JSON.parse browserEvent.newValue
      goog.asserts.assertObject json
      store.fromJson json
      store.notify()

  ###*
    @protected
  ###
  fetchStoresFromLocalStorage: ->
    return if !@localStorage
    @stores.forEach (store) =>
      json = @localStorage.get store.name
      return if !json
      # TODO(steida): Try/Catch in case of error. Report error to server.
      store.fromJson json

  ###*
    @protected
  ###
  listenStores: ->
    @stores.forEach (store) =>
      store.listen 'change', (e) =>
        store = e.target
        if @localStorage
          # TODO(steida): Try/Catch in case of error. Report error to server.
          @localStorage.set store.name, store.toJson()
        @notify()
        # TODO(steida): Server sync, consider diff.

  # NOTE(steida): Ported from old songary.
  @DefaultSongs = `
  [
      {
        "name": "Je jaká je",
        "author": "Karel Gott",
        "lyrics": "DJe jaF#miká je, Gtak mi náhAle padla Ddo kF#milína, \n\nGani Ačerná Dani bloF#mindýna, Gněkdy Atak a jinDdy taková, \n\nHmi,GvždycAky hádam jak Dse HmizachoGvá, Azrejme nikDdy Hmijak GchAci já. \n\n\n\nJe jaká je, trochu dítě, trochu mondéna, \n\nnemám právě paměť na jména, tak jí říkám lásko má. \n\nNejsi skvost a nejsi zlá, jsi jen jiná než chci já. \n\n\n\nJe jaká je, že se změní čekat nedá se, \n\nsnad jí záleží jen na kráse, tak, že člověk málem nedůtá, \n\njak je štíhlá, jak je klenutá, jenže jinak, než chci já. \n\n\n\nJe jaká je, až jí zitra spatříš u pláže, \n\nvzkaž jí, ať se na mě neváže, ať si pro mě vrásky neděla, \n\nať je jaká je a veselá, i když jiná než chci já.",
        "creatorId": "luteemsu35x",
        "created": 1366714742757,
        "updated": 1366714742757,
        "id": "b5dei1sdp16c",
        "_cid": ":1b"
      },
      {
        "name": "Klobouk ve křoví",
        "author": "Ježek + Voskovec + Werich",
        "lyrics": "C, C#dim, G7, G+ \nCVítr B9vaC#7ne poCuštíG+ \nCpo písku B9žene kloCboukC7 \nFmizahnal G#7ho G7do ChouštíAmi \nFmistarý a G#7čerG7ný kloCboukG7 \n\nCKdepak B9je C#7ta Chlava,G+ \nCkterá kloB9bouk nosiClaC7 \nFByla čerG7ná či Cplavá?Ami \nFmiKomu G7asi patřiCla? \n\nEmiKdo to v poušti Fzmizel? \nEmiOdkud šel a A7kam? \nGJakou to měl D7svízel, \nGže byl v F7poušF#7ti G7sám?G+ \n\nCJen zaAsváté CstopyG+ \nCstarý kloB9bouk ve křoA7ví \nDminikFmido nic As7neG7poCchopíAmi \nFminikdo se As7nic G7nedoCví",
        "creatorId": "luteemsu35x",
        "created": 1366714643021,
        "updated": 1366714643021,
        "id": "c2sqksp55ikj",
        "_cid": ":1a"
      },
      {
        "name": "To sa nerozchodí",
        "author": "Fleret",
        "lyrics": "KdGyž větr cérčiska nDa jaře rGozcuchá, \nsrdce mi radosťú, rDadosťú zGabúchá. \n\nKdyž větr cérčiska na lícoch polechtá, \ndycky si pod fúsy, pod fúsy zafrflám. \n\n®: GEj, rycom rAmiyc, tCeplo, horko, hDic\n\nhEmiorem-dolem pGo mě chodDí, \ntAmiož to sa Cenom tak nDerozchodGí. \n\nKdyž větr cérčiskám do blůzek zablúdí, \ncosi sa ve mně hned, ve mně hned obudí. \n\nKdyž sa větr cérčiskám kolem pasu zakrútí, \nočiska valím jak, valím jak na púti. \n\n®: \n\nKdyž větr cérčiskám sukénky nadzvedá, \ntož to sa v kuse furt, v kuse furt ohlédám. \n\nKdyž větr cérčiskám pod sukňú zatančí, \nvšecko sa ve mně hned, ve mně hned rozjančí. \n\n®:",
        "creatorId": "luteemsu35x",
        "created": 1366495766416,
        "updated": 1366495766416,
        "id": "c73yar9xgzjx",
        "_cid": ":19"
      },
      {
        "name": "Na koníčka vyskočím",
        "author": "Radůza",
        "lyrics": "CmiZ kolotoče za dvě voče na Matějský pouti, \nvolají mě sladkým hlasem zelený kohouti, \nFmiPojeď holka, pojeď s náma, pojeď s náma \npojeď nebo Cmi sama aGhahaCmihá \n\nCmiNa koníčka vyskočím, ještě si výsknu, \ndokola se zatočím, uzdečku stisknu, \nFmivšichni moji přátelé i všechno kolem \nje tak veseCmilé eGheheCmihé… \n\n\nFmiMně se, mně se, mně se brada Cmi třeeGeeCmise \n\n\nŘíkala mi moje máma jseš toulavá kočka, \nkdo by si vzal tebe holka, jó, ten by se dočkal, \nkde jsi byla, kam zas jdeš a prohlížej si zeď, \na doma seď a doma seď. \n\nMně se brada třese Cmi,B,Cmi,G,Cmi \n\nAť jsem byla, co jsem byla, teď to není lepší, \nnež když jsem žila, co jsem žila, když jsem byla mladší, \npro pět ran do čepic a ric pic, buď Ritz \na nebo nic a nebo nic, \npro pět ran do čepic a ric pic, buď Ritz \na nebo nic a nebo nic. \n\n\nNa koníčka vyskočím… \n\n\nMně se brada třese Cmi,B,Cmi,G,Cmi",
        "creatorId": "luteemsu35x",
        "created": 1366495678528,
        "updated": 1366495678528,
        "id": "bg6bjmdqt6yv",
        "_cid": ":18"
      },
      {
        "name": "Dederon",
        "author": "Tři Sestry",
        "lyrics": "EČas je díra F#mičas je bič ALepší kdyby Hvůbec nebyl \nENejednou chceš F#misvůj balon AZtracenej je Hv dětsví nebi \nEletí dál a F#mistoupá výš ALetí proudem Hroků zpátky \nETo jen čas trh F#mioponou AVěci mizí - Hkde už jsou \n\nENejednou chci F#misvůj balón AZpuchřelá a Hprasklá duše \nJistě řeknu - to je on Poznám ho měl jsem ho rád \nKažda další známá věc Kaugummi a pflege dusche \nDrážďany a schone schuhe A zde simpson motorrad \n\nMý gumoví indiáni Z ulice unter den Linden \nPozději jsem se tam zpil Zrovna když byl feuer werk \nTmavý pivo se sirupem řízek v sósu s knedlíkem \ncigára Káro byly fajn pak z U-Bahnu na S- Bahn \n\nNejednou chci svůj balón a nesměle to zkouším řici \nVraťte mi to všechno zpět na tábor chci k moři jet \nco má v létě desset stupň; a trabanta v pryskyřici \nJedno jak se změnil svět já chci zpátky svůj balón \n\nNejednou chceš svůj balon ztracenej je v dětsví nebi \nVšechny věci cos měl rád na tebe tam tiše čekaj \nAž se tvůj čas naplní letíš proudem roků zpátky \nNěkde najdeš svůj balón nech ho zatím - ať si lítá.",
        "creatorId": "luteemsu35x",
        "created": 1366495578747,
        "updated": 1366495578747,
        "id": "im5aomu7cw7g",
        "_cid": ":17"
      },
      {
        "name": "Abdul Hasan",
        "author": "Tři Sestry",
        "lyrics": "2x: Emi, C, G, Emi \nEmiLéto je a Cvoní Rýnem VlGtaEmiva \nEmiprochází se Cpod Petřínem výGpraEmiva \nDávaj si Cpívo, buřty a Dlangoše \nhvězdy jim Csvítěj - nehleděj Dna groše \nEmiNevědí kde Cteče řeka MeGtuEmije \nEminevědí že CHonza z Libně feGtuEmije \nNemá na Cpivo k tomu je Ddebilní \nukradne Cmarky, telefón Dmobilní. \n\nRef: GMiluju Karlův Cmost špatnej Gvkus C, G \nA C v besedě Dblues \nGV létě pivo Cmá příchuť Gsena C \nA Gfoťák ti Cukradne DRus, ukradne EmiRus \n\nEmiLéto je a Cvoní Rýnem VlGtaEmiva \nEmiprochází se Cu Perlovky výGpraEmiva \nDávaj si Ckafe, semtex a Dviagru \na policie Chlídá je Dod bagru \nEmiAbdul Hasan Cten nemá čas na GštětEmiky \nEmiKontroluje Cdráty, semtex, rozGnětEmiky \nHlídá ho CAlláh, BIS je mu Dna stopě \nzasadí Cránu Svobodný DEvropě \n\n2x Ref:",
        "creatorId": "luteemsu35x",
        "created": 1366495141448,
        "updated": 1366495141448,
        "id": "eypr6h2ca3hv",
        "_cid": ":16"
      },
      {
        "name": "Summer In The City",
        "author": "Joe Cocker",
        "lyrics": "[Intro]\nDm | A# (repeat)\n\n[verse 1:]\nDm          Dm/C                G/B                    A#         A\n  Hot town, summer in the city; back of my neck getting dirty and gritty\nDm           Dm/C             G/B                 A#             A\n  Been down, isn't it a pity; doesn't seem to be a shadow in the city\nA              A7\n  All around, people looking half dead\nDm                       D\nWalking on the sidewalk, hotter than a match head\n\n[chorus:]\nG                     C\n  But at night it's a different world\nG            C\n  Go out and find a girl\nG                      C\n  Come-on come-on and dance all night\nG                        C\n  Despite the heat it'll be alright\n    Em              A\nAnd babe, don't you know it's a pity\n         Em         A\nThat the days can't be like the nights\n       Em             A\nIn the summer, in the city\n       Em             A\nIn the summer, in the city\n\n[Link]\nDm | A# (repeat)\n\n[verse 2:]\nCool town, evening in the city; Dressing so fine and looking so pretty\nCool cat, looking for a kitty; Gonna look in every corner of the city\nTill I'm wheezing like a bus stop\nRunning up the stairs, gonna meet you on the rooftop\n\n[chorus]\n\n[Link]\n\n[Instrumental break]\nChords as verse\n\n[chorus]\n\n[Link to outro]\nF#m | B (repeat)\n\n[Outro] (Verse but up a tone)\nEm | Em/C | A/C# | C B |",
        "creatorId": "luteemsu35x",
        "created": 1366494598937,
        "updated": 1366494598937,
        "id": "g65k2bp0mqe4",
        "_cid": ":15"
      },
      {
        "name": "Samba V Kapkách Chlastu",
        "author": "Xavier Baumaxa",
        "lyrics": "[D#7]Můj lékař mi [Cmi]doporučil [G#]dvě plzínky [B]denně \n[D#7]Tvrdí, že to [Cmi]podporuje [G#]dobrý přístup [B]k ženě \n[G#]Nevím, co mě [F]do hospody [D#7]denno[Dsus2]den[C#sus2]ně [Cmi]žene, \n[G#]Ale mám to [B]tam tak trochu [D#7]rád [B] \n\nPo plzničkách otevírám první láhev vína \nHlavu už si podepírám - ty jsi nějaká jiná! \nJe pravdou, že si neupírám, nejsem totiž upír \nJsi má žena a chlast můj kamarád \n\nPotácím se do ložnice, zvládneme to ve třech \nMoje žena, chlast a já a také vnitřní tetřev \nJeště sklenku portského a zvládneme to v pěti! \nJen jsem zvědav, co si ráno o tátovi budou myslet děti \n\n/Sólo na pozoun - Honza Šatra!/ \n\nTančím jako Bohouš Josef sambu v kapkách deště \nRecenze to nemá dobré - ale já chci ještě! \nTančím jako Bohouš Josef sambu v kapkách chlastu \nV těžké chvíli vzpomenu si na mou mámu, na Bouchačku Vlastu \n\nTančím sambu, dej mi pámbů tvůj vztyčený prstík \nUkousnu jej, orestuji, smažím tím svůj restík \nMoje žena ze mě kvete, já jsem její pestík \nOpilý a otylý ji opyluji, pak dostanu [D#7]pěstí [Cmi], [G#], [B] \n\npak dostanu [D#7]pěstí [Cmi], [G#], [B] \npak dostanu [G#]pěstí [F], [D#7], [Dsus2], [C#sus2], [Cmi] \n[G#]Ale mám to [B]tam tak trochu [D#7]rád\n[G#]Ale mám to [B]tam tak trochu [D#7]rád",
        "creatorId": "luteemsu35x",
        "created": 1366493277134,
        "updated": 1366493277134,
        "id": "zhabe09rn3ij",
        "_cid": ":14"
      },
      {
        "name": "Tři čuníci",
        "author": "Jaromír Nohavica",
        "lyrics": "V [C]řadě za sebou, tři čuníci jdou \nťápají se v blátě cestou necestou[Ami] \n[Dmi]Kufry nemají, cestu neznají[G7] \n[Dmi]Vyšli prostě do světa a [G7]vesele si zpívají \n\n®:Uiiiiii ui uiiiii, ui ui ui ui, uiiii .. \n\nAuta jezdí tam a náklaďáky sem \nTři čuníci jdou jdou rovnou za nosem \nŽito chroupají, ušima bimbají \nVyšli prostě do světa a vesele si zpívají \n\nLevá pravá teď, přední zadní už, \ntři čuníci jdou, jdou, jako jeden muž \nLidé zírají, důvod neznají \nProč ti malí čuníci tak vesele si zpívají \n\nKdyž kopýtka pálí, když jim dojde dech \nsednou ku studánce na vysoký břeh \nušima bimbají, kopýtka máchají \nChvilinku si odpočinou a pak dál se vydají \n\nKdyž se spustí déšť, roztrhne se mrak, \nk sobě přitisknou se čumák na čumák \nBlesky blýskají, kapky pleskají \nOni v dešti, nepohodě vesele si zpívají \n\nZa tu spoustu let co je světem svět \nPřešli zeměkouli třikrát tam a zpět \nV řade za sebou, hele támhle jdou \nPojďme s nima zaspívat si jejich píseň veselou.",
        "created": 1364615964979,
        "updated": 1365677344801,
        "creatorId": "luteemsu35x",
        "id": "ie5dux98t85c",
        "_cid": ":6"
      },
      {
        "name": "Bláznivá Markéta",
        "author": "Jaromír Nohavica",
        "lyrics": "[Cmi]Bláznivá Marké[G7]ta v [G7]podchodu těšíns[Cmi]kého nádraží\n\n[Fmi]zpí[Cmi]vá,  [Fdim]zpí[Cmi]vá,   [G7]zpí[Cmi]vá a za[G7]me[Cmi]tá, \nje to princezna zakle[G]tá, s [G7]erární metlou [Cmi]jen tak pod paží, \nkdyž [Fmi]zpí[Cmi]vá,  [Fdim]zpí[Cmi]vá,  [G7]zpí[Cmi]vá a za[G7]me[Cmi]tá. \nR: Vajglové [Cmi]blues, rumový song, jízdenková [G7]symfonietta, \npach piva z [Cmi]úst a oči plonk, to zpívá [G7]Markéta, \n[Es]bláznivá [G7]Marké[Cmi]ta, [Fmi]la [Cmi]la [Fdim]la la [Cmi]la [Fdim]la la [Cmi]la [G7]la [Cmi]la. \n\nFamózní subreta na scéně válečného šantánu \nbyla, byla krásná k zbláznění, \nLíza i Rosetta, lechtivé snění zdejších plebánů, \nbyla, byla, byla, a není. \n\nR: \n\nV nádražním podchodu jak v chrámu katedrály v Remeši \nticho, ticho, Markéta housku jí, \npak v kanclu u vchodu své oranžové blůzy rozvěší, \na já ji, a já ji, a já ji pořád miluji ...",
        "creatorId": "luteemsu35x",
        "created": 1365456544735,
        "updated": 1365462308295,
        "id": "yep1qh1deysm",
        "_cid": ":t"
      },
      {
        "name": "Rocking back in my heart",
        "author": "Badalamenti",
        "lyrics": "H dur furt? Najít",
        "creatorId": "luteemsu35x",
        "created": 1365460764125,
        "updated": 1365460764125,
        "id": "9b3yepqw22bt",
        "_cid": ":13"
      },
      {
        "name": "Evangelium podle Jarouše",
        "author": "Traband",
        "lyrics": "Já [Dmi]vím, že bych měl [C7]napravit svý [F]cesty[A7] \nPřestat [Dmi]krást, přestat [C7]pít, přestat [F]lhát[A7] \na když se [Dmi]polepším, a [C7]budu mít to [F]štěstí[A7]\nněkdo tam [Dmi]nahoře – možná - [C7]bude mě mít [F]rád[A7]\n\nMožná řeknete, že žádný nebe není \na všechno je jen veteš z učebnic \nA k čemu milost nebo zatracení \nkdyž stejně umřem - a potom nic \n\nNe, já nevěřím, že život je jen náhoda \nJá chci, aby byl Bůh – s velkým B! \nA chtěl bych, aby řek mi: Pane Svoboda \npojďte, odvedu vás do nebe \n\nTam [Dmi]hudba bude hrát a [B]tančit budou andělé \nA [Dmi]bílý hadry ať mi [A7]oblečou \nA [Dmi]ženský bílý jako sníh - [B]bílý pentle ve vlasech \n[Dmi]moje bílý [A7]tělo [Dmi]odvezou[A7]\n[Dmi], [F], [C], [D], [Eb], [D]",
        "creatorId": "luteemsu35x",
        "created": 1365459306365,
        "updated": 1365459306365,
        "id": "sg3xren11pw3",
        "_cid": ":12"
      },
      {
        "name": "Danse macabre",
        "author": "Jaromír Nohavica",
        "lyrics": "®: [Dmi], [B]Naj naj [Dmi]na [B]naj naj[Dmi], [B], [Dmi], [B], [Dmi], [F], [A], [Dmi], [B], [F], [C], [F], [A] \n\n[Dmi]Šest milionů srdcí vyletělo komí[B]nem, \n[Dmi]svoje malé lži si, lásko, dnes promi[B]nem, \n[F]budeme tančit s [A]venkovany, \nna návsi [Dmi]vesnice budeme se sm[B]át[F], [C]mám tě [F]rád[A]. ®: \n\nLáska je nenávist a nenávist je láska, \njedeme na veselku, kočí bičem práská, \nv červené sametové halence \npodobáš se Evě i Marii, dneska mě zabijí. ®: \n\nMé děti pochopily, hledí na mě úkosem, \ntřetí oko je prázdný prostor nad nosem, \nPánbůh se klidně opil levným balkánským likérem \na teď vyspává, jinak to smysl nedává. ®:",
        "creatorId": "luteemsu35x",
        "created": 1365459122107,
        "updated": 1365459122107,
        "id": "3tdxjawdfyzg",
        "_cid": ":11"
      },
      {
        "name": "Petěrburg",
        "author": "Jaromír Nohavica",
        "lyrics": "1. [Ami]Když se snáší noc na střechy Petěrburgu, [F]padá [E]na mě [Ami]žal,\nzatoulaný pes nevzal si ani kůrku [F]chleba, kterou [E]jsem mu [Ami]dal.\n\n®: /: [C]Lásku moji [Dmi]kníže I[E]gor si bere,\n[F]nad sklenkou vodky [H7]hraju[Adim] si [E]s revolverem,\n[Ami]havran usedá na střechy Petěrburgu, [F]čert a[E]by to [Ami]spral.\n\n2. Nad obzorem letí ptáci slepí v záři červánků,\n   moje duše, široširá stepi, máš na kahánku.\n\n®: /: Mému žalu na světě není rovno,\n      vy jste tím vinna, Naděždo Ivanovno,\n      vy jste tím vinna, až mě zítra najdou s dírou ve spánku. :/",
        "creatorId": "luteemsu35x",
        "created": 1365458916382,
        "updated": 1365458916382,
        "id": "oxbi35r1qrqn",
        "_cid": ":10"
      },
      {
        "name": "Vlajky vlají",
        "author": "Mig 21",
        "lyrics": "Dobíhám [Dmi]tramvaj \nZ kopce na Petřín \nA ty jedeš [Ami]v ní \nV tramva[B]ji \nKoukneš se [E]ven \n[C]Trolej zajis[Dmi]kří \n\nDobíhám [Dmi]tramvaj \nZ kopce na Petřín \nA ty jedeš [Ami]v ní \nV tramva[B]ji \nTa mění [Es]měr \n[C]Kvér vystře[Dmi]lí \n\n®: /: [Dmi]Na tramvaji vlajky vlají \n[F]Mír volají Mír volají :/ \n\nZaklínám tramvaj \nAť ještě zastaví \nA ty vystoupíš \nNa chodník \nA pro šeřík \nSi chtít budeš jít \n\nZaklínám tramvaj \nAť ještě zastaví \nA ty vystoupíš \nNa chodník \nOzve se křik \nJiskry padají \n\n® \n\n/: [Dmi]Mír vo[C]la[F]jí :/ \n\nZačíná jaro \nNad Prahou nad Plzní \nVálka odezní \nVyšumí \nNastane mír \nOsvobození \n\nChtěl jsem jet s tebou \nNoční tramvají – ale \nPadám do křoví \nNa šeřík \nA v tom ten keř \nTebou zavoní \n\n® \n\n2x /: [Dmi]Mír vo[C]la[F]jí :/",
        "creatorId": "luteemsu35x",
        "created": 1365458794715,
        "updated": 1365458794715,
        "id": "utrl24fpe1es",
        "_cid": ":z"
      },
      {
        "name": "Žába puk",
        "author": "Ivan Mládek",
        "lyrics": "[C]U le[G7]síčka [C]zamrzla říč[G7]ka, \nbu[C]dem hrát hokej.[A7], [A] \n[Dmi]Nabrou[A7]sím si u [Dmi]bruslí šrou[A7]by, \n[D7]do zatáček budu běhat O.K.[Fmi], [G7] \n[C]Nemáme [G7]puk, je [C]nám to fuk, [G7] \n[C]budeme hrát zmzlou žá[C]bou. \nAni [F]hokejky [E7]nemáme, \n[Ami]na [D7]detaily nedbá[G7]me.[C] \n\n[C]Venco [G7]Kábů, při[C]hrej žá[G7]bu, \njá [C]jim jí tam fouk[A7]nu.[A] \nNebo rači sám běž na bránu, \njá se zatím na bublinu kouknu. \nV tom led rupnul, já tam první hupnul, \nVracíme se do kabin kraulem. \nTakže žába puk vyhrála ve vodě se roztála.",
        "creatorId": "luteemsu35x",
        "created": 1365458681070,
        "updated": 1365458681070,
        "id": "y6fdk5aw2c1z",
        "_cid": ":y"
      },
      {
        "name": "Koleda",
        "author": "Traband",
        "lyrics": "[G]Na lavičce v parku, [C]přikrytej [D]novinama \n[G]leží ňákej chlápek, [C]špínu [D]za nehtama \n[G]s prázdnou lahví [C], [D], [G]meruňkovice \n\nVločky snášejí se na jeho mastný vlasy \nna děravý boty od Armády spásy \ntak tu zase máme bílý vánoce \n\n[Ami]Ježíšek zase [G]nepřišel, jen zlatý [Ami]prasata a bílý [G]sloni \n[Ami]Asi se někde [G]zapomněl jako [C]předloni, jako [D7]loni \n\nNa lavičce v parku, skrčený pod kabátem \nMožná se mu zdá o řízku se salátem \no čistým prádle, o teplý posteli \n\nMráz mu jeho tvář zkřivil do grimasy \nNavždy bude spát, na věčný časy \ns přimrzlým úsměvem šťastný a veselý \n\nJežíšek zase nepřišel, jen zlatý prasata a bílý sloni \nAsi se někde zapomněl jako předloni, jako loni \n\nNa lavičce v parku leží pod kabátem \nMožná se mu zdá o řízku se salátem \no čistým prádle, o teplý posteli \n\nMráz mu jeho tvář zkřivil do grimasy \nNavždy bude spát, na věčný časy \ns přimrzlým úsměvem šťastný a veselý",
        "creatorId": "luteemsu35x",
        "created": 1365458267881,
        "updated": 1365458267881,
        "id": "b6413xx33doo",
        "_cid": ":x"
      },
      {
        "name": "Měla jsem já pejska",
        "author": "Traband",
        "lyrics": "Měla jsem já [Ami]pejska velkýho jak [Gmi]tele \nKdyž se mnou šel [F]po ulici, každej se ho [E7]bál \nOn mi každý ráno vylez do postele \nPřitulil se ke mně a hřál mi nohy, hřál\n \n[Ami]Jenomže můj starej, vožrala vožralej \n[G]vylízaná palice \n[F]zase neměl prachy a byl plonkovej \n[E7]propil pejska v putyce \nNadělali řízky z mýho pejska \naj aj aj aj aj \nPaničce se stejská, strašně stejská \naj aj aj aj aj",
        "creatorId": "luteemsu35x",
        "created": 1365456988492,
        "updated": 1365456988492,
        "id": "yf7xrvhikiil",
        "_cid": ":w"
      },
      {
        "name": "Na konci cesty",
        "author": "Traband",
        "lyrics": "[Gmi]Došel jsem na [F]konec cesty [Gmi]s tou, kterou jsem [Fmi]lo[Gmi]val. \n[Gmi]Došel jsem až [F]na kraj světa [Gmi]s tou, kterou jsem [Fmi]lo[Gmi]val. \n[B]Došel jsem až [F]na břeh moře [B]s tou, kterou jsem [Fmi]lo[D7]val. \n[Gmi]Došel jsem na [Gmi]konec cesty [Gmi]s tou, kterou jsem [D7]milo[Gmi]val. \n\nDošel jsem na konec cesty s tou, kterou jsem miloval. \nDošel jsem až na břeh moře s tou, kterou jsem miloval. \nPo obloze lítali ptáci, vlny bily, vítr vál. \nUž nebylo kam dojít dál s tou, kterou jsem miloval.",
        "creatorId": "luteemsu35x",
        "created": 1365456896091,
        "updated": 1365456896091,
        "id": "8z6zt47i1a8s",
        "_cid": ":v"
      },
      {
        "name": "Ponorná řeka",
        "author": "Traband",
        "lyrics": "[Dmi]Madam, jste [Gmi]ponorná řeka \n[Dmi]Hádám, co [Gmi]čeká na člověka \n[B]který se nechá [A7]vašimi vlnami [Dmi]nést \n[Dmi]Acháty a [Gmi]ametysty \n[Dmi]nebo jen [Gmi]shnilé listí? \n[B]Kdo si je jistý, [A7]co může-nemůže [Dmi]snést? \n\n[Dmi]Co zítřek připra[C]ví? \nCo [F]na břeh vypla[A7]ví? \nKdy [Dmi]zmizí a kdy se [B]zase obje[A7]ví? \n\nMadam, jste ponorná řeka \nHádám, co čeká na člověka \nkterý se nechá vašimi vlnami nést \nAcháty a ametysty \nnebo jen shnilé listí? \nKdo si je jistý \nco může-nemůže snést? \n\nAť mě vezme proud \nve vlnách utonout \nchci plout ve vašich vlnách, utonout \n\nMadam, jste ponorná řeka \nHádám, co čeká na člověka \nkterý se nechá vašimi vlnami nést \nAcháty a ametysty \nnebo jen shnilé listí? \nKdo si je jistý \nco může-nemůže snést?",
        "creatorId": "luteemsu35x",
        "created": 1365456728283,
        "updated": 1365456728283,
        "id": "9azv9wd7m9i",
        "_cid": ":u"
      },
      {
        "name": "Viděl jsem člověka",
        "author": "Traband",
        "lyrics": "[Dmi]Viděl jsem člověka [F]postávat na mostě \n[Gmi]Nikdo ho neslyšel [A7]jak říká Pomozte! \n[Dmi]Na konečný za městem [F]když hvězdy zapadly \n[Gmi]Ten chlápek nešťastná [A7]přeskočil zábradlí \n[Dmi]Voda ho vzala[Gmi],[A7] \n\nViděl jsem rybáře, jak svoji loď otočil \na k němu vesluje, vesluje ze všech sil \nAle loďka je pomalá a proud ji strhává \npod hladinou mizí topící se postava \nVoda ho vzala \n\n[F]Bylo mi do breku, [C]dostal jsem z toho strach \n[Eb]Ale rybář z lodi vyskočí a [A7]běží po vlnách \n[F]Vytáhne utopence [C]bledýho jak půlměsíc \n[Eb]Nikdy není pozdě, hochu, [A7]dýchej, dýchej z plných [Dmi]plic! \n\nLežel jsem na břehu a byl jsem opilý \nA hvězdy nade mnou tak strašně svítily \nNěkdo mě volá jménem a říká: Probuď se! \nNa hladině pluje rybář na loďce \n\nOtevírám svoje oči, řasy vodou slepené \nještě se mi nechce umřít, Pane Bože ještě ne! \nOtevírám svoje oči, řasy vodou slepené \nještě se mi nechce umřít, Pane Bože ještě ne!",
        "creatorId": "luteemsu35x",
        "created": 1365456342553,
        "updated": 1365456342553,
        "id": "1f5unbnrhnq9",
        "_cid": ":s"
      },
      {
        "name": "Těšínská",
        "author": "Jarek Nohavica",
        "lyrics": "[Ami]Kdybych se narodil [Dmi]před sto léty,\n[F],[E7]v tomhle [Ami]městě [Dmi], [F], [E7], [Ami]\n[Ami]u Larichů na zahradě [Dmi]trhal bych květy\n[F], [E7]své ne[Ami]věstě. [Dmi], [F], [E7], [Ami]\n[C]Moje nevěsta by [Dmi]byla dcera ševcova\n[F]z domu Kamińskich [C]odněkud ze Lvova\nkochał bym ją i [Dmi]pieśćił [F]chy[E7]ba lat [Ami]dwieśćie. \nBydleli bychom na Sachsenbergu v domě u žida Kohna.\nNejhezčí ze všech těšínských šperků byla by ona.\nMluvila by polsky a trochu česky,\npár slov německy a smála by se hezky.\nJednou za sto let zázrak se koná, zázrak se koná. \nKdybych se narodil před sto léty byl bych vazačem knih.\nU Prohazků dělal bych od pěti do pěti a sedm zlatek za to bral bych.\nMěl bych krásnou ženu a tři děti,\nzdraví bych měl a bylo by mi kolem třiceti,\ncelý dlouhý život před sebou celé krásné dvacáté století. \nKdybych se narodil před sto léty v jinačí době\nu Larichů na zahradě trhal bych květy má lásko tobě.\nTramvaj by jezdila přes řeku nahoru,\nslunce by zvedalo hraniční závoru\na z oken voněl by sváteční oběd. \nVečer by zněla od Mojzese melodie dávnověká,\nbylo by léto tisíc devět set deset za domem by tekla řeka.\nVidím to jako dnes šťastného sebe,\nženu a děti a těšínské nebe.\nJěště,že člověk nikdy neví co ho čeká. \nna na na na...",
        "creatorId": "luteemsu35x",
        "created": 1365352341849,
        "updated": 1365352341849,
        "id": "9jz3brj1yvhk",
        "_cid": ":r"
      },
      {
        "name": "Something Stupid",
        "author": "Frank Sinatra",
        "lyrics": "I [G]know I stand in line, until you think you have the time \nto spend an [Ami]evening with [D]me-.[Ami], -, [D7] \nAnd i[Ami]f we go someplace to dance, I k[D7]now that there's a chance \nyou won't be l[G]eaving with me. \n\nAnd a[G7]fterwards we drop into a quiet little place and \nhave a d[C]rink or two. \nAnd [Ami]then I go and sp[D]oil it all, by s[Ami]aying something s[D7]tupid \nlike: \"I l[G]ove you\". \n\nI can [G7]see it in your eyes, that you despise the same old lies \nyou heard the n[C]ight before. \nAnd thoughA it's just a line to you, for A7me it's true, \nit never seemed so r[D], -, [D7]ight before. \n\nI p[G]ractice every day to find some clever lines to say, \nto make the m[Ami]eaning come t[D]rue.-, [Ami], -, [D7] \nBut [Ami]then I think I'll wait until the \n[D7]evening gets late, and I'm a[G]lone with you. \n\nThe [G7]time is right, your perfume fills my head, the stars get red, \nand, oh, the n[C], -, [Ami], -, Aight's so blue. \n\n[A]And then I go and s[D]poil it all, by s[Ami]aying something st[D7]upid \n\nlike: \"I lo[G]ve you\", G, -, a, -D, -, a, -, [D7], /, a, -, [D7], -, G",
        "creatorId": "luteemsu35x",
        "created": 1365352016482,
        "updated": 1365352099427,
        "id": "8gxzmbk24xsf",
        "_cid": ":q"
      },
      {
        "name": "Hurt",
        "author": "Johnny Cash",
        "lyrics": "I [C]hurt m[D]yself t[Ami]oday to [C]see i[D]f I still[Ami] feel, \nI f[C]ocus [D]on the [Ami]pain, the [C]only [D]thing that's [Ami]real. \nThe [C]needle [D]tears a [Ami]hole, the [C]old fa[D]miliar[Ami] sting, \ntry to [C]kill it[D] all a[Ami]way, but I [C]remember e[D]verything[G]. \n\n[Ami]What have I beco[F]me, [C]my sweetest f[G]riend ? \n[Ami]Everyone I [F]know goes [C]away in the [G]end. \nAnd[Ami] you could have it a[F]ll, [G]my empire of dirt, \n[Ami]I will let you d[F]own, [G]I will make you hurt. \n\nI [C]wear this [D]crown of [Ami]thorns [C]upon my li[D]ar's chai[Ami]r, \nf[C]ull of bro[D]ken though[Ami]ts I can[C]not repai[D], [Ami]r. \nBeneath[C] the stains of[D] time the [Ami]feeling disap[C], [D], [Ami]pears, \ny[C]ou are someo[D]ne else, I a[Ami]m sti[C]ll right [D], [G]here. \n\nWha[Ami]t have I become, [F] my sw-ee[C], [G]test friend ? \n[Ami]Everyone I know go[F]es away in the end[C], [G]. \nAnd you [Ami]could have it all, my emp[F]ire o[G]f dirt, \n[Ami] I will let you dow[F]n, I wi[G]ll make you hurt. \nI[Ami]f I could start again,[F] a million [G]miles away, \n[Ami] I would keep myself, I w[F]ould[G], [Ami] find a way.",
        "creatorId": "luteemsu35x",
        "created": 1365351776858,
        "updated": 1365351776858,
        "id": "i3o1gdc9gyzz",
        "_cid": ":p"
      },
      {
        "name": "Nosorožec",
        "author": "Karel Plíhal",
        "lyrics": "P[Ami]řivedl jsem domů Božce [Dmi]nádhernýho [Ami]nosorožce, \n[Dmi]originál tl[Ami]ustokožce, k[D#dim]oupil jsem ho v h[H7]ospodě. \nZ[Ami]a dva rumy a dvě vodky př[Dmi]ipadal mi v[Ami]elmi krotký, \np[Dmi]ošlapal mi p[Ami]olobotky, [H7]ale jinak v p[Ami]ohodě. \nVzn[Dmi]ikly menší p[Ami]otíže př[H7]i nástupu d[Ami]o zdviže, \npř[Dmi]i výstupu z[Ami]e zdviže [D#dim]už nám to šlo l[H7]ehce. \nVzn[Ami]ikly větší potíže, kd[Dmi]yž Božena v n[Ami]egližé, \nkd[Dmi]yž Božena v n[Ami]egližé řv[D#dim(E7)]ala, že ho n[E7(Ami)]echce. \n\nMarně jsem se snažil Božce vnutit toho tlustokožce, \noriginál nosorožce, co nevidíš v obchodech. \nŘvala na mě, že jsem bohém, pak mi řekla: Padej, sbohem, \nzabouchla nám před nosorohem, tak tu sedím na schodech. \nCo nevidím - souseda, jak táhne domů medvěda, \noriginál medvěda, tuším značky grizzly. \nUž ho ženě vnucuje a už ho taky pucuje \na zamčela a trucuje, tak si to taky slízli. \n\n[Ami]Tak tu sedím se sousedem, s [Dmi]nosorožcem[Ami] a s medvědem, \nn[Dmi]adáváme j[Ami]ako jeden n[H7]a ty naše sl[Ami]epice.",
        "creatorId": "luteemsu35x",
        "created": 1365351468153,
        "updated": 1365351468153,
        "id": "tqm3dqgabduw",
        "_cid": ":o"
      },
      {
        "name": "Ráda se miluje",
        "author": "Karel Plíhal",
        "lyrics": "®: [Hmi]Ráda se miluje, [A]ráda [D]jí, \n[G]ráda si [F#mi]jenom tak [Hmi]zpívá, \nvrabci se na plotě [A]hádají[D], \nko[G]lik že čas[F#mi]u jí [Hmi]zbývá. \n\n[G]Než vítr dostrká k [D]útesu tu [G]její legrační bá[D]rku[F#] \na [Hmi]Pámbu si ve svým [A]note[D]su [G]udělá [F#mi]jen další [Hmi]čárku. \n®: \n\nPsáno je v nebeské režii, a to hned na první stránce, \nže naše duše nás přežijí v jinačí tělesný schránce. \n®: \n\nÚplně na konci paseky, tam, kde se ozvěna tříští, \nsedí šnek ve snacku pro šneky - snad její podoba příští. \n®:",
        "creatorId": "luteemsu35x",
        "created": 1365351148090,
        "updated": 1365351148090,
        "id": "jhny5hrnttv",
        "_cid": ":n"
      },
      {
        "name": "Husličky",
        "author": "Vlasta Redl",
        "lyrics": "[A]Čí že ste, husličky, [D]či[A]e, \n[Hmi]kdo vás tu [F#mi]zanech[E]al \n[A]Čí že ste, husličky, [D]či[A]e, \n[Hmi]kdo vás tu [F#mi]zanech[E]al \n[Hmi7]na trávě pová[A]lané[D], \n[Hmi]na trávě [E]pová[A]lané[D] \n[Hmi]u paty [F#mi]oře[E]cha?[Hmi], [F#mi], [E] \n\nA kdože tu trávu tak zválal, aj modré fialy, \nA kdože tu trávu tak zválal, aj modré fialy, \nže ste, husličky, samé \nže ste, husličky, samé na světě zostaly? \n\nA který tu muzikant usnul a co sa mu přišlo zdát, \nA který tu muzikant usnul a co sa mu přišlo zdát, \nco sa mu enem zdálo, bože(-), \nco sa mu enem zdálo, bože(-), že už vjec nechtěl hrát? \n\nZahrajte, husličky, samy, zahrajte zvesela, \nZahrajte, husličky, samy, zahrajte zvesela, \naž sa tá bude trápit, \naž sa tá bude trápit, která ho nechtěla.",
        "creatorId": "luteemsu35x",
        "created": 1365351026246,
        "updated": 1365351026246,
        "id": "ev08gny4cxrr",
        "_cid": ":m"
      },
      {
        "name": "Holúbek a holubička",
        "author": "Vlasta Redl",
        "lyrics": "[Eb]Viděla sem [Bb]svého [Eb]holúbka si[Bb]vého, \n[C]letěl k mořu[C4sus]. \n[Cmi7]Počkaj mňa, můj [Bb]milý[Eb], [Cmi]můj ho[F7]lúbku [Bb]sivý[Eb], \n[F7]půjdem spolu[Bb]. \n\nHolubičko sivá, si-li eště živá, \njak sa míváš? \nSi-li v řečách stálá, lebo sas vydala, \nlebo čekáš? \n\nJá sem sa nevdala, na tebja čekala, \nsivý sokol, \npro tvé peří hladké, vrkotání sladké \nnemám pokoj. \n\nEsli ťa nenajdu, já ťa hledat budu \nu chodníčka. \nKady ludé půjdú, já sa pýtať budu \nna Janíčka.",
        "creatorId": "luteemsu35x",
        "created": 1365349562104,
        "updated": 1365349562104,
        "id": "rice8k4v2rjk",
        "_cid": ":l"
      },
      {
        "name": "Topol",
        "author": "Vlasta Redl",
        "lyrics": "[D]Stojí [D]topol [D]v širém [G]po[D]lu [D] \n[D]Připo[A]mí[D]ná [D], [D], [D] \n[D]Že jsme [D]my dva [D]byli [G]spo[D]lu [D] \n[D]Moja [D]mi[D]lá [D] \n[Hmi]Že tam [Hmi]kdysi [Hmi]stromy [Hmi]stály \n[Emi]Než jich [Emi]ludé [Emi]vyrú[Emi]bali \n[D]Aby [D]sa jim [D]pše[G]nič[D]ka [D] \n[D]Zro[A7]di[D]la [D] \n\nŠumí pšenka v širém polu \nJak dlúhý den \nŽe jsme my dva byli spolu \nA nebudem \nA já tu pšenku půjdem kosit \nA za tebe boha prosit \nAby si sa třeba s iným \nDobře měla",
        "creatorId": "luteemsu35x",
        "created": 1365349368645,
        "updated": 1365349368645,
        "id": "xfs6oibg2ca1",
        "_cid": ":k"
      },
      {
        "name": "Vracaja sa dom",
        "author": "Vlasta Redl",
        "lyrics": "V[A]racaja sa[H] dom \n[E]od Betléma do Vsetí[A]na \n[H]nésl jsem se [E]jak ta laňka \n[A]nésl jsem se jak ta l[F#]aňka \n[D]potr[E]efen[A]á \n[D]A že bylo v[E] tom Betlémě živo[A] velice[E] \n[A]voněl jsem jak mariján[D]ek od[A] sl[E]ivovic[A]e \n\nVracaja sa dom \nznavený a šťastný velmi \ntož sem sebú od radosti \nod velkej Božskej milosti \npraštil k zemi \n\nLežím přemítám \nnajednú je u mňa žena \na nevěří že sa vracám \na nevěří že sa vracám \nod Betléma \n\nA že bylo v tom Betlémě živo velice \na že nás tam Josef nutil do slivovice \n\nJa ženy ženy \nnic na Betlém nevěřijú \na když dojdú na pútnícka \na když dojdú na pútníčka \nhned ho zbijú \n\nTož byl u nás na Štědrý den Betlém hotový \neště dneskaj nedoslýchám na obě nohy",
        "creatorId": "luteemsu35x",
        "created": 1365349215494,
        "updated": 1365349215494,
        "id": "dlf4hedt1nwn",
        "_cid": ":j"
      },
      {
        "name": "Sedávám na domovních schodech",
        "author": "Karel Plíhal",
        "lyrics": "[Bmaj]Sedává[Hdim]m [Cmi7]na domovních[F] schodech \n[Bmaj]zpívává[Hdim]m [Cmi7]v krásných cizích[F] slovech \n[B]maj kterým [A6]jenom sa[Gis6]ma rozu[D9]mím \n[C9] z komínu [F6]stoupá dý[Bmaj, F]m \n\nStíny jdou stíny nebem táhnou \nstíny jdou do mých strun mi sáhnou \nke všem písním zapomenutým \nz komínu stoupá dým \n\n[D9]Všechna hnízda šla už spát \nje nutno myslet na návrat \n[Gmi7]večer[Dis9]ní [D9]zvon[Gmiadd9, Gmi]y znějí \n[C9]Zvolna nota za notou \nkráčí svojí samotou \n[F9]jako černou závějí \n\nSedávám svou kytaru v klíně \nzpívávám pomalu a líně \nneznámá blues hlasem zastřeným \nz komínu stoupá dým \n\nsólo \n\nVšechna hnízda šla už spát \nje nutno myslet na návrat \nvečerní zvony znějí \nZvolna nota za notou \nkráčí svojí samotou \njako černou závějí \n\nSedávám svou kytaru v klíně \nzpívávám pomalu a líně \nneznámá blues hlasem zastřeným \n[Cmi7]z komínu [F]stoupá dým[B6, A6, Gis6, G6] \n[Cmi7]z komínu [F]stoupá dým[F9, E9, Es9, D9] \n[Cmi7]z komínu [F, B9/6]stoupá dým",
        "creatorId": "luteemsu35x",
        "created": 1365257604850,
        "updated": 1365257604850,
        "id": "qk0cf0og93kd",
        "_cid": ":i"
      },
      {
        "name": "Poslední večeře",
        "author": "Jesus Christus Superstar",
        "lyrics": "[G]Trápení a [D]spousty denních [Emi]strastí[G7] \n[C]já i ty ve [G]víně utá[Ami]píš[D]. \n[G]V pozdních hodi[H7]nách hlas ti [Emi]náhle [G]umlká \na [C]štěstí zdá se [D]na dosah i [G]blíž. \n\nApoštolské písně krajem zazní. \nSepíšeme pěknou řádku knih. \nV dalších staletích budou v bázni \nlistovat a číst v našich evangeliích.",
        "creatorId": "luteemsu35x",
        "created": 1365208965608,
        "updated": 1365208965608,
        "id": "h83nwhrmw0kq",
        "_cid": ":h"
      },
      {
        "name": "Prosím tě, holka",
        "author": "Karel Plíhal",
        "lyrics": "Pro[G]sím tě, holka, [C7]nemrač se tolik, \n[G]nebuď už se mnou [E7]na kordy, \n[C]jsem jenom blá[Edim]zen [G]a alkoho[E7]lik, \n[A7]co umí čtyři [D#]akordy[D]. \n\nAkordy čtyři a písní stovku, \nnavíc pár príma historek, \nnalej si vodku, mně becherovku, \nA7půjdem si spolu sednout na D#dvoDreGk. \n\n®: Mě[C7]síc, ten osamělý cestující časem, \nde[G]centně poodejde s vážnou tváří mima, \npo[C7]tom tě rozechvěju neumělým hlasem, \na [G]když ne já, tak [Edim]určitě tě ro[Ami]zechvěje zi[D7]ma. \n\nZ oblohy cosi bílýho padá \na na tvým nose taje to, \nže já jsem starej a ty jsi mladá - \naspoň mám něco najeto. ®: \n\nTak už se nemrač, dívej, čas letí, \nčeká nás príma apartmá, \numělci všichni prý jsou jako děti, \na já mám vše, co správný capart má ... mít.",
        "creatorId": "luteemsu35x",
        "created": 1365205851682,
        "updated": 1365205851682,
        "id": "j6ny9u4fxtx8",
        "_cid": ":g"
      },
      {
        "name": "Touha poznat celej svět",
        "author": "Karel Plíhal",
        "lyrics": "Ut[E]ekl jsem od manželky k mamince, \nvodila si do kvartýru cizince, \nz[A7]a svůj život byla nejdál na Slapech, \nt[E]ak se snaží vynahradit na chlapech \nsv[H7]oji dávnou touhu p[A7]oznat celej sv[E]ět. \n\nNačapal jsem u ní jednou Japonce, \ndaroval jí korále až z Jablonce, \njednou zase s jedním chlápkem z Taiwanu \nznesv„tili okrem spálne aj vanu, \nto ta její touha poznat celej svět. \n\nPozvala si domů čtyři Araby \nza poslední LP desku od ABBY, \nněkdy byla zatížena na Indy, \nPortugalce nechala si na jindy, \nto ta její touha poznat celej svět. \n\nKdyž jsem našel u ní chlapa z Bejrútu, \nnemoh' už jsem trpět ani minutu, \nhlavu jsem měl těžkou, jako z olova, \nopustil jsem navždy teplo domova \npro tu její touhu poznat celej svět. \n\nJeště jsem se vracel zpátky pro šálu, \nuž tam svlíkal kabát chlápek z Nepálu, \nutekl jsem od manželky k mamince, \nnezveme si domů žádné cizince, \nkdyž - tak jenom strejdu z Český Třebový.",
        "creatorId": "luteemsu35x",
        "created": 1365205380721,
        "updated": 1365205380721,
        "id": "9ehp1q631m6x",
        "_cid": ":f"
      },
      {
        "name": "Za tři čtvrtě století",
        "author": "Karel Plíhal",
        "lyrics": "Už [C]za tři čtvrtě [C9]století, lásko, [Ami7]budem slavit [G]stovku, \n[F]otevřeme [D7]víno, sedne[C]me si na po[G]hovku, \n[C]na stařičkým [C9]gramofonu [Ami7]pustíme si [G]Floydy, \n[F]zavoláme [D7]kámošům na vš[C]echny aste[G]roidy. \n\nUž za tři čtvrtě století nám bude, lásko, sto let, \nnejspíš budem utahaní jako pérka rolet, \nna stařičkým gramofonu pustíme si Queeny, \nuděláš mi svíčkovou, už teď mi tečou sliny. \n\n®:Jenom [Ami]doufám, že se [Ami/G]do té doby [D9/F#]neumlátíš [G]smíchem, \njenom [Ami]doufám, že se [Ami/G]neubrečíš [D9/F#]nad Vávrou či [G]Zichem, \ntaky [Ami]pořádně se [Ami/G]rozhlížej, než [D9/F#]vejdeš na vo[G]zovku, \n[F]rád bych s tebou, [D7]lásko moje, [C]oslavil tu [G]stov[C]ku.[C9]\n\nTo víno bude nejspíš ročník dva tisíce dvacet, \ns každým hltem budeš aspoň deset roků ztrácet, \na když ti bude pětadvacet, bude sklenka prázdná \na ty budeš jako dneska líznutá a krásná, \n\n[C]la la [C9]la .[Ami7]..",
        "creatorId": "luteemsu35x",
        "created": 1365205170109,
        "updated": 1365205170109,
        "id": "udon8fas5d8c",
        "_cid": ":e"
      },
      {
        "name": "Levitační",
        "author": "Karel Plíhal",
        "lyrics": "http://www.supermusic.sk/skupina.php?idpiesne=5708&sid=",
        "creatorId": "luteemsu35x",
        "created": 1365204578166,
        "updated": 1365204578166,
        "id": "y3krnuejbec",
        "_cid": ":c"
      },
      {
        "name": "Kde jsou",
        "author": "Karel Plíhal",
        "lyrics": "®: [G]Kde jsou, [G]kdepak [C]jsou \nnaše [G]velkole[Emi]pý [D]plány[G], [D] \n[G]kde jsou, [G]kdepak [C]jsou - \nna hřbi[G]tově [Emi]zako[D]pány.[G], [D] \n\n[F]Sedíš tu [C]tiše jako pě[D]na \n[F]žijem svůj [C]život, no [C]jak se říká - [D]do ztracena, \n[G]kde jsou, [G]kdepak [C]jsou \nnaše [G]velkole[Emi]pý [D]plány[G], [D] \n\n®: Kde jsou, kdepak jsou naše velkolepý plány, \nkde jsou, kdepak jsou písně nikdy už nedopsány. \n\nŽivot byl prima a neměl chybu, \nteď je mi zima a nemám ani na Malibu, \nkde jsou, kdepak jsou naše velkolepý plány.",
        "creatorId": "luteemsu35x",
        "created": 1365204462904,
        "updated": 1365204462904,
        "id": "8jawxcpsbyr7",
        "_cid": ":b"
      },
      {
        "name": "Dopis",
        "author": "Karel Plíhal",
        "lyrics": "[D]Tak ti teda píšu v opilecké pý[A]še \n[Emi]dopis, co ti ji[G]nej fra[A]jer nenapí[D]še, \ndopis, co ti jinej frajer nesesmo[A]lí, \n[Emi]žádný hloupý frá[G]ze, [A]jak mě srdce bo[D]lí. \n\n®: [D7]Nejsem žádnej zla[G]tokop a ne[E]ní mi to lí[A]to, \nže [D7]jsem kdesi pro[G]pil re[E]jžák i to sí[A]to. \n\nZato když jsem včera večer seděl s kamarády v šenku, \nmá stará Múza dala mi svou novou navštívenku, \nuž od rána mě svádí, hladí, líbá atakdále, \njenže bez tebe se cítím jako přikovanej k skále. \n\n®: Vzpomínky mě klovou do mých ztvrdlých jater, \nslzím z dýmu, jenž sem vane z vater kolem Tater. \n\nPrej z vesmíru se blíží naše příští zkáza \na Země - to je stará a velmi křehká váza, \npopraskaná váza jako tvoje láska ke mně, \nco zbylo z tvý lásky, co zbude z tý Země? \n\n®: Nebude to bolet, neboj, potrvá to chvilku, \npřestaneme řešit naši malou násobilku. \n\nPřestanem se trápit, kdo ji za nás dopočítá, \npřestanem si nalhávat, že na východě svítá, \nobyčejní lidé vedou obyčejné války, \nchci naposled tě uvidět, a třebas jenom z dálky. \n\n*: Tře[D]bas jenom z dálky, když už to nejde zblí[A]zka, \ndo[Emi]kud konec to[G]ho všeho [A]Pámbu neodpí[D]ská, \ndo[Emi]kud konec to[G]ho všeho Pá[A]mbu neod-, \n[D]tak ti teda píšu v opilecké pý[A]še \ndo[Emi]pis, co ti [G]jinej fra[A]jer nenapí[D]še, \ndopis, co ti jinej frajer nesesmoAlí, \n[Emi]žádný hloupý frá[G]ze, jak [A]mě srdce bo[D]lí, \n[Emi]žádný hloupý frá[G]ze, jak [A]loučení bo[D]lí, \n[Emi]žádný hloupý frá[G]ze, jak [A]beznaděj bo[D]lí, \n[Emi]žádný hloupý frá[G]ze, jak [A]loučení bo[D]lí, \n[Emi]žádný hloupý frá[G]ze, jak [A]mě srdce bo[D]lí, \n[Emi]žádný hloupý frá[G]ze, [A]jak mě hlava bo[D]lí ...",
        "creatorId": "luteemsu35x",
        "created": 1365203755532,
        "updated": 1365203755532,
        "id": "b9owm4qrq1v0",
        "_cid": ":a"
      },
      {
        "name": "Akordy",
        "author": "Karel Plíhal",
        "lyrics": "[E]Nejkrásnější akord bude [Amaj7]A-maj, \n[E]prstíky se při něm nepo[C]lámaj'. \n[A]Pomohl mi k [H7]pěkné holce s [G#mi]absolutním [C#mi]sluchem, \n[A]každý večer [C]naplníme [E]balón horkým vz[Amaj7]duchem. [Ami], [A], [Amaj7] \n\nV stratosféře hrajeme si A-maj, \ni když se nám naši známí chlámaj'. \nPotom, když jsme samým štěstím opilí až namol, \nstačí místo A-maj jenom zahrát třeba A-moll. \n\nA-moll všechny city rázem schladí, \ndopadneme na zem na pozadí. \nSedneme si do trávy a budem koukat vzhůru, \ndokud nás čas nenaladí aspoň do A-duru. \n\nR: [A]Od A-dur je jenom kousek k [Amaj7]A-maj, \n[F#mi]proto všem těm, [F#mi/F]co se v lásce sk[F#mi/E]lamaj':[F#mi/D#] \n[A]vyždímejte [H7]kapesníky a [G#mi]nebuďte [C#mi]smutní, \n[A]každá holka [C]pro někoho [E]má sluch abso[Amaj7]lutní. \n\nV každém akord zní, aniž to tuší, \nzkusme tedy nebýt k sobě hluší. \nCelej svět je jeden velkej koncert lidských duší, \njenže jako A-maj nic tak srdce nerozbuší. \n\n*: [E]Pro ty, co to A-maj v lásce [Amaj7]nemaj', \n[E]moh' bych zkusit zahrát třeba [Cmaj7]C-maj ...",
        "creatorId": "luteemsu35x",
        "created": 1365203216769,
        "updated": 1365203216769,
        "id": "w2jfhsowsyw6",
        "_cid": ":9"
      },
      {
        "name": "Až to se mnu sekne",
        "author": "Jaromír Nohavica",
        "lyrics": "[Dmi]Až obuju si [A7]rano černe [Dmi]papirove boty, \naž i [F]moja stara [C7]pochopi, že [F]nejdu do roboty, \naž [Gmi]vyjde dluhy pruvod smutečnich hostu \nna [Dmi]Slezsku Ostravu od Sykorova mostu, \n[A7]až to se mnu sekne, [Dmi]to bude[D7] pěkne, \n[Gmi]pěkne, fajne [Dmi]a pěkne, [A7]až to se mnu de[Dmi]finitivně sekne. \n2. Aby všeckym bylo jasne, že mě lidi měli radi, \nať je gulaš silny, baby smutne, muzika ať ladi, \nbo jak sem nesnašel šledryjan ve vyrobě, \nnebudu ho trpěť, ani co sem v hrobě, \nto bude pěkne, \npěkne, fajne a pěkne, až to se mnu definitivně sekne. \n3. S někerym to seka, že až neviš, co se robi, \njestli pomohla by deka nebo teplo mlade roby, \nkdybych si moh' vybrat, chtěl bych hned a honem, \nať to se mnu šlahne tajak se starym Magdonem, \nto bude pěkne, \npěkne, fajne a pěkne, až to se mnu definitivně sekne. \n4. Jedine, co nevim: jestli Startku nebo Spartu, \nbo bych tam nahoře v nebi nerad trhal partu, \nna každy pad s sebu beru bandasku s rumem, \nbo rum nemuže uškodit, když pije se s rozumem, \nto bude pěkne, \npěkne, fajne a pěkne, až to se mnu definitivně sekne. \n5. Já vím, že, Bože, nejsi, ale kdybys třeba byl, tak \nhoď mě na cimru, kde leži stary Lojza Miltag, \ns Lojzu chodili sme do Orlove na zakladni školu, \nfarali sme dolu, tak už doklepem to spolu, \naž to se mnu sekne, \npěkne, to bude pěkne, až to se mnu definitivně sekne. \n6. Až obuju si rano černe papirove boty, \naž i moja stara pochopi, že nejdu do roboty, \nkdybych, co chtěl, dělal, všechno malo platne, \nmohlo to byt horši, nebylo to špatne, \naž to se mnu sekne, \n[B]kdybych, co chtěl, dělal, všechno malo platne, \n[Dmi]mohlo to byt horši, neby[A7]lo to špatne, \naž to se mnu [C7]... na [Dmi]na [A7]na ...[Dmi], [C7], [Dmi], [A7], [Dmi]",
        "created": 1364679953904,
        "updated": 1365202010286,
        "creatorId": "luteemsu35x",
        "id": "y3s93cgbd9fk",
        "_cid": ":4"
      },
      {
        "name": "Sára",
        "author": "Traband",
        "lyrics": "R: [Emi]Sáro,[Hmi] Sáro, [C]v noci se mi [G]zdálo, \nže [C]tři andělé [G]Boží k nám [C]přišli na o[D]běd. \n[Emi]Sáro, [Hmi]Sáro, [C]jak moc a nebo [G]málo \nmi [C]chybí abych [G]tvojí duši [C]mohl rozum[D]ět. \n\n1. Sbor kajícných mnichů jde krajinou v tichu \na pro všechnu lidskou pýchu má jen přezíravý smích \nZ prohraných válek se vojska domů vrací \nač zbraně stále burácí a bitva zuří v nich. \nR. \n2. Vévoda v zámku čeká na balkóně \naž přivedou mu koně, pak mává na pozdrav \nSrdcová dáma má v každé ruce růže, \ntak snadno pohřbít může sto urozených hlav. \nR. \n3. Královnin šašek s pusou od povidel \nsbírá zbytky jídel a myslí na útěk \nA v podzemí skrytí slepí alchymisté \nuž objevili jistě proti povinnosti lék \n\nR. Sáro, Sáro, v noci se mi zdálo \nže tři andělé Boží k nám přišli na oběd \nSáro, Sáro, jak moc a nebo málo \nti chybí abys mojí duši mohla rozumět \n\n4. Páv pod tvým oknem zpívá sotva procit \no tajemstvích noci ve tvých zahradách \nA já, potulný kejklíř, co svázali mu ruce, \nteď hraju o tvé srdce a chci mít tě nadosah! \n\nRef: Sáro, Sáro, pomalu a líně \ns hlavou na tvém klíně chci se probouzet \nSáro, Sáro, Sáro, Sáro rosa padá ráno \na v poledne už možná bude jiný svět \n\nSáro, Sáro, vstávej milá Sáro \nandělé k nám přišli [D]na [G]oběd",
        "created": 1364614395104,
        "updated": 1365201848286,
        "creatorId": "luteemsu35x",
        "id": "mqqt63o56cis",
        "_cid": ":3"
      },
      {
        "name": "Zatanči",
        "author": "Jarek Nohavica",
        "lyrics": "[Emi]Zatan[G]či, má milá, [D]zatanči p[Emi]ro mé oči, \nzatan[G]či a vetkni [D]nůž do mých [Emi]zad, \nať tvůj [G]šat, má milá, [D]ať tvůj šat [Emi]na zemi skončí, \nať tvůj [G]šat, má milá, [D]rázem je s[Emi]ňat. \n\n®: [Emi]Zatan[G]či, jako se [D]okolo [Emi]ohně tančí, \nzatan[G]či jako [D]na vodě [Emi]loď, \nzatan[G]či jako to [D]slunce mezi [Emi]pomeranči, \nzatan[G]či, a [D]pak ke mně [Emi]pojď. \n\nPolož dlaň, má milá, polož dlaň na má prsa, \npolož dlaň nestoudně na moji hruď, \nobejmi, má milá, obejmi moje bedra, \nobejmi je pevně a mojí buď. \n\nR: \n\nNový den než začne, má milá, nežli začne, \nnový den než začne, nasyť můj hlad, \nzatanči, má milá, pro moje oči lačné, \nzatanči a já budu ti hrát. \n\nR: \nR:",
        "created": 1364615587374,
        "updated": 1365199664089,
        "creatorId": "luteemsu35x",
        "id": "3e3h5b5fby2j",
        "_cid": ":2"
      },
      {
        "name": "Dokud se zpívá ještě se neumřelo",
        "author": "Jarek Nohavica",
        "lyrics": "[C]Z [Emi]Těšína vyjíždí [Dmi7]vlaky co [F]čtvrthodi[Cnu],[Emi] [Dmi7] [G]\n[C]včera jsem [Emi]nespal a [Dmi7]ani dnes [F]nespočinu,[C] [Emi7] [Dmi7] [G]\n[F]svatý [G]Medard, [C]můj patron, ťuká si na [Am]če[G]lo,\nale [F]dokud se [G]zpívá, [F]ještě se [G]neumřelo. [C] [Emi] [Dmi7] [G]\n\nVe stánku koupím si housku a slané tyčky,\nsrdce mám pro lásku a hlavu pro písničky,\nze školy dobře vím, co by se dělat mělo,\nale dokud se zpívá, ještě se neumřelo, hóhó.\n\nDo alba jízdenek lepím si další jednu,\nvyjel jsem před chvílí, konec je v nedohlednu,\nza oknem míhá se život jak leporelo,\nale dokud se zpívá, ještě se neumřelo, hóhó.\n\nStokrát jsem prohloupil a stokrát platil draze,\nhoupe to, houpe to na housenkové dráze,\ni kdyby supi se slítali na mé tělo,\ntak dokud se zpívá, ještě se neumřelo, hóhó.\n\nZ Těšína vyjíždí vlaky až na kraj světa,\nzvedl jsem telefon a ptám se: \"Lidi, jste tam?\"\n A z veliké dálky do uší mi zaznělo,\n/: že dokud se zpívá, ještě se neumřelo. :/",
        "created": 1365199263464,
        "updated": 1365199267193,
        "creatorId": "luteemsu35x",
        "id": "7q40mr29ml7n",
        "_cid": ":1"
      },
      {
        "name": "Pohádka",
        "author": "Karel Plíhal",
        "lyrics": "|-----------0--|--0~h2---------|----0----------|--------------|\n|----0--0h1----|3------0--0h1h3|1----------0~h1|0--0h1h3------|\n|0-------------|---------------|--------2------|--------------|\n|----0------0--|----0-----0----|----0-------0--|---0----0-----|\n|--------------|---------------|---------------|-----------4--|\n|3------3------|3------3-------|3-------3------|3-------3--2--|\n                                                                 \n|----------0--|--0~h2----------|---0----------|--------------|...\n|---0--0h1----|3-------0--0h1h3|1---------0~h1|0----2------0~|...\n|-------------|----------------|-------2------|--------------|...\n|2--2------2--|----2------2----|---2-------2--|---2------0---|...\n|-------------|----------------|--------------|--------------|...\n|0-----0------|0-------0-------|0------0------|3------2------|3..\nhttp://vojtahanak.cz/?q=content/poh%C3%A1dka-k-pl%C3%ADhal-m-oldfield\nG C G Ami G D G C G Ami G Emi \n\n     Takhle nějak to bylo: \n     jedlo se, zpívalo, pilo, \n     princezna zářila štěstím \n     v hotelu nad náměstím, \n     drak hlídal u dveří sálu, \n     na krku pletenou šálu, \n     Dědové Vševědi okolo Popelky \n     žvatlavě slibují šaty a kabelky, \n     každý si odnáší kousíček úsměvu, \n     dešťový mraky se chystaly ke zpěvu, \n     hosté se sjíždějí k veliké veselce, \n     paprsky luceren metají kozelce \n     a stíny ořechů orvaných dohola \n     pletou se latícím kočárům pod kola, \n     Šmudla si přivezl v odřeným wartburgu \n     kámošku z dětství, prej nějakou Sněhurku, \n     vrátný se zohýbá pro tučné spropitné \n     a kdo mu proklouzne, tak toho nechytne, \n     kouzelník za dvacku vykouzlí pět bonů \n     a vítr na věži opřel se do zvonů, \n     \"Na zdraví nevěsty, na zdraví ženicha!\", \n     dvě sousta do kapsy a jednou do břicha, \n     náhle se za oknem objevil skřítek, \n     rozhrnul oponu z máminejch kytek, \n     pěkně se usmál a pěkně se podíval \n     a pak mi po očku do ucha zazpíval: \n\nR: [G]Dej mi ruku s[D]vou, studenou[Emi] od okenních s[Hmi/D]kel, \n   všichni tě m[C]ezi sebe zv[Hmi/D]ou \n   a j[C]á jsem t[D]u proto, [G]abys šel[Emi]. \n\n     Na plný obrátky letíme světem, \n     všechny ty pohádky patřily dětem, \n     dneska už se neplatí buchtama za skutky, \n     sudičky sesmolí kádrový posudky, \n     obložen prošlými dlužními úpisy, \n     koukám se z okna a vzpomínám na kdysi, \n     jak se mi za oknem objevil skřítek, \n     rozhrnul oponu z máminejch kytek, \n     pěkně se usmál a pěkně se podíval \n     a pak mi po očku do ucha zazpíval: \nR: \nR:",
        "created": 1365199247192,
        "updated": 1365199258981,
        "creatorId": "luteemsu35x",
        "id": "fokp8zah2mo",
        "_cid": ":7"
      },
      {
        "name": "Pijte vodu",
        "author": "Jaromír Nohavica",
        "lyrics": "R: [C]Pijte vodu, pijte pitnou vodu, pijte vodu a [G]nepijte [C]rum !Ź :/ \n\n[C]Jeden smutný ajznboňák pil na pátém nástupišti Gajerko[C]ňak. \n[C]Huba se mu slepila a diesellokomotiva ho [G]zabi[C]la.\n\n®: \n\nV rodině u Becherů pijou becherovku přímo ze džberů. \nProto všichni Becheři mají trable s játrama a páteří.\n\n®: \n\nPil som vodku značky Gorbačov a potom povedal som všeličo a voľačo. \nVyfásol som za to tri roky, teraz pijem chlórované patoky. ®: \n4.My jestežny chlopci z Warszawy, chodime pociungem za robotou do Ostravy. \nŠtery litry vodky i mnužstvo piv, bardzo fajny kolektiv. ®: \n5.Jedna paní v Americe ztrapnila se převelice. \nVypila na ex rum, poblila jim Bílý dům. ®:",
        "created": 1364680764756,
        "updated": 1364680771943,
        "creatorId": "luteemsu35x",
        "id": "dksbf7v69e1c",
        "_cid": ":5"
      }
  ]`