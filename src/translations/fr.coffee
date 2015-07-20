I18n.translations.fr =
  # i18n pluralization, number, currency and date configuration
  date:
    formats:
      default: '%d/%m/%Y'
      short: '%-d %b'
      long: 'le %-d %B %Y'
    day_names: ['dimanche', 'lundi', 'mardi', 'mercredi',
      'jeudi', 'vendredi', 'samedi']
    abbr_day_names: ['dim.', 'lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.']
    month_names: ['~', 'janvier', 'février', 'mars', 'avril', 'mai',
      'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']
    abbr_month_names: ['~', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.']

  time:
    formats:
      default: '%d/%m/%Y %H:%M'
      time: '%H:%M'
      short: '%d %b %H:%M'
      long: '%A %d %B %Y %H:%M:%S %Z'
      only_second: '%S'
    am: 'matin'
    pm: 'après-midi'

  number:
    format:
      precision: 3
      separator: ','
      delimiter: ' '
    currency:
      format:
        unit: '€'
        precision: 2
        format: '%n %u'

  # Custom keys
  ttl:
    welcome: 'Une terrible menace sommeille dans les ombres...'

  nav:
    rankings: 'Classements'
    welcome: 'Accueil'

  test:
    one: 'Salut le monde !'
    other: 'Salut tout le monde !'
