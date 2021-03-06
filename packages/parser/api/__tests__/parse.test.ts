import { findIssues, metadata, handler, titleAndAuthors } from '../parse'

describe('#metadata', () => {
  test('parses page, location and date from line', () => {
    const line = Buffer.from(
      '- Your Highlight on page 94 | Location 1388-1389 | Added on Monday, April 8, 2019 9:52:25 PM'
    )

    expect(metadata(line)).toEqual({
      page: '94',
      location: '1388',
      date: '2019-04-08T19:52:25.000Z',
    })
  })

  test('handles metadata with single location', () => {
    const line = Buffer.from(
      '- Your Highlight on page 94 | Location 1388 | Added on Monday, April 8, 2019 9:52:25 PM'
    )

    expect(metadata(line)).toEqual({
      page: '94',
      location: '1388',
      date: '2019-04-08T19:52:25.000Z',
    })
  })

  test('handles metadata with roman page number', () => {
    const line = Buffer.from(
      '- Your Highlight on page xvii | Location 138-141 | Added on Monday, April 12, 2021 9:53:39 PM'
    )

    expect(metadata(line)).toEqual({
      page: 'xvii',
      location: '138',
      date: '2021-04-12T19:53:39.000Z',
    })
  })

  test('handles metadata without page', () => {
    const line = Buffer.from(
      '- Your Highlight on Location 76-78 | Added on Saturday, October 31, 2020 11:52:03 PM'
    )

    expect(metadata(line)).toEqual({
      page: '',
      location: '76',
      date: '2020-10-31T22:52:03.000Z',
    })
  })

  test('handles metadata without location', () => {
    const line = Buffer.from(
      '- Your Highlight on page 76 | Added on Saturday, October 31, 2020 11:52:03 PM'
    )

    expect(metadata(line)).toEqual({
      page: '76',
      location: '',
      date: '2020-10-31T22:52:03.000Z',
    })
  })

  test('handles metadata without date', () => {
    const line = Buffer.from('- Your Highlight on page 76 | Location 138-14')

    expect(metadata(line)).toEqual({
      page: '76',
      location: '138',
      date: null,
    })
  })
})

describe('#titleAndAuthors', () => {
  test('handles missing title', () => {
    // Swallow error logging
    jest.spyOn(console, 'error').mockImplementation(() => {})

    const line = Buffer.from('')

    expect(titleAndAuthors(line)).toEqual({
      title: '',
      authors: [],
      series: null,
    })
  })

  test('handles only title', () => {
    const line = Buffer.from('Make Time')

    expect(titleAndAuthors(line)).toEqual({
      title: 'Make Time',
      authors: [],
      series: null,
    })
  })

  test('handles parsing title and author', () => {
    const line = Buffer.from('Make Time (Knapp, Jake)')

    expect(titleAndAuthors(line)).toEqual({
      title: 'Make Time',
      authors: ['Jake Knapp'],
      series: null,
    })
  })

  test('handles parsing title and multiple authors', () => {
    const line = Buffer.from(
      'The Daily Stoic (Holiday, Ryan;Hanselman, Stephen)'
    )

    expect(titleAndAuthors(line)).toEqual({
      title: 'The Daily Stoic',
      authors: ['Ryan Holiday', 'Stephen Hanselman'],
      series: null,
    })
  })

  test('handles parsing title and multiple authors without lastname, firstname', () => {
    const line = Buffer.from(
      'Barn som br??kar : att hantera k??nslostarka barn i vardagen (Bo Hejlskov;Tina Wiman)'
    )

    expect(titleAndAuthors(line)).toEqual({
      title: 'Barn som br??kar',
      authors: ['Bo Hejlskov', 'Tina Wiman'],
      series: null,
    })
  })

  test('handles parsing title, author and series', () => {
    const line = Buffer.from(
      'Astrophysics for People in a Hurry (Astrophysics for People in a Hurry Series) (de Grasse Tyson, Neil)'
    )

    expect(titleAndAuthors(line)).toEqual({
      title: 'Astrophysics for People in a Hurry',
      authors: ['Neil de Grasse Tyson'],
      series: 'Astrophysics for People in a Hurry Series',
    })
  })
})

describe('#handler', () => {
  test('can parse two entries', async () => {
    const data = `Samlingsvolym (Lars Kepler)
- Your Bookmark on Location 26219 | Added on Tuesday, August 9, 2016 7:14:43 PM


==========
Deep Work: Rules for Focused Success in a Distracted World (Newport, Cal)
- Your Highlight on page 50 | Location 601-602 | Added on Tuesday, March 19, 2019 5:28:00 PM

of one, a lonely voice issuing ex
==========
The Subtle Art of Not Giving a F*ck (Manson, Mark)
- Your Highlight on page 177 | Location 2338-2340 | Added on Monday, May 27, 2019 10:26:05 PM

Rather, a healthy relationship is when two people solve their own problems in order to feel good about each other.
==========
The Subtle Art of Not Giving a F*ck (Manson, Mark)
- Your Highlight on page 181 | Location 2384-2386 | Added on Monday, May 27, 2019 10:30:32 PM

It???s not about giving a fuck about everything your partner gives a fuck about; it???s about giving a fuck about your partner regardless of the fucks he or she gives. That???s unconditional love, baby.
==========
Barn som br??kar : att hantera k??nslostarka barn i vardagen (Bo Hejlskov;Tina Wiman)
- Your Highlight on page 110 | Location 1684-1699 | Added on Sunday, August 16, 2020 9:57:33 PM

annat ??ndras? Detta kan visserligen betyda att vi f??r??ldrar ibland m??ste g??ra upp med v??ra inre f??rest??llningar om hur saker m??ste vara. Men om vi inte ??ndrar f??ruts??ttningarna kan vi inte heller r??kna med att br??ken blir f??rre. M??nga br??k uppst??r n??r barnen ??? eller vi vuxna ??? ??r hungriga eller tr??tta. Det kan vara innan maten eller n??r barnen kommer hem fr??n skolan eller vi fr??n jobbet. Det betyder att det ofta g??r att f??rutse n??r p?? dagen det kommer att bli br??k och att vi d?? kan planera in fungerande aktiviteter, mellanm??l eller tid f??r vila. T??nk p?? att ??ven vi vuxna beh??ver vila och ??ta p?? strategiska tider f??r att orka f??rebygga br??k. H??ll utkik efter de situationer d??r barnen inte br??kar, om det finns n??gra. Vad ??r det som ??r annorlunda d??? F??rs??k att anv??nda det ??ven i andra situationer. G??r mer av de aktiviteter som fungerar. Mer tid i fungerande situationer betyder mindre tid med br??k. Se till att f??rbereda med bra strukturer vid gemensamma utflykter. Om familjen tillsammans ska best??mma efterhand vad som ska h??nda kommer det definitivt att bli br??k. G??r i st??llet ett schema f??r hur dagen ska se ut. Best??m i f??rv??g var ni ska ??ta och n??r det b??r av hem??t igen. Och l??t g??rna barnen vara med och best??mma, strukturen kan g??ras i god tid tillsammans med dem. Men det ??r viktigt att komma ih??g att det alltid ??r f??r??ldrarna som har sista ordet. Se inte syskonbr??k som ett f??r??ldramisslyckande. F??rs??k i st??llet att se det som situationer som dels ska l??sas h??r och nu, dels f??rebyggas p?? sikt. D?? ??r det l??ttare att h??lla sig lugn. Vi har sagt det f??rut, men det t??l att upprepas ??? syskon br??kar med varandra. Det ??r n??got mycket vardagligt.
==========
`

    const req: any = {
      body: JSON.stringify({ data }),
    }

    const res: any = { json: jest.fn() }

    await handler(req, res)

    expect(res.json.mock.calls[0][0]).toMatchSnapshot()
  })

  test('only include the latest if multiple clippings', async () => {
    const data = `Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2227 | Added on Tuesday, March 23, 2021 10:59:33 PM

???He who fears death will never do anything worthy of a living man,??? Seneca once
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2227 | Added on Tuesday, March 23, 2021 10:59:39 PM

???He who fears death will never do anything worthy of a living man,??? Seneca once said.
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2228 | Added on Tuesday, March 23, 2021 10:59:48 PM

???He who fears death will never do anything worthy of a living man,??? Seneca once said. Alter that: He who will do anything to avoid failure will almost
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2228 | Added on Tuesday, March 23, 2021 10:59:53 PM

???He who fears death will never do anything worthy of a living man,??? Seneca once said. Alter that: He who will do anything to avoid failure will almost certainly do something worthy of a failure.
==========`

    const req: any = {
      body: JSON.stringify({ data }),
    }

    const res: any = { json: jest.fn() }

    await handler(req, res)

    expect(res.json.mock.calls[0][0]).toMatchSnapshot()
  })

  test('handle highlights without title row', async () => {
    // Swallow error logging
    jest.spyOn(console, 'error').mockImplementation(() => {})

    const data = `Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2227 | Added on Tuesday, March 23, 2021 10:59:33 PM

???He who fears death will never do anything worthy of a living man,??? Seneca once said. Alter that: He who will do anything to avoid failure will almost certainly do something worthy of a failure.
==========
- Your Highlight on page 199 | Location 3000-3100 | Added on Tuesday, March 23, 2021 10:59:53 PM

This test line doesn't contain a title row
==========`

    const req: any = {
      body: JSON.stringify({ data }),
    }

    const res: any = { json: jest.fn() }

    await handler(req, res)

    expect(res.json.mock.calls[0][0]).toMatchSnapshot()
  })
})

describe('#findIssues', () => {
  test('no issues if nothing is wrong', () => {
    expect(findIssues({ containsSimilar: false, bodyLength: 20 })).toEqual([])
  })

  test('handle issue for similar entry', () => {
    expect(findIssues({ containsSimilar: true, bodyLength: 20 })).toEqual([
      'similar',
    ])
  })

  test('handle short entries', () => {
    expect(findIssues({ containsSimilar: true, bodyLength: 10 })).toEqual([
      'similar',
      'shortContent',
    ])
  })
})
