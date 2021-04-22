import { metadata, handler, titleAndAuthors } from '../parse'

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
      'Barn som bråkar : att hantera känslostarka barn i vardagen (Bo Hejlskov;Tina Wiman)'
    )

    expect(titleAndAuthors(line)).toEqual({
      title: 'Barn som bråkar',
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

It’s not about giving a fuck about everything your partner gives a fuck about; it’s about giving a fuck about your partner regardless of the fucks he or she gives. That’s unconditional love, baby.
==========
Barn som bråkar : att hantera känslostarka barn i vardagen (Bo Hejlskov;Tina Wiman)
- Your Highlight on page 110 | Location 1684-1699 | Added on Sunday, August 16, 2020 9:57:33 PM

annat ändras? Detta kan visserligen betyda att vi föräldrar ibland måste göra upp med våra inre föreställningar om hur saker måste vara. Men om vi inte ändrar förutsättningarna kan vi inte heller räkna med att bråken blir färre. Många bråk uppstår när barnen – eller vi vuxna – är hungriga eller trötta. Det kan vara innan maten eller när barnen kommer hem från skolan eller vi från jobbet. Det betyder att det ofta går att förutse när på dagen det kommer att bli bråk och att vi då kan planera in fungerande aktiviteter, mellanmål eller tid för vila. Tänk på att även vi vuxna behöver vila och äta på strategiska tider för att orka förebygga bråk. Håll utkik efter de situationer där barnen inte bråkar, om det finns några. Vad är det som är annorlunda då? Försök att använda det även i andra situationer. Gör mer av de aktiviteter som fungerar. Mer tid i fungerande situationer betyder mindre tid med bråk. Se till att förbereda med bra strukturer vid gemensamma utflykter. Om familjen tillsammans ska bestämma efterhand vad som ska hända kommer det definitivt att bli bråk. Gör i stället ett schema för hur dagen ska se ut. Bestäm i förväg var ni ska äta och när det bär av hemåt igen. Och låt gärna barnen vara med och bestämma, strukturen kan göras i god tid tillsammans med dem. Men det är viktigt att komma ihåg att det alltid är föräldrarna som har sista ordet. Se inte syskonbråk som ett föräldramisslyckande. Försök i stället att se det som situationer som dels ska lösas här och nu, dels förebyggas på sikt. Då är det lättare att hålla sig lugn. Vi har sagt det förut, men det tål att upprepas – syskon bråkar med varandra. Det är något mycket vardagligt.
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

“He who fears death will never do anything worthy of a living man,” Seneca once
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2227 | Added on Tuesday, March 23, 2021 10:59:39 PM

“He who fears death will never do anything worthy of a living man,” Seneca once said.
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2228 | Added on Tuesday, March 23, 2021 10:59:48 PM

“He who fears death will never do anything worthy of a living man,” Seneca once said. Alter that: He who will do anything to avoid failure will almost
==========
Ego is the Enemy (The Way, the Enemy and the Key) (Holiday, Ryan)
- Your Highlight on page 193 | Location 2227-2228 | Added on Tuesday, March 23, 2021 10:59:53 PM

“He who fears death will never do anything worthy of a living man,” Seneca once said. Alter that: He who will do anything to avoid failure will almost certainly do something worthy of a failure.
==========`

    const req: any = {
      body: JSON.stringify({ data }),
    }

    const res: any = { json: jest.fn() }

    await handler(req, res)

    expect(res.json.mock.calls[0][0]).toMatchSnapshot()
  })
})
